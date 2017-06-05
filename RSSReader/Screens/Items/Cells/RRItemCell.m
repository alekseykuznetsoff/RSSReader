//
//  RRItemCell.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 05.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRItemCell.h"
#import "RRItem.h"

@interface RRItemCell ()

@property (nonatomic) RRItem *item;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleTrailing;

@end

@implementation RRItemCell

- (void)setModel:(id)model
{
    self.item = (RRItem *)model;
    [self configureCell];
}

- (void)configureCell
{
    CGFloat widthRootVC = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.width;
    CGFloat preferredMaxLayoutWidth = widthRootVC - self.constraintTitleLeading.constant - self.constraintTitleTrailing.constant;
    self.titleLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    self.descriptionLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    self.titleLabel.text = self.item.title;
    self.descriptionLabel.text = self.item.text;
    
    
//    self.nameLabel.text = self.asset.filename;
//    self.currentTimeLabel.text = [NSString stringWithSeconds:self.asset.timeSec];
//    self.durationLabel.text = [NSString stringWithSeconds:self.asset.durationSec];
//    self.sizeLabel.text = self.asset.size;
//    self.extensionLabel.text = self.asset.extension;
//    
//    self.progressView.progress = self.asset.progress;
//    
//    if (self.asset.isSelected) {
//        self.progressView.hidden = YES;
//        self.currentTimeLabel.hidden = YES;
//        self.contentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
//    } else {
//        self.progressView.hidden = NO;
//        self.currentTimeLabel.hidden = NO;
//        self.contentView.backgroundColor = [UIColor clearColor];
//    }
}


@end
