//
//  ViewController.m
//  LoopScrollView
//
//  Created by Qixin on 14/12/15.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "ViewController.h"
#import "DetailVC.h"
@interface ViewController ()
@end

@implementation ViewController


- (void)onClick:(UIButton*)sender
{
    DetailVC *vc = [[DetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setFrame:CGRectMake(100, 100, 100, 100)];
    [pushBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [pushBtn setTitle:@"PUSH" forState:UIControlStateNormal];
    [self.view addSubview:pushBtn];
}


@end
