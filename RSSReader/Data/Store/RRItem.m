//
//  RRItem.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 04.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRItem.h"
#import "NSDate+InternetDateTime.h"

@implementation RRItem

- (void)mapperFoundString:(NSString *)string forElementNamed:(NSString *)elementName
{
    if ([elementName isEqualToString:@"dc:creator"]) {
        self.author = string;
    }
    if ([elementName isEqualToString:@"link"]) {
        self.link = string;
    }
    if ([elementName isEqualToString:@"pubDate"]) {
        self.pubDate = string;
        self.date = [NSDate dateFromInternetDateTimeString:string formatHint:DateFormatHintRFC822];
    }
    if ([elementName isEqualToString:@"description"]) {
        self.text = string;
    }
    if ([elementName isEqualToString:@"title"]) {
        self.title = string;
    }
}

@end
