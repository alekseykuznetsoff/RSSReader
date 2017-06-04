//
//  RRChannel.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 04.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRChannel.h"

@implementation RRChannel

- (void)mapperFoundString:(NSString *)string forElementNamed:(NSString *)elementName
{
    if ([elementName isEqualToString:@"title"]) {
        self.title = string;
    }
}

@end

