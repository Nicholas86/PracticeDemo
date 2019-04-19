//
//  NAnimationVC.m
//  TestDelegate
//
//  Created by Nicholas on 2019/4/18.
//  Copyright © 2019 a. All rights reserved.
//

#import "NAnimationVC.h"

@interface NAnimationVC ()
{
    CGFloat progressValue;
    CAShapeLayer *progressLayer;
}
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation NAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"动画";
    
    [self basicShareLayer];
    
    /// 已经进行的进度
    progressValue = 0;
    [self createSubViews];
    [self createSubLayer];
    [self createCAReplicatorLayer];
}

- (void)basicShareLayer
{
    /// 创建贝塞尔曲线(圆形)
    CGRect frame = CGRectMake(0, 0, 50, 50);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    /// 创建CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(150, 100, 50, 50);
    //shapeLayer.position = self.view.center; /// 设置layer的位置
    shapeLayer.fillColor = [UIColor clearColor].CGColor; /// 设置layer的填充色
    shapeLayer.strokeColor = [UIColor redColor].CGColor; /// 设置layer边框的填充色
    shapeLayer.lineWidth = 2; /// 设置layer边框的宽度
    shapeLayer.strokeStart = 0; /// 设置layer边框的起点位置
    shapeLayer.strokeEnd = 1; /// 设置layer边框的终点位置
    shapeLayer.lineDashPattern = @[@5, @2, @10, @5]; /// 设置虚实线
    
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}

- (void)createSubViews
{
    CGRect frame = CGRectMake(20, 100, 100, 100);
    self.backView = [[UIView alloc] initWithFrame:frame];
    _backView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_backView];
    
    CGRect numberFrame = CGRectMake(0, 0, 50, 30);
    self.numberLabel = [[UILabel alloc] initWithFrame:numberFrame];
    _numberLabel.backgroundColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont systemFontOfSize:13];
    _numberLabel.center = _backView.center;
    [self.view addSubview:_numberLabel];
    
    CGRect textFieldFrame = CGRectMake(20, 220, 70, 30);
    self.numberTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
    _numberTextField.backgroundColor = [UIColor lightGrayColor];
    _numberTextField.placeholder = @"请输入数字(范围0~100)";
    _numberTextField.font = [UIFont systemFontOfSize:12];
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_numberTextField];
    
    CGRect buttonFrame = CGRectMake(100, 220, 60, 30);
    self.clickButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _clickButton.frame = buttonFrame;
    _clickButton.backgroundColor = [UIColor lightGrayColor];
    [_clickButton setTitle:@"开始" forState:(UIControlStateNormal)];
    [_clickButton addTarget:self action:@selector(handleClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_clickButton];
}

- (void)createSubLayer
{
    /// 1. 灰色贝塞尔曲线
    /// 创建圆形贝塞尔曲线
    /// UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_backView.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds cornerRadius:(_backView.bounds.size.width) / 2];
    
    CAShapeLayer *circleShapeLayer = [CAShapeLayer layer];
    circleShapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_backView.frame), CGRectGetHeight(_backView.frame));
    circleShapeLayer.position = CGPointMake(CGRectGetWidth(_backView.frame) / 2, CGRectGetHeight(_backView.frame) / 2);
    circleShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor; ///描边(边框)颜色
    circleShapeLayer.fillColor = [UIColor clearColor].CGColor; /// 填充色
    circleShapeLayer.lineWidth = 10; /// 线宽
    circleShapeLayer.path = path.CGPath;
    [_backView.layer addSublayer:circleShapeLayer];
    
    /// 2.创建进度曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds cornerRadius:(_backView.bounds.size.width) / 2];/// [UIBezierPath bezierPathWithArcCenter:CGPointMake((_backView.bounds.size.width) / 2, (_backView.bounds.size.height) / 2) radius:(_backView.bounds.size.width) / 2 startAngle:0 endAngle:8 clockwise:YES];
    
    progressLayer = [CAShapeLayer layer];
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 1;
    progressLayer.strokeColor = [UIColor redColor].CGColor; /// 描边颜色
    progressLayer.fillColor = [UIColor clearColor].CGColor; /// 填充颜色
    progressLayer.path = circlePath.CGPath;
    progressLayer.lineWidth = 10;
    [_backView.layer addSublayer:progressLayer];
}

