// DLTAtomFeed.m
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

#import "DLTAtomFeed.h"
#import "DLTFeedEntry.h"

@interface DLTAtomFeedEntry : NSObject <DLTFeedEntry>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *link;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSDictionary *links;
@end

@implementation DLTAtomFeedEntry

@synthesize title = _title;
@synthesize updated = _updated;
@synthesize identifier = _identifier;
@synthesize links = _links;

- (instancetype)initWithElement:(ONOXMLElement *)element {
    self = [super init];
    if (self) {
        _title = [[element firstChildWithTag:@"title"] stringValue];
        _updated = [[element firstChildWithTag:@"updated"] dateValue];
        _identifier = [[element firstChildWithTag:@"id"] stringValue];

        NSMutableDictionary *links = [NSMutableDictionary dictionary];
        for (ONOXMLElement *linkElement in [element childrenWithTag:@"link"]) {
            NSString *href = linkElement[@"href"];
            if (href == nil) {
                continue;
            }
            NSString *rel = linkElement[@"rel"] ? linkElement[@"rel"] : @"";
            links[rel] = [NSURL URLWithString:href];
            if ([rel isEqualToString:@""]) {
                _link = links[rel];
            }
        }
        _links = [links copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, id: %@, title: %@, updated: %@, links: %@>",
                                      [self class], self, _identifier, _title, _updated, _link];
}

@end

@interface DLTAtomFeed ()
@property (nonatomic, copy, readonly) ONOXMLDocument *document;
@end

@implementation DLTAtomFeed

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize updated = _updated;
@synthesize entries = _entries;

- (instancetype)initWithDocument:(ONOXMLDocument *)document {
    self = [super init];
    if (self) {
        _document = [document copy];
        _title = [[document.rootElement firstChildWithTag:@"title"] stringValue];
        _subtitle = [[document.rootElement firstChildWithTag:@"subtitle"] stringValue];
        _updated = [[document.rootElement firstChildWithTag:@"updated"] dateValue];
        _entries = [self entriesFromDocumentElements:[self.document.rootElement childrenWithTag:@"entry"]];
    }
    return self;
}

- (NSArray *)entriesFromDocumentElements:(NSArray *)documentElements {
    NSMutableArray *entries = [NSMutableArray array];
    for (ONOXMLElement *element in documentElements) {
        DLTAtomFeedEntry *entry = [[DLTAtomFeedEntry alloc] initWithElement:element];
        [entries addObject:entry];
    }
    return [entries copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, title: %@, subtitle: %@, updated: %@, entries: %@>",
                                      [self class], self, _title, _subtitle, _updated, _entries];
}

@end
