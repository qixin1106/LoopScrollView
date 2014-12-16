LoopScrollView
==============

1.新闻app,电商app的轮播图,焦点图.
--------------
2.可循环滚动.可自动轮播(需要设置时间)
--------------
3.复用button.
--------------
4.目前只能通过网络url读取图片(一般项目中也基本是用url),待增加功能...
--------------

演示效果:

![image](https://raw.githubusercontent.com/qixin1106/LoopScrollView/master/LoopScrollView/loopView.gif)


### 初始化

    self.loopScrollView = [[QXLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    self.loopScrollView.delegate = self;
    [self.contentView addSubview:self.loopScrollView];


### 赋值
 
    self.loopScrollView.imgUrls = self.imageUrls;
  
  
### delegate

    #pragma mark - QXLoopScrollViewDelegate
    - (void)loopScrollViewDidSelectIndex:(NSInteger)index
    {
        NSLog(@"选择%ld",index);
    }
