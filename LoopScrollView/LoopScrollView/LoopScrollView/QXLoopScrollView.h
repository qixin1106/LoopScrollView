//
//
//  Created by Qixin on 14-6-5.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//
//
/*
 //通用类似首焦轮播控件,可2方连续循环
 //init
 self.loopScrollView = [[QXLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, 140)];
 self.loopScrollView.delegate = self;
 [self.contentView addSubview:self.loopScrollView];
 

 //assgin
 //考虑到复用性,该数组是保存图片url的数组,不一定是服务器直接返回,传入数组时,请自行处理数组.
 //例如 @[@"http://xxxx/1.png",@"http://xxxx/2.png",@"http://xxxx/3.png"];
 self.loopScrollView.imgUrls = tempArray;


 //delegate
 #pragma mark - QXLoopScrollViewDelegate
 - (void)loopScrollViewDidSelectIndex:(NSInteger)index
 {
    //index为选中的第几张
 }
 */

#import <UIKit/UIKit.h>

@protocol QXLoopScrollViewDelegate;
@interface QXLoopScrollView : UIView
@property (weak, nonatomic) id<QXLoopScrollViewDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *imgUrls;
@property (strong, nonatomic) NSMutableArray *images;
@end



@protocol QXLoopScrollViewDelegate <NSObject>
- (void)loopScrollViewDidSelectIndex:(NSInteger)index;
@end
