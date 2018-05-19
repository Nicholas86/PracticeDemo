//
//  NTipsModel.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTipsModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *auther;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *postdate;
@property (nonatomic, assign) NSInteger platform;
@property (nonatomic, copy, readonly) NSString *platformString;

+ (instancetype)tipsModelWithDictionary:(NSDictionary *)dictionary;

@end
