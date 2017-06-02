//
//  RRItemsTableViewController.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRItemsTableViewController.h"
#import "RRDataManager.h"

@interface RRItemsTableViewController ()

@property (nonatomic) RRChannel *channel;
@property (nonatomic) RRDataManager *model;
@property (nonatomic) NSArray *objects;

@end

@implementation RRItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.channel);
}

#pragma mark - --Setters&Getters
- (RRDataManager *)model
{
    if (!_model) {
        _model = [RRDataManager sharedInstance];
    }
    return _model;
}

- (void)setChannel:(RRChannel *)channel
{
    _channel = channel;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

@end
