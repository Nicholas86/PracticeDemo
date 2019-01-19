//
//  NUIViewCALayerViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/14.
//  Copyright © 2018年 a. All rights reserved.
//

/*
 今天在做项目的时候需要去除数组中的重复元素使用到了NSSet,对它并不熟悉,所以记录下来方便以后查找
 */

#import "NUIViewCALayerViewController.h"
#import "NDog.h"
#import "NBaseSingle.h"
#import "NSingle.h"
#import "NAPPSingle.h"
#import "NBackView.h"

@interface NUIViewCALayerViewController (){
    NSTimer *timer;
}
@property (nonatomic, strong) NSMutableArray *temp_array;
@property (nonatomic, strong) NSMutableSet *temp_set;
@property (nonatomic, strong) NSMutableDictionary *temp_dic;
@end

/*
 https://juejin.im/entry/58aacaba2f301e006c3624fa
 
 */

/*
在iOS中，你能看得见摸得着的东西基本上都是UIView，比如一个按钮、一个文本标签、一个文本输入框、一个图标等等，这些都是UIView，其实UIView之所以能显示在屏幕上，完全是因为它内部的一个图层，在创建UIView对象时，UIView内部会自动创建一个图层(即CALayer对象)，通过UIView的layer属性可以访问这个层：
 
 @property(nonatomic,readonly,retain) CALayer *layer;
 
 
当UIView需要显示到屏幕上时，会调用drawRect:方法进行绘图，并且会将所有内容绘制在自己的图层上，绘图完毕后，系统会将图层拷贝到屏幕上，于是就完成了UIView的显示。换句话说，UIView本身不具备显示的功能，是它内部的图层有显示功能。
 
 通过操作CALayer对象，可以很方便地调整UIView的一些外观属性，比如：阴影（如果设置了超过主图层的部分减掉，则设置阴影不会有显示效果；设置阴影，不光需要设置阴影颜色，还应该设置阴影的偏移位和透明度。因为如果不设置偏移位的话，那么阴影和layer完全重叠，且默认透明度为0，即完全透明）、圆角大小、边框宽度和颜色、还可以给图层添加动画，来实现一些比较炫酷的效果等等。
 */


/*
 二、UIView和CALayer之间的区别
 
 1、UIView是用来显示内容的，可以处理用户事件。直接继承UIResponser。
 2、CALayer是用来绘制内容的，不能处理用户事件。直接继承NSObject。
 3、 UIView和CALayer是相互依赖的关系。UIView依赖于CALayer提供的内容，CALayer依赖UIView提供的容器来显示绘制的内容。
 
 1.由于UIView继承自UIResponse,所以它是可以相应时间的，而CALayer是继承自NSObject，没有可以相应时间的接口。
 
 2.UIView侧重于展示内容，而CALayer则侧重于图形和界面的绘制。
 
 3.当View展示的时候，View是layer的CALayerDelegate,View展示的内容是由CALayer进行display的。
 
 4.View内容的展示依赖于CALayer对于内容的绘制，UIView的frame也是由内部的CALayer进行绘制的。
 
 5.对于UIView的属性修改，不会引起动画效果，但是对于CALayer的属性修改，是支持默认动画效果的，在VIew执行动画的时候，VIew是layer的代理，layer通过actionForLayer：forkey相对应的代理VIew请求动画action。
 ---------------------
 作者：NothingAndNone
 来源：CSDN
 原文：https://blog.csdn.net/zhanglei1239/article/details/50783773
 版权声明：本文为博主原创文章，转载请附上博文链接！
 */

/*
 总接来说就是如下几点：
 
 每个 UIView 内部都有一个 CALayer 在背后提供内容的绘制和显示，并且 UIView 的尺寸样式都由内部的 Layer 所提供。两者都有树状层级结构，layer 内部有 SubLayers，View 内部有 SubViews.但是 Layer 比 View 多了个AnchorPoint
 在 View显示的时候，UIView 做为 Layer 的 CALayerDelegate,View 的显示内容由内部的 CALayer 的 display
 CALayer 是默认修改属性支持隐式动画的，在给 UIView 的 Layer 做动画的时候，View 作为 Layer 的代理，Layer  通过 actionForLayer:forKey:向 View请求相应的 action(动画行为)
 layer 内部维护着三分 layer tree,分别是 presentLayer Tree(动画树),modeLayer Tree(模型树), Render Tree (渲染树),在做 iOS动画的时候，我们修改动画的属性，在动画的其实是 Layer 的 presentLayer的属性值,而最终展示在界面上的其实是提供 View的modelLayer
 两者最明显的区别是 View可以接受并处理事件，而 Layer 不可以
 
 作者：kissGod
 链接：https://www.jianshu.com/p/079e5cf0f014
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 */

