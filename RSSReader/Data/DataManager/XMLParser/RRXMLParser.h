//
//  RRXMLParser.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 03.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRChannel;

@interface RRXMLParser : NSObject

+ (instancetype)parserWithChannel:(RRChannel *)channel withBlock:(void (^)(NSArray *items, NSError *error))block;
- (void)parse;
- (void)cancel;

@end
