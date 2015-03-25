// main.m
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

#import <Foundation/Foundation.h>
#import "Dalton.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSError *error = nil;
        NSString *XMLFilePath = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"sample.xml"];
        id<DLTFeed> feed = [DLTFeed feedWithData:[NSData dataWithContentsOfFile:XMLFilePath] error:&error];

        if (error) {
            NSLog(@"[Error] %@", error);
            return 1;
        }

        NSLog(@"Feed title is %@", feed.title);
        NSLog(@"Feed was last updated at %@", feed.updated);
        for (id<DLTFeedEntry> entry in feed.entries) {
            NSLog(@"Entry title is %@ link is %@ updated at %@", entry.title, entry.link, entry.updated);
        }
    }
    return 0;
}
