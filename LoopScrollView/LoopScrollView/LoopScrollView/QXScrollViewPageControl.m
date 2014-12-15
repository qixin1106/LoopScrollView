//
//
//  Created by Qixin on 14-6-6.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "QXScrollViewPageControl.h"



#define kOffColor [UIColor colorWithWhite:1.0 alpha:0.7]
#define kOnColor [UIColor redColor]

@interface QXScrollViewPageControl ()
@property (strong, nonatomic) NSMutableArray *frames;
@property (strong, nonatomic) UIView *indicatorView;
@end

@implementation QXScrollViewPageControl




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kOffColor;
        self.frames = [NSMutableArray array];
    }
    return self;
}


- (void)createPageBoxWithCount:(NSInteger)count
{
    [self.frames removeAllObjects];
    float perWidth = (count>0)?self.bounds.size.width/count:0;
    for (int i = 0; i < count; i++)
    {
        if (i==0 && !self.indicatorView)
        {
            self.indicatorView =
            [[UIView alloc] initWithFrame:CGRectMake(0,
                                                     0,
                                                     perWidth,
                                                     self.bounds.size.height)];
            self.indicatorView.backgroundColor = kOnColor;
            [self addSubview:self.indicatorView];
        }
        CGRect rect = CGRectMake(perWidth*i,
                                 0,
                                 perWidth,
                                 self.bounds.size.height);
        NSValue *value = [NSValue valueWithCGRect:rect];
        [self.frames addObject:value];
    }
}


- (void)selectIndex:(NSInteger)index
{
    __weak QXScrollViewPageControl *weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.indicatorView.frame = [[weakSelf.frames objectAtIndex:index] CGRectValue];
    }];
}


@end
