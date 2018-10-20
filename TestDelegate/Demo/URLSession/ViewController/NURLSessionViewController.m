//
//  NURLSessionViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/17.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NURLSessionViewController.h"
#import <AFNetworking/AFNetworking.h>
//基础url
#define IOS_TIPS_API_HOST @"https://app.kangzubin.com/iostips/api/"

//1.小知识
#define FEED_List @"feed/listAll?"

static NSString * imageURL = @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-4/2018423202071807.gif";
//:@"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-4/2018423202071807.gif"

@interface NURLSessionViewController ()<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate,
NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>
@property (strong,nonatomic)UIImageView * imageview;
@property (nonatomic)NSUInteger expectlength;
@property (strong,nonatomic) NSMutableData * buffer;
@property (strong,nonatomic) UIProgressView *progressview;
@end

@implementation NURLSessionViewController
-(UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(40,100,200,200)];
        _imageview.backgroundColor = [UIColor lightGrayColor];
        _imageview.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageview;
}

- (UIProgressView *)progressview
{
    if (!_progressview) {
        self.progressview = [[UIProgressView alloc] initWithFrame:CGRectMake(80, 350, 200, 20)];
        _progressview.progressTintColor = [UIColor  redColor];
        _progressview.trackTintColor = [UIColor  blueColor];
    }return _progressview;
}

-(NSMutableData *)buffer{
    if (!_buffer) {
        _buffer = [[NSMutableData alloc] init];
    }
    return _buffer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor  whiteColor];
    self.title = @"NSURLSession/AFNetworking 3.1.0";
    [self.view addSubview:self.imageview];
    [self.view addSubview:self.progressview];
    [self  url_session];
    //[self  afurl_session_manager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 https://blog.csdn.net/qq_29846663/article/details/68961167
  NSURLSession对象的创建有如下三种方法：
 */
//NSURLSession
- (void)url_session
{
    
    //1. 创建NSURLSession对象
      //第一种
    //NSURLSession *session = [NSURLSession  sharedSession];
      //第二种
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSURLSession *session_configuration = [NSURLSession  sessionWithConfiguration:configuration];
      //第三种
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURLSession *session_delegate = [NSURLSession  sessionWithConfiguration:configuration delegate:self delegateQueue:operationQueue];

     //2、使用NSURLSession对象创建Task
//    NSURL *url = [NSURL URLWithString:imageURL];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"nicholas" ofType:@"PNG"]];

       //创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
       //GET请求
          //block形式
//    NSURLSessionDataTask *dataTask = [session_delegate  dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"GET请求响应:%@", response);
//        NSLog(@"GET请求错误:%@", error);
//    }];
    
         //代理形式
//    NSURLSessionDataTask *dataTask = [session_delegate  dataTaskWithRequest:request];
//    NSLog(@"😆:%@", url);
//    [dataTask resume];
//    [session_delegate  finishTasksAndInvalidate];//完成task就invalidate

//       //Upload文件上传
//    NSURLSessionUploadTask *uploadTask = [session_delegate  uploadTaskWithRequest:request fromData:[[NSData alloc] init] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"文件上传响应:%@", response);
//        NSLog(@"文件上传错误:%@", error);
//    }];
//    [uploadTask resume];
//
        //Download文件下载
          //block形式
//    NSURLSessionDownloadTask *downloadTask = [session_delegate downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"文件下载响应:%@", response);
//        NSLog(@"文件下载错误:%@", error);
//    }];
    NSURLSessionDownloadTask *downloadTask = [session_delegate downloadTaskWithRequest:request];
    [downloadTask resume];
    [session_delegate  finishTasksAndInvalidate];//完成task就invalidate
}


#pragma mark AFURLSessionManager
- (void)afurl_session_manager
{
    //1.先写个简单的网络请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];

    //如果不添加反序列化、有可能会报错说传回来的res是text/html。
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2、使用NSURLSession对象创建Task
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    //创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    //3.生成任务
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度:%@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度:%@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"get成功: %@", response);
        NSLog(@"get失败: %@", error);
    }];
    //4.调起网络请求
    [dataTask resume];
}

#pragma mark  NSURLSessionDelegate 用来处理Session层次的事件
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    NSLog(@"%s, 无效的时候调用", __FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSLog(@"%s, 访问资源的时候、可能服务器会返回需要授权调用", __FUNCTION__);

}

#pragma mark  NSURLSessionTaskDelegate 用来处理task层次的事件, 任何种类task都要实现的代理
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    NSLog(@"%s, 将会进行HTTP，重定向.", __FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSLog(@"%s, Task层次收到了授权，证书等问题.", __FUNCTION__);
}

/* 当任务需要新的请求主体流发送到远程服务器时，告诉委托。
 这种委托方法在两种情况下被调用：
 1、如果使用uploadTaskWithStreamedRequest创建任务，则提供初始请求正文流：
 2、如果任务因身份验证质询或其他可恢复的服务器错误需要重新发送包含正文流的请求，则提供替换请求正文流。
 注：如果代码使用文件URL或NSData对象提供请求主体，则不需要实现此功能。
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler
{
    NSLog(@"%s, 流任务的方式上传--需要客户端提供数据源", __FUNCTION__);
}

/* 定期通知代理向服务器发送主体内容的进度。*/
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"%s, 上传进度", __FUNCTION__);
    self.progressview.progress = (float)totalBytesSent/(float)totalBytesExpectedToSend;
}