- (void)handleClick
{
    //初始化各种数值
    progressLayer.strokeEnd = 0;
    progressValue = 0;
    
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.04 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            if (progressValue > [self expectValue]) {
                [timer invalidate];
                return ;
            }
            
            if (([self expectValue] > progressValue) && (progressValue > ([self expectValue] - 1))) {
                [timer invalidate];
                progressLayer.strokeEnd = [self expectValue] / 100;
                _numberTextField.text = [NSString stringWithFormat:@"%.2f", [self expectValue]];
                return;
            }
            
            progressLayer.strokeEnd = progressValue / 100;
            _numberLabel.text = [NSString stringWithFormat:@"%.2f", progressValue];
            progressValue += 1;
            NSLog(@"progressLayer.strokeEnd: %.2f, progressValue:%.2f", progressLayer.strokeEnd , progressValue);
        }];
    } else {
        // Fallback on earlier versions
    }
}


#warning https://www.jianshu.com/p/2e6facd8142f
/*
 1. CAReplicatorLayer可以将自己的子图层复制指定的次数,并且复制体 会保持被复制图层的各种基础属性以及动画
 2. CAReplicatorLayer是一个Layer容器，添加到容器上的子Layer可以复制若干份；
 */

///CAReplicatorLayer
- (void)createCAReplicatorLayer
{
    // 2.创建一个图层对象  单条柱形 (原始层)
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 10, 150);
    // 2.5.设置layer对象的颜色
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    // 3.创建一个基本动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    // 3.1.设置动画的属性
    basicAnimation.keyPath = @"transform.scale.y";
    // 3.2.设置动画的属性值
    basicAnimation.toValue = @0.1;
    // 3.3.设置动画的重复次数
    basicAnimation.repeatCount = MAXFLOAT;
    // 3.4.设置动画的执行时间
    basicAnimation.duration = 0.5;
    // 3.5.设置动画反转
    basicAnimation.autoreverses = YES;
    
    // 4.将动画添加到layer层上
    [layer addAnimation:basicAnimation forKey:nil];
    
    // 1.创建一个复制图层对象，设置复制层的属性
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(20, 300, 300, 150);
    replicatorLayer.backgroundColor = [UIColor redColor].CGColor;
    // 1.1.设置复制图层中子层总数：这里包含原始层
    replicatorLayer.instanceCount = 10;
    // 1.2.设置复制子层偏移量，不包含原始层，这里是相对于原始层的x轴的偏移量
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(25, 0, 0);
    // 1.3. 设置子层相对于前一个层的延迟时间
    replicatorLayer.instanceDelay = 0.1;
    // 1.4.设置复制层的背景色，如果原始层设置了背景色，这里设置就失去效果
    replicatorLayer.instanceColor = [UIColor greenColor].CGColor;
    // 1.5.设置复制层颜色的偏移量
    replicatorLayer.instanceRedOffset = -0.1; /// 设置每个复制图层相对上一个复制图层的红色偏移量
    replicatorLayer.instanceGreenOffset = -0.1; ///  设置每个复制图层相对上一个复制图层的绿色偏移量
    replicatorLayer.instanceBlueOffset = -0.1; /// 设置每个复制图层相对上一个复制图层的蓝色偏移量
    replicatorLayer.instanceAlphaOffset = 0.2; /// 设置每个复制图层相对上一个复制图层的透明度偏移量

    // 5.将layer层添加到复制层上
    [replicatorLayer addSublayer:layer];
    
    // 6.将复制层添加到view视图层上
    [self.view.layer addSublayer:replicatorLayer];
}

- (CGFloat)expectValue
{
    NSNumberFormatter *matter = [[NSNumberFormatter alloc] init];
    matter.numberStyle = kCFNumberFormatterNoStyle;   //去掉小数点 四舍五入保留整数 12346
    NSNumber *value = [matter numberFromString:_numberTextField.text];
    if (([value floatValue] >= 0) && ([value floatValue] <= 100)) {
        return [value floatValue];
    }
    return 1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
