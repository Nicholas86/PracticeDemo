//
//  STMURLCacheModel.m
//  TestDelegate
//
//  Created by a on 2018/3/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import "STMURLCacheModel.h"
#import <CommonCrypto/CommonDigest.h>

@implementation STMURLCacheModel
#pragma mark 单例初始化
//for NSURLProtocol
+ (STMURLCacheModel *)shareInstance {
    static STMURLCacheModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STMURLCacheModel alloc] init];
    });
    return instance;
}


#pragma mark interface
//1.查找请求对应的文件路径
- (NSString *)filePathFromRequest:(NSURLRequest *)request isInfo:(BOOL)isInfo
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"get请求的url:%@", url);
    //1.使用完整的url作为fileName,来缓存NSURLRequest请求
    NSString *fileName = [self fileNameWithFileName:url];
    //2.使用完整的url作为otherInfoFileName,来缓存NSURLRequest请求
    NSString *otherInfoFileName = [self otherInfoFileNameWithFileName:url];
    
    //1.根据fileName获取filePath
    NSString *filePath = [self  filePathWithFileName:fileName];
    //2.根据otherInfoFileName获取otherInfoFilePath
    NSString *otherInfoFilePath = [self  filePathWithFileName:otherInfoFileName];
    
    if (isInfo) {
        return otherInfoFilePath;
    }
    
    return filePath;
}

//2.清除请求对应的缓存
- (void)removeCacheFileWithRequest:(NSURLRequest *)request
{
    //1.根据fileName获取filePath
    NSString *filePath = [self  filePathFromRequest:request isInfo:NO];
    //2.根据otherInfoFileName获取otherInfoFilePath
    NSString *otherInfoFilePath = [self  filePathFromRequest:request isInfo:YES];
    
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    [fileManager  removeItemAtPath:filePath error:nil];
    [fileManager  removeItemAtPath:otherInfoFilePath error:nil];
}

//3.根据请求进行判断localResourcePathDic是否已经缓存,有:返回NSCachedURLResponse,没有:返回nil
- (NSCachedURLResponse *)localResourcePathDicWithRequest:(NSURLRequest *)request
{
    __block NSCachedURLResponse *cachedURLResponse = nil;
    
    //1.根据fileName获取filePath
    NSString *filePath = [self  filePathFromRequest:request isInfo:NO];
    //2.根据otherInfoFileName获取otherInfoFilePath
    NSString *otherInfoFilePath = [self  filePathFromRequest:request isInfo:YES];
    
    //3.获取当前日期
    NSDate *date = [NSDate  date];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager  fileExistsAtPath:filePath]) {
        NSLog(@"本地有缓存文件的情况");
        //本地有缓存文件的情况
        BOOL expire = NO;//是否过期
        //从本地读取额外信息字典
        NSDictionary *otherInfoDic = [NSDictionary  dictionaryWithContentsOfFile:otherInfoFilePath];
        NSString *time = otherInfoDic[@"time"];
        NSString *MIMEType = otherInfoDic[@"MIMEType"];
        NSString *textEncodingName = otherInfoDic[@"textEncodingName"];
        //缓存时长大于0
        if (self.cacheTime > 0) {
            NSInteger createTime = [time integerValue];
            if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                expire = true;
            }
        }
        
        if (expire == false) {
            NSLog(@"没有过期,从缓存里读取数据流");
            //没有过期,从缓存里读取数据流
            NSData *data = [NSData  dataWithContentsOfFile:filePath];
            //将数据流转成NSURLResponse类型对象
            NSURLResponse *response = [[NSURLResponse  alloc] initWithURL:request.URL MIMEType:MIMEType expectedContentLength:data.length textEncodingName:textEncodingName];
            //将NSURLResponse类型对象 + 数据流data 转成NSCachedURLResponse缓存对象
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            return cachedResponse;
        }else{
            NSLog(@"过期,清空缓存");
            [fileManager  removeItemAtPath:filePath error:nil];
            [fileManager  removeItemAtPath:otherInfoFilePath error:nil];
            return nil;
        }
        
    }else{
        NSLog(@"本地没有缓存文件,直接从网络读取");
        //从网络读取
        self.isSaveOnDisk = NO;
        id isExist = [self.responseDic   objectForKey:request.URL.absoluteString];
        if (isExist == nil) {
            //保存到 防止下载请求的循环调用字典里
            [self.responseDic  setValue:@(YES) forKey:request.URL.absoluteString];
            //发起网络请求
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session  dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"请求response:%@", response);
                
                if (error) {
                    cachedURLResponse = nil;
                    NSLog(@"网络请求错误:%@", cachedURLResponse);
                }else{
                    NSLog(@"网络请求成功response:%@", response);
                    //1.额外信息字典
                    NSDictionary *otherInfoDic = @{
                                              @"time": [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]],
                                              @"MIMEType":response.MIMEType,
                                              @"textEncodingName": response.textEncodingName
                                              };
                    //2.将额外信息字典写进文件(otherInfoFilePath),保存到本地
                    BOOL is_otherInfoDic_success = [otherInfoDic   writeToFile:otherInfoFilePath atomically:YES];
                    
                    //3.将请求成功返回的数据流data写进文件(filePath),保存到本地
                    BOOL is_data_success = [data      writeToFile:filePath atomically:YES];
                    
                    if (is_otherInfoDic_success || is_data_success) {
                        NSLog(@"写进本地成功");
                    }else{
                        NSLog(@"写进本地失败");
                    }
                    //4.上面写进本地文件的同时,也写进本地缓存里面
                    cachedURLResponse = [[NSCachedURLResponse  alloc] initWithResponse:response data:data];
                }
            }];
            [dataTask  resume];
            return cachedURLResponse;
        }
        return nil;
    }
    
    
    return nil;
}


