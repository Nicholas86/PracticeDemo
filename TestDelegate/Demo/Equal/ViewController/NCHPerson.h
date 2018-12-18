//
//  NCHPerson.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/14.
//  Copyright © 2018 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 
 NSArray的检测方式为先看两个数组所含对象个数是否相同,若相同,则在每个对应位置的两个对象身上调用其"isEqual:"方法.如果对应位置上的对象均相等,那么这两个数组就相等,这叫做"深度等同性判定".不过有时候无须将所有数据逐个比较,只根据其中部分数据即可判明二者是否等同.
 
 比方说,我们假设NCHPerson类的实例是根据数据库里的数据创建而来,那么其中就可能会含有另外一个属性,此属性是"唯一标识符",在数据库中用作"主键",在这种情况下,我们也许只会根据标识符来判断等同性,尤其是在此属性声明为readonly时更应该如此.
 链接：https://www.jianshu.com/p/8f0e09a43b05
 */
@interface NCHPerson : NSObject
@property (nonatomic,readonly, copy) NSString *identifier; // 标识符
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,assign) NSInteger age;

- (id)initWithIdentifier:(NSString *)identifier FirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
