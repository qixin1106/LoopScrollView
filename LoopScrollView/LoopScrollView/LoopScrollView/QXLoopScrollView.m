//
//
//  Created by Qixin on 14-6-5.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "QXLoopScrollView.h"
#import "ImageLoader.h"
#import "QXScrollViewPageControl.h"

#define TOTAL_IMG 3


@interface QXLoopScrollView ()
<UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *indexDict;
@property (strong, nonatomic) QXScrollViewPageControl *pageView;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation QXLoopScrollView

- (void)dealloc
{
    [self stopTimer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageViews = [NSMutableArray arrayWithCapacity:TOTAL_IMG];
        self.indexDict = [NSMutableDictionary dictionary];
        
        [self addSubview:self.scrollView];
        [self setupReusableButtons];
        [self addSubview:self.pageView];
        
    }
    return self;
}

//适用于xib以及storyboard的方法。
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.imageViews = [NSMutableArray arrayWithCapacity:TOTAL_IMG];
        self.indexDict = [NSMutableDictionary dictionary];
        
        [self addSubview:self.scrollView];
        [self setupReusableButtons];
        [self addSubview:self.pageView];
    }
    return self;
}

// 添加button
- (void)setupReusableButtons {
    
    for (int i = 0; i < TOTAL_IMG; i++)
    {
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [imgBtn addTarget:self
                   action:@selector(clickBtn:)
         forControlEvents:UIControlEventTouchUpInside];
        [imgBtn setImage:nil
                forState:UIControlStateNormal];
        imgBtn.exclusiveTouch = YES;
        [self.imageViews addObject:imgBtn];
        [self.scrollView addSubview:imgBtn];
    }
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
}

// 视图懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width*TOTAL_IMG, self.bounds.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = 0xf;
    }
    
    return _scrollView;
}

//视图懒加载
- (QXScrollViewPageControl *)pageView {
    if (!_pageView) {
        _pageView = [[QXScrollViewPageControl alloc] initWithFrame:CGRectZero];
    }
    return _pageView;
}


//动态调整subview的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageView.frame = CGRectMake(0,
                                     self.bounds.size.height-1.5,
                                     self.bounds.size.width,
                                     1.5);
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectMake(idx*self.bounds.size.width,
                                0,
                                self.bounds.size.width,
                                self.bounds.size.height);
    }];
}








#pragma mark - 计时器
- (void)startTimer
{
    [self stopTimer];
    if (self.imgUrls.count>1)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    }
}


- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}



- (void)handleTimer:(NSTimer*)sender
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+self.bounds.size.width, 0) animated:YES];
}









#pragma mark - 获取url的index
- (int)indexWithUrl:(NSString*)url
{
    return [[self.indexDict objectForKey:url] intValue];
}









#pragma mark - 赋值入口(数据唯一来源)
- (void)setImgUrls:(NSMutableArray *)imgUrls
{
    if (_imgUrls != imgUrls)
    {
        _imgUrls = imgUrls;
        
        //小于等于1不能滑动
        self.scrollView.scrollEnabled = (_imgUrls.count<=1)?NO:YES;
        
        //创建page指示
        [self.pageView createPageBoxWithCount:_imgUrls.count];
        
        //保存每个索引,以url当做唯一标示key,value是顺序,由此可以得知当前url的正常排序是第几个
        [self.indexDict removeAllObjects];
        for (int i = 0; i < _imgUrls.count; i++)
        {
            NSString *url = [_imgUrls objectAtIndex:i];
            [self.indexDict setObject:[NSNumber numberWithInt:i] forKey:url];
        }
        //因为实际上中间的按钮显示第一个图片,因此需要将图片数据左移
        [self goLeft];
        [self startTimer];
    }
}









#pragma mark - 点击按钮
- (void)clickBtn:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollViewDidSelectIndex:)])
    {
        [self.delegate loopScrollViewDidSelectIndex:sender.tag];
    }
}











#pragma mark - 刷新图片
- (void)refreshImage
{
    if (self.imgUrls.count>1)
    {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    }
    
    
    NSInteger count = (self.imgUrls.count<3)?self.imgUrls.count:3;
    
    for (int i = 0; i < 3; i++)
    {
        UIButton *btn = [self.imageViews objectAtIndex:i];
        NSString *image = [self.imgUrls objectAtIndex:i%count];
        
        btn.tag = [self indexWithUrl:image];
        if (i==1)
        {
            [self.pageView selectIndex:btn.tag];
        }
        
        if ([image isKindOfClass:[UIImage class]]) {
            [btn setImage:(UIImage *)image forState:UIControlStateNormal];
        } else if ([image isKindOfClass:[NSString class]]) {
            [ImageLoader getImageWithURL:image
                             placeholder:nil
                                   block:^(UIImage *img)
             {
                 [btn setImage:img forState:UIControlStateNormal];
             }];
        }
    }
}













#pragma mark - 移动数据
- (void)goRight
{
    NSString *url = [self.imgUrls firstObject];
    [self.imgUrls removeObjectAtIndex:0];
    [self.imgUrls addObject:url];
    [self refreshImage];
    
    
}

- (void)goLeft
{
    NSString *url = [self.imgUrls lastObject];
    [self.imgUrls removeObjectAtIndex:self.imgUrls.count-1];
    [self.imgUrls insertObject:url atIndex:0];
    [self refreshImage];
}
















#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self startTimer];
    //float offset = (self.imgUrls.count>3)?2*self.bounds.size.width:self.bounds.size.width;
    if (scrollView.contentOffset.x>=2*self.bounds.size.width)
    {
        [self goRight];
    }
    if (scrollView.contentOffset.x<=0)
    {
        [self goLeft];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"滑动中...timer停止");
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"停止滑动...timer开始");
    [self startTimer];
}


@end