//4.全部清除自建的缓存目录
- (void)checkCapacity
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([self folderSize] > self.diskCapacity) {
            [self  deleteCacheFolder];
        }
    });
}

#pragma mark 文件路径、md5加密
- (NSString *)fileNameWithFileName:(NSString *)filename
{
    //将传进来的完整url文件名,用md5加密
    NSString *md5String = [STMURLCacheModel  md5HashWithString:filename];
    return md5String;
}

- (NSString *)otherInfoFileNameWithFileName:(NSString *)filename
{
    //将传进来的完整url文件名,用md5加密
    //otherInfoFileName
    NSString *md5String = [STMURLCacheModel  md5HashWithString:[NSString stringWithFormat:@"%@-otherInfo", filename]];
    return md5String;
}

//根据fileName获取本地完整路径
- (NSString *)filePathWithFileName:(NSString *)filename
{
    NSString *filePath = [NSString  stringWithFormat:@"%@/%@", self.diskPath, self.cacheFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    //1.如果主目录存在
    if ([fileManager  fileExistsAtPath:filePath isDirectory:&isDir] && isDir) {
        NSLog(@"主目录存在");
    }else{
        //主目录不存在,就创建一个主目录
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //2.子目录
    NSString *subDirPath = [self  fullFolderPath];//[NSString  stringWithFormat:@"%@/%@/%@", self.diskPath, self.cacheFolder, self.subDirectory];
    if ([fileManager fileExistsAtPath:subDirPath isDirectory:&isDir]) {
        NSLog(@"子目录存在");
    }else{
        //子目录不存在,就创建一个子目录
        [fileManager createDirectoryAtPath:subDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //返回子目录 + filename = 完整路径
    NSString *subDicFullFilePath = [NSString  stringWithFormat:@"%@/%@", subDirPath, filename];
    NSLog(@"完整路径:%@", subDicFullFilePath);
    return subDicFullFilePath;
}

//清除缓存
- (void)deleteCacheFolder
{
    [[NSFileManager defaultManager] removeItemAtPath:[self  fullFolderPath] error:nil];
}

//缓存数据的完整路径
- (NSString *)fullFolderPath
{
    NSString *fullFolderPath = [NSString  stringWithFormat:@"%@/%@/%@", self.diskPath, self.cacheFolder, self.subDirectory];
    return fullFolderPath;
}

//缓存的文件大小
- (NSUInteger)folderSize
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[self fullFolderPath] error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:[[self fullFolderPath] stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDic fileSize];
    }
    return (NSUInteger)fileSize;
}

#pragma mark - Function Helper
+ (NSString *)md5HashWithString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}


#pragma mark Getter 懒加载属性
//内存容量
- (NSUInteger)memoryCapacity
{
    if (_memoryCapacity) {
        _memoryCapacity = 20 * 1024 *1024;
    }return _memoryCapacity;
}
//磁盘容量
- (NSUInteger)diskCapacity
{
    if (!_diskCapacity) {
        _diskCapacity = 200 * 1024 * 1024;
    }return _diskCapacity;
}
//缓存时长
- (NSUInteger)cacheTime
{
    if (_cacheTime) {
        _cacheTime = 0;
    }return _cacheTime;
}


//子目录
- (NSString *)subDirectory
{
    if (!_subDirectory) {
        _subDirectory = @"UrlCacheDownload";
    }return _subDirectory;
}

/*
//是否为下载模式
- (BOOL)isDownloadMode
{
    if (!_isDownloadMode) {
        _isDownloadMode = NO;//默认不是下载模式
    }return _isDownloadMode;
}

//是否存磁盘
- (BOOL)isSaveOnDisk
{
    if (!_isSaveOnDisk) {
        _isSaveOnDisk = NO;//默认不存磁盘
    }return _isSaveOnDisk;
}
*/


//磁盘路径
- (NSString *)diskPath
{
    if (!_diskPath){
        self.diskPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }return _diskPath;
}

//防止下载请求的循环调用字典
- (NSMutableDictionary *)responseDic
{
    if (!_responseDic) {
        _responseDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }return _responseDic;
}

//缓存文件夹
- (NSString *)cacheFolder
{
    if (!_cacheFolder) {
        _cacheFolder = @"Url";
    }return _cacheFolder;
}

//域名白名单字典
- (NSMutableDictionary *)whiteListsHostDic
{
    if (!_whiteListsHostDic) {
        _whiteListsHostDic = [NSMutableDictionary  dictionary];
    }return _whiteListsHostDic;
}

//请求地址白名单字典
- (NSMutableDictionary *)whiteListsRequestUrlDic
{
    if (!_whiteListsRequestUrlDic) {
        _whiteListsRequestUrlDic = [NSMutableDictionary dictionary];
    }return _whiteListsRequestUrlDic;
}

//webview的user-agent白名单
- (NSString *)whiteUserAgent
{
    if (_whiteUserAgent) {
        _whiteUserAgent = @"";
    }return _whiteUserAgent;
}

//replaceUrl
- (NSString *)replaceUrl
{
    if (!_replaceUrl) {
        _replaceUrl = @"";
    }return _replaceUrl;
}


@end





