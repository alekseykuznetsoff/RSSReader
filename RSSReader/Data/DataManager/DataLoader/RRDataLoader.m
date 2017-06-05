//
//  RRDataLoader.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 05.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRDataLoader.h"
#import <UIKit/UIKit.h>

@interface RRDataLoader ()

@property (atomic) NSURLSessionDataTask *task;

@end

@implementation RRDataLoader

#pragma mark - --Setters&Getters
- (void)loadDataLink:(NSString *)link withBlock:(void (^)(NSData *data, NSError *error))block
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:link];
    
    self.task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        block == nil ?: block(data, error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [self.task resume];
}

- (void)abortLoading
{
    [self.task cancel];
    self.task = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
