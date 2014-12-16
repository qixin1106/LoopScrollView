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




- (void)loadTestData
{
    self.imageUrls = [NSMutableArray array];
    
    [self.imageUrls addObject:@"http://pic21.nipic.com/20120609/6434097_090837003325_2.jpg"];
    [self.imageUrls addObject:@"http://www.geyinzan.com/9fd66971-photo-idate/album/images/cms/20130228/20130228094535195Eh3.jpg"];
    [self.imageUrls addObject:@"http://image.zcool.com.cn/2013/52/40/m_1375164283803.jpg"];
    [self.imageUrls addObject:@"http://pic26.nipic.com/20130112/11528051_231738456000_2.jpg"];
    [self.imageUrls addObject:@"http://pic.58pic.com/58pic/11/26/94/20i58PICndR.jpg"];
    [self.imageUrls addObject:@"http://img.aiimg.com/uploads/allimg/140530/1-140530230213.jpg"];
    [self.imageUrls addObject:@"http://pic2.ooopic.com/11/73/34/70bOOOPIC6d_1024.jpg"];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MARK: 测试数据
    [self loadTestData];

    //MARK: 使用示例
    self.loopScrollView = [[QXLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    self.loopScrollView.delegate = self;
    [self.view addSubview:self.loopScrollView];

    self.loopScrollView.imgUrls = self.imageUrls;

}

#pragma mark - QXLoopScrollViewDelegate
- (void)loopScrollViewDidSelectIndex:(NSInteger)index
{
    NSLog(@"选择%ld",index);
}

@end
