//
//  RRDataManager.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRDataManager : NSObject

+ (instancetype)sharedInstance;
- (void)storeData;

#pragma mark - --Channels
- (NSArray *)allChannels;


@end
