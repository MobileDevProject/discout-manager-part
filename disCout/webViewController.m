//
//  webViewController.m
//  MapView
//
//  Created by Chris on 8/13/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//
#import "SWRevealViewController.h"
#import "webViewController.h"

@interface webViewController ()

@end

@implementation webViewController
{
    NSURLRequest* urlReq;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *theConfiguration =[[WKWebViewConfiguration alloc] init];
    CGRect webViewRect = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70);
    self.webView = [[WKWebView alloc] initWithFrame:webViewRect configuration:theConfiguration];
    urlReq =  [[NSURLRequest alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Unhide the navbar so that user can navigate back to mapView
    //self.navigationController.navigationBarHidden = NO;
    
    urlReq = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlReq];
    [self.webView setFrame:CGRectMake(0, 70,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-140)];//140 = tabbar height + topbar height
    [self.view addSubview:self.webView];
    
    //side part
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goMSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
- (IBAction)goMBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
