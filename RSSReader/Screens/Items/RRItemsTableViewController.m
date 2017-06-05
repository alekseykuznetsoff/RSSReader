//
//  RRItemsTableViewController.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRItemsTableViewController.h"
#import "RRDataManager.h"
#import "RRItem.h"

@interface RRItemsTableViewController ()

@property (nonatomic) RRChannel *channel;
@property (nonatomic) RRDataManager *model;
@property (nonatomic) NSArray *objects;

@end

@implementation RRItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Loading...";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.model abortLoadingItemsLink:self.channel.link];
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
    [self loadData];
}

#pragma mark - Load Data
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.model loadItemsLink:[self.channel.link copy] withBlock:^(NSError *error) {
        //todo: error handling
        weakSelf.title = weakSelf.channel.title;
        weakSelf.objects = weakSelf.channel.items.allObjects;
        [weakSelf.tableView reloadData];
    }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRItem *item = self.objects[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Subtitle" forIndexPath:indexPath];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.text;
    return cell;
}

@end
