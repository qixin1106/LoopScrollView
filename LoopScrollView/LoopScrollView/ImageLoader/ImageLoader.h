//
//  ImageLoader.h
//
//  Created by 亓鑫 on 13-6-6.
//  Copyright (c) 2013年 亓鑫. All rights reserved.
//






// 缓存路径
#define ILCachePath [NSTemporaryDirectory() stringByAppendingPathComponent:@"ILImgCache"]
// 图片下载超时
#define ILTimeOut 8
// 缓存图片过期时间
#define ILExpiredTime 60*60*24*7 //a week


#import <Foundation/Foundation.h>
@import UIKit;

typedef void (^ImgCallBack)(UIImage *img);

typedef void (^LoadFinish)(UIImage *img);
typedef void (^LoadFailure)();
@interface ImageLoader : NSObject

/*!
 *  异步加载图片,可设置placeholder,请求时自动将placeholder回调block
 *
 *  @param url         图片URL,该方法会进行一次utf-8编码
 *  @param placeholder 占位图,该图片会在请请求时block返回
 *  @param blk         callback回传一个image对象
 *
 *  @since 2014-07-11(老方法)
 */
+ (void)getImageWithURL:(NSString*)url
            placeholder:(UIImage*)placeholder
                  block:(ImgCallBack)blk;


/*!
 *  异步加载图片,常规方式,带成功失败block回调,没有设置placeholder,因为你可以在调用前自行赋值.
 *
 *  @param url         图片URL,该方法会进行一次utf-8编码
 *  @param finish      成功block回调,会回传一个UIImage对象.
 *  @param failure     失败block回调
 *
 *  @since 2014-07-14(增加新方法)
 */

+ (void)getImageWithURL:(NSString*)url
             loadFinish:(LoadFinish)finish
            loadFailure:(LoadFailure)failure;




/*!
 *  删除所有缓存图片,调用之后会删除宏定义"ILCachePath"文件夹
 *
 *  @return 是否删除成功
 *
 *  @since 2014-07-11
 */
+ (BOOL)deleteCacheImage;


/*!
 *  检查是否过期,过期则清除图片缓存,过期日期默认7天,通过改变宏定义"ILExpiredTime"来改变过期时长
 *  - (void)applicationWillTerminate:(UIApplication*)application
 *  {
 *      [ImageLoader cleanCacheIfExpired];
 *  }
 *  @since 2014-07-17
 */
+ (void)cleanCacheIfExpired;




@end




