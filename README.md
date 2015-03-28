Dalton
======

[![Build Status](https://img.shields.io/travis/dcaunt/Dalton.svg)](https://travis-ci.org/dcaunt/Dalton) [![Pod](https://img.shields.io/cocoapods/v/Dalton.svg)](http://cocoapods.org/pods/Dalton)

A simple RSS & Atom feed parser, built upon [Ono](https://github.com/mattt/Ono).

Requires Xcode 6.

## Usage

Parsing feeds is simple. You don't need to know ahead of time whether you're parsing an RSS or Atom feed, and Dalton abstracts away the differences.

```objective-c
NSError *error = nil;
NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"xml"];
NSData *feedData = [NSData dataWithContentsOfURL:fileURL];
id<DLTFeed> feed = [DLTFeed feedWithData:feedData error:&error];

NSLog(@"Feed title is %@", feed.title);
NSLog(@"Feed was last updated at %@", feed.updated);
for (id<DLTFeedEntry> entry in feed.entries) {
    NSLog(@"Entry title is %@ link is %@", entry.title, entry.link);
}
```

## Contact 

[@dcaunt](https://twitter.com/dcaunt)

## License

MIT. See LICENSE for more details.
