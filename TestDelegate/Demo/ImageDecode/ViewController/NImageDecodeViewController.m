//
//  NImageDecodeViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/13.
//  Copyright © 2018年 a. All rights reserved.
//

/**
 *   大尺寸图片帧动画解码
 *   如果帧动画重复播放的频率不高，不需要考虑对原图或者对解码后位图数据做缓存
 */

#import "NImageDecodeViewController.h"
#import "YYWeakProxy.h"
//#import <QuartzCore/QuartzCore.h>
//#import <ImageIO/ImageIO.h>
#import <RH_Platform/RH_Platform.h>

#define kFramesPerSecond 30
#define kImageCount 80

@interface NImageDecodeViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *asyncButton;
@property (nonatomic, strong) UIButton *mainButton;
@property (nonatomic, strong) UIButton *mainButton2;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation NImageDecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"图片解码";
    CGRect frame = CGRectMake(80, 150, 200, 200);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.backgroundColor = [UIColor  redColor];
    [self.view addSubview:self.imageView];
    
    self.asyncButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.asyncButton.frame = CGRectMake(20, self.view.bounds.size.height - 260, 100, 40);
    self.asyncButton.backgroundColor = [UIColor grayColor];
    self.asyncButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.asyncButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.asyncButton setTitle:@"边解码边播放" forState:UIControlStateNormal];
    [self.asyncButton addTarget:self action:@selector(asyncPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.asyncButton];
    
    self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainButton.frame = CGRectMake(130, self.view.bounds.size.height - 260, 100, 40);
    self.mainButton.backgroundColor = [UIColor grayColor];
    self.mainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.mainButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.mainButton setTitle:@"imageNamed" forState:UIControlStateNormal];
    [self.mainButton addTarget:self action:@selector(clickImageNamed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainButton];
    
    self.mainButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainButton2.frame = CGRectMake(240, self.view.bounds.size.height - 260, 120, 40);
    [self.mainButton2 addTarget:self action:@selector(clickImageWithContentsOfFile:) forControlEvents:UIControlEventTouchUpInside];
    self.mainButton2.backgroundColor = [UIColor grayColor];
    self.mainButton2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.mainButton2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.mainButton2 setTitle:@"imageWithContentsOfFile" forState:UIControlStateNormal];
    [self.view addSubview:self.mainButton2];
    
    
}

//帧动画图片数组
- (NSMutableArray *)imageArrayWithCache:(BOOL)cache
{
   
    if (!self.imageArray) {
        self.imageArray =  [[NSMutableArray alloc] init];
    }
    
    if (self.imageArray.count == kImageCount) {
        return self.imageArray;
    }
    
    for (int i = 1; i <= kImageCount; i++) {
        NSString *fileName = [NSString stringWithFormat:@"gift_cupid_1_%d@2x", i];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
        UIImage *image;
        if (cache) {
            //系统自动会把图片和解码后位图数据缓存到内存，缓存无法控制，只有在内存低时才会被释放
            image = [UIImage imageNamed:fileName];
        } else {
            //系统不会缓存原图片和解码后位图数据，每次加载图片都需要解码
            image = [UIImage imageWithContentsOfFile:filePath];
            //            image = [self imageAtFilePath:filePath];
        }
        if (image) {
            [self.imageArray addObject:image];
        }
    }
    return self.imageArray;
}

/*
 http://blog.corneliamu.com/archives/95
 
 我们知道，在保存图片时，为了节省空间，通常会将图片编码（压缩）后再进行存储。如果读取的图片数据为压缩后的数据的话，那就需要对其进行解码成位图（Bitmap）数据。不同加载图片的方式，在这一步的操作上会有一定的差异。
 1）imageNamed: 会在图片第一次渲染到屏幕上的时候进行解码，并缓存解码后的图片数据。缓存数据存储在全局缓存中，不会随着UIImag的释放而释放。
 
 2）imageWithContentsOfFile: 或 imageWithData: 同样会在图片第一次渲染到屏幕上的时候进行解码。底层会调用到 CGImageSourceCreateWithData() 方法，该方法可以指定是否要缓存解码后的数据，在64位机器上默认需要缓存（kCGImageSourceShouldCache）。与上面的方法不同，这种方式创建的缓存会随着UIImage的释放而被释放掉。
 
 3）图片解码过程就是将二进制数据转换成原始像素(位图)数据
 */

#pragma mark 边解码边播放按钮出发事件
//使用CADisplayLink不断刷新图像数据达到播放帧动画效果
- (void)asyncPlay:(id)sender
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(frameAnimation:)];
    if (@available(iOS 10.0, *)) {
        self.displayLink.preferredFramesPerSecond = kFramesPerSecond;
    } else {
        // Fallback on earlier versions
    }
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)frameAnimation:(id)sender
{
    self.index++;
    if (self.index > kImageCount) {
        self.index = 0;
        [self.displayLink invalidate];
        self.displayLink = nil;
        return;
    };
    NSString *fileName = [NSString stringWithFormat:@"gift_cupid_1_%ld@2x", (long)self.index];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];//并没有真正把图片数据加载到内存，渲染时才解压，在UIImage生命周期内保存解压后的数据
    
    [UIImage forceDecodeImageWithContentOfFile:filePath block:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    /*
    //创建未解码的图片--还是二进制数据
    UIImage *image = [self imageAtFilePath:filePath];

    //解码操作, 将二进制数据转换成原始像素(位图)数据
    [self decodeImage:image];
     */
}

