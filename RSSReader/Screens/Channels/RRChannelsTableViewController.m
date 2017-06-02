//
//  RRChannelsTableViewController.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRChannelsTableViewController.h"
#import "RRDataManager.h"
#import "RRChannel+CoreDataClass.h"

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"URL %@", [[weakSelf.addChannelAlertController textFields][0] text]);
    }];
    okAction.enabled = NO;
    [alert addAction:okAction];
    return alert;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UIAlertAction *okAction = self.addChannelAlertController.actions.lastObject;
    okAction.enabled = finalString.length > 0;
    return YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Basic" forIndexPath:indexPath];
    RRChannel *channel = self.objects[indexPath.row];
    cell.textLabel.text = channel.link;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end