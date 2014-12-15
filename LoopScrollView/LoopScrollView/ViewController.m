//
//  ViewController.m
//  LoopScrollView
//
//  Created by Qixin on 14/12/15.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "ViewController.h"
#import "QXLoopScrollView.h"

@interface ViewController () <QXLoopScrollViewDelegate>
@property (strong, nonatomic) QXLoopScrollView *loopScrollView;
@property (strong, nonatomic) NSMutableArray *imageUrls;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageUrls = [NSMutableArray array];
    
    [self.imageUrls addObject:@"http://pic21.nipic.com/20120609/6434097_090837003325_2.jpg"];
    [self.imageUrls addObject:@"http://www.geyinzan.com/9fd66971-photo-idate/album/images/cms/20130228/20130228094535195Eh3.jpg"];
    [self.imageUrls addObject:@"http://img.sccnn.com//simg/338/16390.jpg"];
    [self.imageUrls addObject:@"http://img.sccnn.com//simg/338/16392.jpg"];
    [self.imageUrls addObject:@"http://img.sccnn.com//simg/338/16389.jpg"];
    [self.imageUrls addObject:@"http://img.sccnn.com//simg/338/16388.jpg"];
    [self.imageUrls addObject:@"http://img.sccnn.com//simg/338/16387.jpg"];

    
    //模拟app首页焦点图轮播效果
    self.loopScrollView = [[QXLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    self.loopScrollView.delegate = self;
    [self.view addSubview:self.loopScrollView];
    
    //赋值
    self.loopScrollView.imgUrls = self.imageUrls;

}

#pragma mark - QXLoopScrollViewDelegate
- (void)loopScrollViewDidSelectIndex:(NSInteger)index
{
    NSLog(@"选择%ld",index);
}

@end
