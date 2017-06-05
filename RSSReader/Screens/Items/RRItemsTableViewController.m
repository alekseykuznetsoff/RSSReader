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
#import "RRItemCell.h"

@interface RRItemsTableViewController ()

@property (nonatomic) RRChannel *channel;
@property (nonatomic) RRDataManager *model;
@property (nonatomic) NSArray *objects;

@end

@implementation RRItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Loading...";
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.model abortLoadingItemsLink:self.channel.link];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
    } completion:nil];
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
        [weakSelf dataDidLoad];
    }];
}

- (void)dataDidLoad
{
    self.title = self.channel.title;
    NSSortDescriptor *dsc = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.objects = [self.channel.items sortedArrayUsingDescriptors:@[dsc]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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
    RRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RRItemCell.class) forIndexPath:indexPath];
    [cell setModel:item];
    return cell;
}

@end
