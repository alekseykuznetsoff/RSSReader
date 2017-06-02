//
//  RRItemsTableViewController.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 02.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRChannel;

@interface RRItemsTableViewController : UITableViewController

- (void)setChannel:(RRChannel *)channel;

@end
