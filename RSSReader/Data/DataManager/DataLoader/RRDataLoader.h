//
//  RRDataLoader.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 05.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRDataLoader : NSObject

- (void)loadDataLink:(NSString *)link withBlock:(void (^)(NSData *data, NSError *error))block;
- (void)abortLoading;

@end
