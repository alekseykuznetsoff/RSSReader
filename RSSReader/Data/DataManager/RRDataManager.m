//
//  RRDataManager.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRDataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RRChannel+CoreDataClass.h"

@implementation RRDataManager

+ (instancetype)sharedInstance
{
    static RRDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    if ((self = [super init])){
        [self createPresetChannelsIfNeeded];
    }
    return self;
}

- (void)createPresetChannelsIfNeeded
{
    NSArray *allCannels = [RRChannel MR_findAll];
    if (!allCannels.count) {
        NSArray *channels = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PresetChannels" ofType:@"plist"]];
        for (int i = 0; i<channels.count; i++) {
            RRChannel *channel = [RRChannel MR_createEntity];
            channel.index = i;
            channel.link = channels[i];
        }
    }
}

#pragma mark - --Channels
- (NSArray *)allChannels
{
    return [RRChannel MR_findAllSortedBy:@"index" ascending:YES];
}

@end
