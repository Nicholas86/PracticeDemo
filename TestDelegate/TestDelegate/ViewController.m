//
//  ViewController.m
//  TestDelegate
//
//  Created by a on 2018/2/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "ViewController.h"
#import "PopViewController.h"
#import "CustomBtn.h"
#import "UrlCacheViewController.h"

@interface ViewController ()<CustomBtnDelegate, CustomBtnDataSource, PopViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //高度默认为0,代理方法里面,再动态改变
    CustomBtn *customBtn = [[CustomBtn alloc] initWithFrame:CGRectMake(60, 500, 300, 0)];
    customBtn.backgroundColor = [UIColor  lightGrayColor];
    customBtn.delegate = self;
    customBtn.dataSource = self;
    [self.view   addSubview:customBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按钮上覆盖一层view,测试 事件响应者链UIResponder
- (IBAction)pushBtn:(id)sender
{
    PopViewController *popVC = [[PopViewController alloc] init];
    popVC.delegate = self;
    [self.navigationController pushViewController:popVC animated:YES];
}

- (CGFloat)passTitleString:(NSString *)titleString
{
    NSLog(@"传过来:%@", titleString);
    self.titleLabel.text = titleString;
    return 5.0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 10* section;
}


#pragma mark 去缓存
- (IBAction)handleCacheBtn:(id)sender
{
    UrlCacheViewController *urlCacheVC = [[UrlCacheViewController alloc] init];
    [self.navigationController pushViewController:urlCacheVC animated:YES];
}

@end