/*
 
 2、UIView有一个layer属性，通过该属性我们可以获取它的主CALayer实例。该属性也告诉我们UIView是layer的代理。UIView需要显示时，它内部的层会准备好一个CGContextRef(图形上下文)，然后调用delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象。而UIView在drawLayer:inContext:方法中又会调用自己的drawRect:方法。这样view就可以在drawRect:方法中实现绘图，所有的东西都被绘制到view.layer上，最终系统将view.layer的内容拷贝到屏幕上。
 ---------------------
 作者：Longshihua
 来源：CSDN
 原文：https://blog.csdn.net/longshihua/article/details/79422371
 版权声明：本文为博主原创文章，转载请附上博文链接！
 */

/*
圆角(cornerRadius)和阴影(shadowColor), 二者不能同时出现, 所以可以通过两个重叠的UIView, 分别使其CALayer显示圆角和阴影.
*/

/*
 
 一个CALayer的frame是由其anchorPoint, position, bounds, transform共同决定的, 而一个UIView的的frame只是简单地返回CALayer的frame, 同样UIView的center和bounds也只是简单返回CALayer的Position和Bounds对应属性.
 ---------------------
 作者：踩着七色的晕菜
 来源：CSDN
 原文：https://blog.csdn.net/icetime17/article/details/48154021
 版权声明：本文为博主原创文章，转载请附上博文链接！
 */

/*
 UIView和CALayer的最明显区别在于他们的可交互性，即UIView可以响应用户事件，而CALayer则不可以，原因可以从这两个类的继承关系上看出，UIView是继承自UIRespinder的，明显是专门用来处理响应事件的，而CALayer是直接继承自NSObject无法进行交互。
 ---------------------
 作者：Mr_厚厚
 来源：CSDN
 原文：https://blog.csdn.net/cordova/article/details/53127254
 版权声明：本文为博主原创文章，转载请附上博文链接！
 */

@implementation NUIViewCALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIView和CALayer的联系和区别";
    
    self.view.backgroundColor = [UIColor  whiteColor];
    
    [self uiview_calayer];
    [self back_view];
    
    /*
    [self setObject];
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self object];
        }];
    } else {
        // Fallback on earlier versions
    }
    [timer fire];
    
    [self set];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiview_calayer
{
    CGRect frame = CGRectMake(30, 100, 100, 100);
    UIView  *backView = [[UIView  alloc] initWithFrame:frame];
    backView.backgroundColor = [UIColor lightGrayColor];
    // 可以通过设置contents属性给UIView设置背景图片:
    backView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"nicholas.PNG"].CGImage); // 跨框架赋值需要进行桥接
    backView.layer.masksToBounds = YES;
    [self.view  addSubview:backView];
}

- (void)back_view
{
    CGRect frame = CGRectMake(50, 220, 100, 100);
    NBackView  *backView = [[NBackView  alloc] initWithFrame:frame];
    // backView.backgroundColor = [UIColor orangeColor];
    backView.layer.masksToBounds = YES;
    [self.view  addSubview:backView];
}

- (void)set
{
    NSArray *array = @[@"哈", @"哼", @"呀"];
    // 通过数组创建集合. 集合是无序的
    NSSet *set = [NSSet setWithArray:array];
    NSLog(@"set: %@", set);
    //以数组的形式返回集合中所有的对象
    NSArray *temp_array = [set allObjects];
    NSLog(@"temp_array: %@", temp_array);
}

- (void)setObject
{
    NDog *dog1 = [[NDog alloc] init];
    dog1.name = @"哈";
    
    NDog *dog2 = [[NDog alloc] init];
    dog2.name = @"哼";
    
    NDog *dog3 = [[NDog alloc] init];
    dog3.name = @"啊";
    
    self.temp_dic[dog1.name] = dog1;
    self.temp_dic[dog2.name] = dog2;
    self.temp_dic[dog3.name] = dog2;
    
    [self.temp_set addObject:dog1];
    [self.temp_set addObject:dog2];
    [self.temp_set addObject:dog3];
    
    NSLog(@"---- temp_set: %@", _temp_set);
    
    self.temp_array = (NSMutableArray *)[self.temp_set allObjects];
}


- (void)object
{
    NDog *dog = self.temp_dic[@"哈"];
    dog.name = @"呀";
    [self.temp_set addObject:dog];
    
    NSLog(@"****** temp_set: %@", _temp_set);
    [self.temp_set enumerateObjectsUsingBlock:^(NDog *obj, BOOL * _Nonnull stop) {
        NSLog(@"temp_set, name: %@", obj.name);
    }];
    
    self.temp_array = (NSMutableArray *)[self.temp_set allObjects];
    [self.temp_array enumerateObjectsUsingBlock:^(NDog *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"temp_array, name: %@, idx: %lu", obj.name, (unsigned long)idx);
    }];
}


- (NSMutableArray *)temp_array
{
    if (!_temp_array) {
        self.temp_array = [NSMutableArray array];
    }return _temp_array;
}

- (NSMutableSet *)temp_set
{
    if (!_temp_set) {
        self.temp_set = [NSMutableSet set];
    }return _temp_set;
}

- (NSMutableDictionary *)temp_dic
{
    if (!_temp_dic) {
        self.temp_dic = [NSMutableDictionary  dictionary];
    }return _temp_dic;
}

@end




