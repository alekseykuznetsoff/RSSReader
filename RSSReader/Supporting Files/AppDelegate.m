//
//  AppDelegate.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RRDataManager.h"

@interface AppDelegate ()

@property (nonatomic) RRDataManager *model;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
//    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:CORE_DATA_STORE_NAME];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.model storeData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.model storeData];
}

#pragma mark - --Setters&Getters
- (RRDataManager *)model
{
    if (!_model) {
        _model = [RRDataManager sharedInstance];
    }
    return _model;
}

@end
