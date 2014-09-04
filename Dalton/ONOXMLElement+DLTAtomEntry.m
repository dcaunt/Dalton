// ONOXMLElement+DLTAtomEntry.m
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

#import "ONOXMLElement+DLTAtomEntry.h"

@implementation ONOXMLElement (DLTAtomEntry)

- (NSString *)title {
    return [[self firstChildWithTag:@"title"] stringValue];
}

- (NSURL *)link {
    ONOXMLElement *link = nil;
    for (ONOXMLElement *element in [self childrenWithTag:@"link"]) {
        if (element[@"rel"] == nil) {
            link = element;
            break;
        }
    }
    if (link != nil) {
        return [NSURL URLWithString:link[@"href"]];
    }

    return nil;
}

- (NSDate *)updated {
    return [[self firstChildWithTag:@"updated"] dateValue];
}

@end
