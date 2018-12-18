//
//  NCHPerson.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/14.
//  Copyright © 2018 a. All rights reserved.
//

#import "NCHPerson.h"

@implementation NCHPerson

- (id)initWithIdentifier:(NSString *)identifier FirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSInteger)age
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        _firstName = firstName;
        _lastName = lastName;
        _age = age;
    }return self;
}


- (BOOL)isEqualToPerson:(NCHPerson *) person
{
    if (self == person) { // 指针相等
        return YES;
    }
    
    if (![_firstName isEqualToString:person.firstName]) {
        return NO;
    }
    
    if (![_lastName isEqualToString:person.lastName]) {
        return NO;
    }
    
    if (_age != person.age) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isEqual:(id)object
{
    if ([self class] == [object class]) { // 同一个类
        return [self isEqualToPerson:(NCHPerson *)object];
    }else{
        return [super isEqual:object]; // 不是同一个类
    }
}


/// 为hash table 所用, 其对应的isEqual 用到这个值
- (NSUInteger)hash
{
    /*
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@%lu",_firstName,_lastName,(unsigned long)_age];
    return [stringToHash hash];
     
     上面这段代码用的方法是将NCHPerson对象中的属性都塞入另一个字符串中,然后令hash方法返回该字符串的哈希码.
     这样做是满足要求的,但是这样做需要先创建字符串,比返回单一值要慢.
     而且把这种对象添加到collection中时,也会产生性能问题,因为要想添加,必须先计算其哈希码.
    */
    
    NSInteger firstNameHash = [_firstName hash];
    NSInteger lastNameHash = [_lastName hash];
    NSInteger ageHash = _age;
    
    return firstNameHash ^ lastNameHash ^ ageHash;
    
    /*
     最终采用这种方法,先返回各字段的hash值,再将这些hash值做异或运算,这种做法既能保持较高效率,又能使生成的hash码至少位于一定范围内,而不会过于频繁地重复.
     */
}
/*
 
 NSArray的检测方式为先看两个数组所含对象个数是否相同,若相同,则在每个对应位置的两个对象身上调用其"isEqual:"方法.如果对应位置上的对象均相等,那么这两个数组就相等,这叫做"深度等同性判定".不过有时候无须将所有数据逐个比较,只根据其中部分数据即可判明二者是否等同.
 比方说,我们假设EOCPerson类的实例是根据数据库里的数据创建而来,那么其中就可能会含有另外一个属性,此属性是"唯一标识符",在数据库中用作"主键",在这种情况下,我们也许只会根据标识符来判断等同性,尤其是在此属性声明为readonly时更应该如此.
  链接：https://www.jianshu.com/p/8f0e09a43b05
 */
@end