////ImageIO来创建图片，然后在图片的生命周期保留解压后的版本
//- (UIImage *)imageAtFilePath:(NSString *)filePath
//{
//    //kCGImageSourceShouldCacheImmediately表示是否在加载完后立刻开始解码，默认为NO表示在渲染时才解码
//    //kCGImageSourceShouldCache可以设置在图片的生命周期内是保存图片解码后的数据还是原始图片，64位设备默认为YES，32位设备默认为NO
//    CFDictionaryRef options = (__bridge CFDictionaryRef)@{(__bridge id)kCGImageSourceShouldCacheImmediately:@(NO), (__bridge id)kCGImageSourceShouldCache:@(NO)};
//    NSURL *imageURL = [NSURL fileURLWithPath:filePath];
//    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
//    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, options);//创建一个未解码的CGImage
//    CGFloat scale = 1;
//    if ([filePath rangeOfString:@"@2x"].location != NSNotFound) {
//        scale = 2.0;
//    }
//    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];//此时图片还没有解码
//    CGImageRelease(imageRef);
//    CFRelease(source);
//    return image;
//}
//
//#pragma mark imageNamed 按钮点击事件
//- (void)clickImageNamed:(id)sender
//{
//    //会对解码后的图片位图数据缓存
//    [self playAnimationImages:[self imageArrayWithCache:YES]];
//}
//
//#pragma mark clickImageWithContentsOfFile按钮点击事件
//- (void)clickImageWithContentsOfFile:(id)sender
//{
//    //不会对解码后的图片位图数据缓存
//    [self playAnimationImages:[self imageArrayWithCache:NO]];
//}
//
////使用animationImages属性播放帧动画，会导致内存暴增
//- (void)playAnimationImages:(NSArray *)images
//{
//    self.imageView.animationDuration = kImageCount * 1./kFramesPerSecond;
//    self.imageView.animationRepeatCount = 1;
//    self.imageView.animationImages = images;//animationImages的copy属性会对images数组里面的uiimage进行指针拷贝，使得images里面的图片没有被释放
//    [self.imageView startAnimating];
//    [self performSelector:@selector(didFinishAnimation) withObject:nil afterDelay:self.imageView.animationDuration];
//}
//
////帧动画结束后
//- (void)didFinishAnimation
//{
//    self.imageView.animationImages = nil;//释放拷贝的images以及存储的图片
//}
//
//- (void)decodeImage:(UIImage *)image
//{
//    //异步子线程图片解码
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        CGImageRef decodedImage = decodeImageWithCGImage(image.CGImage, YES);//强制解码
//        
//        // 回到主线程刷新UI
//        // 使用imageWithCGImage函数加载解码后的位图
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image = [UIImage imageWithCGImage:decodedImage scale:image.scale orientation:UIImageOrientationUp];
//            CFRelease(decodedImage);
//        });
//    });
//}
//
////返回解码后位图数据 Core Graphics offscreen rendering based on CPU
//CGImageRef decodeImageWithCGImage(CGImageRef imageRef, BOOL decodeForDisplay)
//{
//    if (!imageRef) return NULL;
//    size_t width = CGImageGetWidth(imageRef);
//    size_t height = CGImageGetHeight(imageRef);
//    if (width == 0 || height == 0) return NULL;
//    
//    if (decodeForDisplay) { //decode with redraw (may lose some precision)
//        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
//        BOOL hasAlpha = NO;
//        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
//            alphaInfo == kCGImageAlphaPremultipliedFirst ||
//            alphaInfo == kCGImageAlphaLast ||
//            alphaInfo == kCGImageAlphaFirst) {
//            hasAlpha = YES;
//        }
//        // BGRA8888 (premultiplied) or BGRX8888
//        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
//        //先把图片绘制到 CGBitmapContext 中，然后从 Bitmap 直接创建图片
//        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
//        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
//        
//        /*
//         解码步骤:
//         1. 使用CGBitmapContextCreate函数创建一个位图上下文
//         2. 使用CGContextDrawImage函数将原始位图绘制到上下文中
//         3. 使用CGBitmapContextCreateImage函数创建一张新的解压缩后的位图
//         */
//        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
//        if (!context) return NULL;
//        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
//        CGImageRef newImage = CGBitmapContextCreateImage(context);
//        CFRelease(context);
//        return newImage;
//    } else {
//        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
//        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
//        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
//        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
//        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
//        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
//        
//        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
//        if (!dataProvider) return NULL;
//        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
//        if (!data) return NULL;
//        
//        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
//        CFRelease(data);
//        if (!newProvider) return NULL;
//        
//        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
//        CFRelease(newProvider);
//        return newImage;
//    }
//}
//
//NSUInteger cacheCostForImage(UIImage *image) {
//    return image.size.height * image.size.width * image.scale * image.scale;
//}


@end
