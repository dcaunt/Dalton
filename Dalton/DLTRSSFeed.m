// DLTRSSFeed.m
//
// Copyright (c) 2014 David Caunt (http://davidcaunt.co.uk/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "DLTRSSFeed.h"
#import "DLTFeedEntry.h"

static NSDate * DLTRSSFeedDateFromElement(ONOXMLElement *element) {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz"; //RFC 2822
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
    });

    NSString *stringValue = [element stringValue];
    return [dateFormatter dateFromString:stringValue];
}

@interface DLTRSSFeedEntry : NSObject <DLTFeedEntry>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *link;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSDictionary *links;
@end

@implementation DLTRSSFeedEntry

@synthesize title = _title;
@synthesize updated = _updated;
@synthesize identifier = _identifier;
@synthesize links = _links;

- (instancetype)initWithElement:(ONOXMLElement *)element
{
    self = [super init];
    if (self) {
        _title = [[element firstChildWithTag:@"title"] stringValue];
        _updated = DLTRSSFeedDateFromElement([element firstChildWithTag:@"pubDate"]);
        _identifier = [[element firstChildWithTag:@"guid"] stringValue];
        _link = [NSURL URLWithString:[[element firstChildWithTag:@"link"] stringValue]];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, id: %@, title: %@, updated: %@, link: %@>",
            [self class], self, _identifier, _title, _updated, _link];
}

@end

@interface DLTRSSFeed ()
@property (nonatomic, copy, readonly) ONOXMLDocument *document;
@end

@implementation DLTRSSFeed

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize updated = _updated;
@synthesize entries = _entries;

- (instancetype)initWithDocument:(ONOXMLDocument *)document
{
    self = [super init];
    if (self) {
        _document = [document copy];

        ONOXMLElement *channel = [self.document.rootElement firstChildWithTag:@"channel"];
        _title = [[channel firstChildWithTag:@"title"] stringValue];
        _subtitle = [[channel firstChildWithTag:@"description"] stringValue];
        _updated = DLTRSSFeedDateFromElement([channel firstChildWithTag:@"lastBuildDate"]);
        _entries = [self entriesFromDocumentElements:[channel childrenWithTag:@"item"]];
    }
    return self;
}

- (NSArray *)entriesFromDocumentElements:(NSArray *)documentElements {
    NSMutableArray *entries = [NSMutableArray array];
    for (ONOXMLElement *element in documentElements) {
        DLTRSSFeedEntry *entry = [[DLTRSSFeedEntry alloc] initWithElement:element];
        [entries addObject:entry];
    }
    return [entries copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, title: %@, subtitle: %@, updated: %@, entries: %@>",
            [self class], self, _title, _subtitle, _updated, _entries];
}

@end