/*
 对发送请求/DNS查询/TLS握手/请求响应等各种环节时间上的统计. 更易于我们检测, 分析我们App的请求缓慢到底是发生在哪个环节, 并对此进行优化提升我们APP的性能.
 
 NSURLSessionTaskMetrics对象与NSURLSessionTask对象一一对应. 每个NSURLSessionTaskMetrics对象内有3个属性 :
 
 taskInterval : task从开始到结束总共用的时间
 redirectCount : task重定向的次数
 transactionMetrics : 一个task从发出请求到收到数据过程中派生出的每个子请求, 它是一个装着许多NSURLSessionTaskTransactionMetrics对象的数组. 每个对象都代表下图的一个子过程
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0))
{
 NSLog(@"%s, \n总时间:%@\n, 重定向次数:%zd\n, 派生的子请求:%zd", __FUNCTION__, metrics.taskInterval,metrics.redirectCount,metrics.transactionMetrics.count);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"%s, Task完成的事件.", __FUNCTION__);
    
    __block NSURLSession *s = session;
    __block NSURLSessionTask *t = task;
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{//用GCD的方式，保证在主线程上更新UI
            UIImage * image = [UIImage imageWithData:self.buffer];
            self.imageview.image = image;
            s = nil;
            t = nil;
        });

    }else{
        NSDictionary * userinfo = [error userInfo];
        NSString * failurl = [userinfo objectForKey:NSURLErrorFailingURLStringErrorKey];
        NSString * localDescription = [userinfo objectForKey:NSLocalizedDescriptionKey];
        if ([failurl isEqualToString:imageURL] && [localDescription isEqualToString:@"cancelled"]) {//如果是task被取消了，就弹出提示框
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                             message:@"The task is canceled"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Unknown type error"//其他错误，则弹出错误描述
                                                             message:error.localizedDescription
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }
        self.progressview.hidden = YES;
        s = nil;
        t = nil;
    }
    
}

#pragma mark  NSURLSessionDataDelegate 特别用来处理dataTask的事件
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"%s, 收到了Response，这个Response包括了HTTP的header（数据长度，类型等信息），这里可以决定DataTask以何种方式继续（继续，取消，转变为Download）", __FUNCTION__);
    
    NSUInteger length = [response expectedContentLength];
    if (length != -1) {
        self.expectlength = [response expectedContentLength];//存储一共要传输的数据长度
        completionHandler(NSURLSessionResponseAllow);//继续数据传输
    }else{
        completionHandler(NSURLSessionResponseCancel);//如果Response里不包括数据长度的信息，就取消数据传输
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                         message:@"Do not contain property of expectedlength"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"%s, DataTask已经转变成DownloadTask", __FUNCTION__);

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"%s, 每收到一次Data时候调用.", __FUNCTION__);
    [self.buffer appendData:data];//数据放到缓冲区里
    float progress = [self.buffer length]/((float) self.expectlength);
    [self.progressview  setProgress:progress animated:YES];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler
{
    NSLog(@"%s, 是否把Response存储到Cache中.", __FUNCTION__);
    NSCachedURLResponse * res = [[NSCachedURLResponse alloc]initWithResponse:proposedResponse.response data:proposedResponse.data userInfo:nil storagePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(res);
}

#pragma mark  NSURLSessionDownloadDelegate 特别用来处理downloadTask的事件
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%s, 下载完成, 写入路径:%@", __FUNCTION__, location.filePathURL);
    NSData * data = [NSData dataWithContentsOfURL:location.filePathURL];
    [self.buffer appendData:data];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%s, 下载任务进度", __FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressview setProgress:totalBytesWritten/totalBytesExpectedToWrite animated:YES];
    });
    
}

//filrOffest 已经下载的文件大小  expectedTotalBytes预期总大小
/*
 你可以通过 [session downloadTaskWithResumeData：resumeData]之类的方法来重新恢复一个下载任务
 resumeData在下载任务失败的时候会通过error.userInfo[NSURLSessionDownloadTaskResumeData]来返回以供保存
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s, 下载任务已经恢复下载", __FUNCTION__);
}

#pragma mark  NSURLSessionStreamDelegate 特别用来处理流 任务代理 的事件

- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask
API_AVAILABLE(ios(9.0))
{
    NSLog(@"%s, 数据流的连接中 读 数据的一边已经关闭", __FUNCTION__);
}


- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask
API_AVAILABLE(ios(9.0))
{
    NSLog(@"%s, 数据流的连接中 写 数据的一边已经关闭", __FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask
API_AVAILABLE(ios(9.0))
{
    NSLog(@"%s, 系统已经发现了一个更好的连接主机的路径", __FUNCTION__);

}


- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask
didBecomeInputStream:(NSInputStream *)inputStream
      outputStream:(NSOutputStream *)outputStream
API_AVAILABLE(ios(9.0))
{
    NSLog(@"%s, 流任务已完成", __FUNCTION__);
}

@end






