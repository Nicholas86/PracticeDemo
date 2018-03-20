//
//  PopViewController.m
//  TestDelegate
//
//  Created by a on 2018/2/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "PopViewController.h"
#import "QuanViewController.h"

@interface PopViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)popBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(passTitleString:)]) {
        CGFloat height = [self.delegate  passTitleString:@"山楂条"];
        self.titleLabel.text = [NSString stringWithFormat:@"标题:%.2f", height];
        NSLog(@"height:%.2f", height);
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)handleQuan:(id)sender {
    QuanViewController *quanVC = [[QuanViewController  alloc] init];
    [self.navigationController pushViewController:quanVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
