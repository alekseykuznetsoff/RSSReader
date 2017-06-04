//
//  RRChannelsTableViewController.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRChannelsTableViewController.h"
#import "RRDataManager.h"
#import "RRItemsTableViewController.h"

@interface RRChannelsTableViewController () <UITextFieldDelegate>

@property (nonatomic) RRDataManager *model;
@property (nonatomic) NSArray *objects;

@property (nonatomic) UIAlertController *addChannelAlertController;
- (IBAction)addChannelAction:(UIBarButtonItem *)sender;

@end

@implementation RRChannelsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objects = [self.model allChannels];
    
    self.title = @"Channels";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - --Setters&Getters
- (RRDataManager *)model
{
    if (!_model) {
        _model = [RRDataManager sharedInstance];
    }
    return _model;
}

- (UIAlertController *)addChannelAlertController
{
    if (!_addChannelAlertController) {
        _addChannelAlertController = [self createAddChannelAlertController];
    }
    return _addChannelAlertController;
}

#pragma mark - UI Handlers
- (IBAction)addChannelAction:(UIBarButtonItem *)sender
{
    [self presentViewController:self.addChannelAlertController
                       animated:YES
                     completion:nil];
}

#pragma mark - --UIAlertController
- (UIAlertController *)createAddChannelAlertController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add new feed" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"URL";
        textField.delegate = weakSelf;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *link = [[weakSelf.addChannelAlertController textFields][0] text];
        [weakSelf addNewChannnel:[weakSelf.model createChannel:link]];
    }];
    okAction.enabled = NO;
    [alert addAction:okAction];
    return alert;
}

- (void)addNewChannnel:(RRChannel *)channel
{
    if (channel) {
        NSUInteger index = self.objects.count;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSMutableArray *mArray = [self.objects mutableCopy];
        [mArray addObject:channel];
        self.objects = [mArray copy];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UIAlertAction *okAction = self.addChannelAlertController.actions.lastObject;
    okAction.enabled = finalString.length > 0;
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:NSStringFromClass(RRItemsTableViewController.class) sender:indexPath];
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
    RRChannel *channel = self.objects[indexPath.row];
    UITableViewCell *cell;
    if (channel.title.length) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Subtitle" forIndexPath:indexPath];
        cell.textLabel.text = channel.title;
        cell.detailTextLabel.text = channel.link;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Basic" forIndexPath:indexPath];
        cell.textLabel.text = channel.link;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RRChannel *channel = self.objects[indexPath.row];
        NSMutableArray *mArray = [self.objects mutableCopy];
        [mArray removeObject:channel];
        self.objects = [mArray copy];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.model deleteChannel:channel];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass(RRItemsTableViewController.class)]) {
        RRItemsTableViewController *vc = segue.destinationViewController;
        NSUInteger index = [[self.tableView indexPathForSelectedRow] row];
        [vc setChannel:self.objects[index]];
    }
}

@end
