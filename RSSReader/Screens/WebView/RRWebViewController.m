//
//  RRWebViewController.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 06.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRWebViewController.h"
#import "RRItem.h"

@interface RRWebViewController () <UIWebViewDelegate>

@property (nonatomic) RRItem *item;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Loading...";

    NSURL *url = [NSURL URLWithString:self.item.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSURL *url = [NSURL URLWithString:@"about:blank"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.title = @"Loading...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
