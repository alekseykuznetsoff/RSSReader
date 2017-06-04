//
//  RRDataManager.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRChannel.h"

@interface RRDataManager : NSObject

+ (instancetype)sharedInstance;
- (void)storeData;

#pragma mark - --Channels
- (NSArray *)allChannels;
- (RRChannel *)createChannel:(NSString *)link;
- (void)deleteChannel:(RRChannel *)channel;

#pragma mark - --Items
- (void)loadItemsOfChannel:(RRChannel *)channel withBlock:(void (^)(NSArray *items, NSError *error))block;
- (void)abortLoading;

@end
