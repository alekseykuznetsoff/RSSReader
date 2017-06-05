//
//  RRWebViewController.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 06.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRItem;

@interface RRWebViewController : UIViewController

- (void)setItem:(RRItem *)item;

@end
