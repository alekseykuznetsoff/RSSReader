//
//  RRDataManager.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRDataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RRXMLParser.h"

@interface RRDataManager ()

@property RRXMLParser *parser;

@end

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
    NSUInteger count = [RRChannel MR_countOfEntities];
    if (!count) {
        NSArray *channels = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PresetChannels" ofType:@"plist"]];
        for (int i = 0; i<channels.count; i++) {
            RRChannel *channel = [RRChannel MR_createEntity];
            channel.index = i;
            channel.link = channels[i];
        }
    }
}

- (void)storeData
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

#pragma mark - --Channels
- (NSArray *)allChannels
{
    return [RRChannel MR_findAllSortedBy:@"index" ascending:YES];
}

- (RRChannel *)createChannel:(NSString *)link
{
    //Here there can be a check on validity of the link
    
    RRChannel *lastChannel = [[self allChannels] lastObject];
    RRChannel *channel = [RRChannel MR_createEntity];
    channel.index = lastChannel.index + 1;
    channel.link = link;
    return channel;
}

- (void)deleteChannel:(RRChannel *)channel
{
    [channel MR_deleteEntity];
}

#pragma mark - --Items
- (void)loadItemsOfChannel:(RRChannel *)channel withBlock:(void (^)(NSArray *items, NSError *error))block
{
    __weak typeof(self) weakSelf = self;
    self.parser = [RRXMLParser parserWithChannel:channel withBlock:^(NSArray *items, NSError *error) {
        if (items.count && block) {
            block(items, error);
        }
        if (!items && !error && block) {
            NSLog(@"!!!!!!!!!!!");
        }
        weakSelf.parser = nil;
    }];
    [self.parser parse];
}

- (void)abortLoading
{
    [self.parser cancel];
    self.parser = nil;
}


@end
