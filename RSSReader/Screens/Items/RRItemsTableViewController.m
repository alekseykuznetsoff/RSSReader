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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.model abortLoading];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.model loadItemsOfChannel:self.channel withBlock:^(NSArray *items, NSError *error)
         {
             if (items.count) {
                 weakSelf.objects = items;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf.tableView reloadData];
                 });
             }
             //todo: error handling
         }];
    });
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
