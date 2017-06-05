//
//  RRXMLParser.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 03.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRXMLParser : NSObject

- (void)parseData:(NSData *)data
      channelLink:(NSString *)link
            block:(void (^)(NSError *error))block;

- (void)abortParsing;

@end
