//
//  ImageLoader.m
//
//  Created by 亓鑫 on 13-6-6.
//  Copyright (c) 2013年 亓鑫. All rights reserved.
//






#import "ImageLoader.h"
#import <commoncrypto/CommonDigest.h>

@interface ImageLoader ()
@end

@implementation ImageLoader

#pragma mark - 检查是否过期,过期则清除缓存图片
+ (void)cleanCacheIfExpired
{
    NSDirectoryEnumerator *fileNames = [[NSFileManager defaultManager] enumeratorAtPath:ILCachePath];
    NSInteger curTimetemp = (NSInteger)CFAbsoluteTimeGetCurrent();
    for (NSString *fileName in fileNames)
    {
        NSString *uniquePath = [ILCachePath stringByAppendingPathComponent:fileName];
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:uniquePath error:nil];
        NSDate *createdDate = [attributes objectForKey:NSFileCreationDate];
        NSInteger createTimetemp = (NSInteger)[createdDate timeIntervalSinceReferenceDate];
        if (curTimetemp-createTimetemp > ILExpiredTime)
        {
            [[NSFileManager defaultManager] removeItemAtPath:uniquePath error:nil];
        }
    }
}


#pragma mark - 清除GMImgCache缓存的图片
+ (BOOL)deleteCacheImage
{
    return [[NSFileManager defaultManager] removeItemAtPath:ILCachePath error:nil];
}


#pragma mark - 判断获取的数据 是否为正常的UIImage的Data
+ (BOOL)isImageWithData:(NSData *)imgData
{
    UIImage *image = [UIImage imageWithData:imgData];
    return ([image isKindOfClass:[UIImage class]])?YES:NO;
}






#pragma mark - MD5
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



#pragma mark - 获取图片路径
+ (NSString*)getImageFileLocalPath:(NSString*)url
{
    NSString *fileName = [ImageLoader md5:[ImageLoader getRelativePathURL:url]];
    NSString *path = [ILCachePath stringByAppendingPathComponent:fileName];
    return path;
}

/*
 URL = http://www.xxxxx.com/image/prodimg/123.png
 RelativePath = /image/prodimg/123.png
 */
+ (NSString*)getRelativePathURL:(NSString*)url
{
    NSURL *u = [NSURL URLWithString:url];
    return [u relativePath];
}


#pragma mark - 判断url是否合法
+ (BOOL)isValidUrl:(NSString*)url
{
    if (![url isKindOfClass:[NSString class]])
    {
        printf("[ImageLoader]错误:Url不是NSString类型\n");
        return NO;
    }
    if (!url)
    {
        printf("[ImageLoader]错误:Url=nil\n");
        return NO;
    }
    if ([url isEqualToString:@""])
    {
        printf("[ImageLoader]错误:Url为空\n");
        return NO;
    }
    if ([[url pathExtension] isEqualToString:@""])
    {
        printf("[ImageLoader]错误:Url扩展名为空,可能不是图片链接\n");
        return NO;
    }
    return YES;
}









#pragma mark - 异步加载图片1.1
+ (void)getImageWithURL:(NSString*)url
            placeholder:(UIImage*)placeholder
                  block:(ImgCallBack)blk;
{
    if (![ImageLoader isValidUrl:url])
    {
        if (blk)
        {
            blk(placeholder);
        }
        return;
    }
    
    //TODO: 转码UTF-8
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:ILCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:ILCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    
    
    NSString *imagePath = [ImageLoader getImageFileLocalPath:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        if (blk)
        {
            @autoreleasepool
            {
                printf("\nload cache Image %s\n",[imagePath UTF8String]);
                NSData *imgData = [NSData dataWithContentsOfFile:imagePath
                                                         options:NSDataReadingMapped
                                                           error:nil];
                blk([UIImage imageWithData:imgData]);
            }
        }
    }
    else
    {
        if (blk)
        {
            printf("\nload placeholder need download image%s\n",[imagePath UTF8String]);
            blk(placeholder);
        }
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            @autoreleasepool
            {
                //TODO: 设置图片请求的超时
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:ILTimeOut];
                NSData *imgData = [NSURLConnection sendSynchronousRequest:request
                                                        returningResponse:nil
                                                                    error:nil];
                if (imgData && [ImageLoader isImageWithData:imgData])
                {
                    if ([imgData writeToFile:imagePath atomically:YES])
                    {
                        printf("\nsave Image %s\n",[imagePath UTF8String]);
                        NSData *data = [NSData dataWithContentsOfFile:imagePath
                                                              options:NSDataReadingMapped
                                                                error:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (blk)
                            {
                                blk([UIImage imageWithData:data]);
                            }
                        });
                    }
                }
            }
        });
    }
}







#pragma mark - 常规加载1.2
+ (void)getImageWithURL:(NSString*)url
             loadFinish:(LoadFinish)finish
            loadFailure:(LoadFailure)failure;
{
    if (![ImageLoader isValidUrl:url])
    {
        if (failure)
        {
            printf("\nbad url\n");
            failure();
        }
        return;
    }
    
    //TODO: 转码UTF-8
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:ILCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:ILCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    
    
    NSString *imagePath = [ImageLoader getImageFileLocalPath:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        if (finish)
        {
            @autoreleasepool
            {
                printf("\nload cache Image %s\n",[imagePath UTF8String]);
                NSData *imgData = [NSData dataWithContentsOfFile:imagePath
                                                         options:NSDataReadingMapped
                                                           error:nil];
                finish([UIImage imageWithData:imgData]);
            }
        }
    }
    else
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            @autoreleasepool
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:ILTimeOut];
                NSData *imgData = [NSURLConnection sendSynchronousRequest:request
                                                        returningResponse:nil
                                                                    error:nil];
                if (imgData && [ImageLoader isImageWithData:imgData])
                {
                    if ([imgData writeToFile:imagePath atomically:YES])
                    {
                        printf("\nsave Image %s\n",[imagePath UTF8String]);
                        NSData *data = [NSData dataWithContentsOfFile:imagePath
                                                              options:NSDataReadingMapped
                                                                error:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (finish)
                            {
                                finish([UIImage imageWithData:data]);
                            }
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failure)
                            {
                                printf("\nsave Image Error\n");
                                failure();
                            }
                        });
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (failure)
                        {
                            printf("\ndownLoad error or data is not a image\n");
                            failure();
                        }
                    });
                }
            }
        });
    }
}




@end


