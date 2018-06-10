//
//  NMatlabViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/6.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NMatlabViewController.h"
#import "NStudent.h"
#import "NEmployee.h" //数据节点
#import "NEmployeeManager.h" //数据节点管理类

@interface NMatlabViewController (){
    NStudent *ptr;
    int select;
    NEmployeeManager *employeeManager;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation NMatlabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"算法";
    
    //找出数组重复数字
    //[self  checkDuplicateNumber];
    
    //LRU淘汰算法 -- 从左到右顺序插入数据
    select = 0;
    //[self  lru];
    //LRU淘汰算法 -- 头部、末尾、中间插入数据
    employeeManager = [[NEmployeeManager  alloc] init];
    [self  lru_head_tail_midd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//找出数组重复数字
- (void)checkDuplicateNumber
{
    NSMutableArray *numbers = [NSMutableArray  arrayWithObjects:@2, @3, @1, @5, @0, @2, @7, @9, @1, nil];
    [self  duplicateWithNumberArray:numbers];
}


#pragma mark private methods
/*
 以数组为例, 找出重复数字。[2, 3, 1, 5, 0, 2, 7, 9, 1]
 */
- (BOOL)duplicateWithNumberArray:(NSMutableArray *)numbers
{
    if (numbers.count <= 0 ) {
        NSLog(@"数组为空");
        return NO;
    }
    
    //数字范围: 0 ~ 9, 没有负数
    int length = [[NSString  stringWithFormat:@"%ld", numbers.count] intValue];
    for (int i = 0; i < length; ++i) {
        if (numbers[i] < 0) {
            return NO;
        }
    }
    
    
    for (int i = 0; i < length; ++i) {
        
        while ([numbers[i] intValue] != i) {
            if (numbers[i] == numbers[[numbers[i]  intValue]]) {
                NSLog(@"重复数字: %@", numbers[i]);
                return YES;
            }
            //取临时变量
            int temNumber = [numbers[i]  intValue];
            //以临时变量为下标, 去除对应下边的值, 并与临时变量交换
            numbers[i] = numbers[temNumber];
            numbers[temNumber] = @(temNumber);
        }
                
    }
    
    return NO;
}


///lru淘汰算法
- (void)lru
{
    /*
     新写入的缓存, 顺序添加到链表的后面
     */
    NStudent *student = [[NStudent  alloc] init];
    student.name = @"谢霆锋";
    student.lLink = nil; //左链接指针
    student.rLink = nil; //右链接指针
    
    /*
     ①设置存取指针开始的位置(ptr变量就是一个指针)
     ptr(指针) 指向 student所在的内存地址, 也就是ptr和student共用一块内存地址。
     */
    ptr = student;

    
    while (TRUE) {
        if (select == 5) {
            break;
        }
        NStudent *newStudent = [[NStudent  alloc] init];
        newStudent.name = [NSString stringWithFormat:@"新学生, %d", select];
        newStudent.no = [NSString stringWithFormat:@"学号, %d", select];
        newStudent.Math = 98;
        newStudent.Eng = 99;
        
        /*
         ②输入节点结构中的数据 -- 新加入的数据放入右节点
         第一次for循环时,ptr指针(也就是跟student共用一块内存地址)的rLink指针指向newStudent所在内存地址
         */
        ptr.rLink = newStudent;
        newStudent.rLink = nil;//③下一个元素的next先设置为None
        newStudent.lLink = ptr;//④存取指针设置为新元素所在的位置
        ptr = newStudent;//⑤ptr引用newStuent, 也就是ptr(指针)重新指向newStuent所在的内存地址。ptr和newStuent共用一块内存地址。
        select ++;
    }
    

    /*
     参见第②步
     使ptr=student.rLink, 共用同一块内存地址
     */
    ptr = student.rLink;///设置存取指针从链表头的右指针字段所指节点开始(也就是回到原点)
    NSLog(@"😆student_lLink, %@, %@", [student.lLink name], [student.lLink no]);
    NSLog(@"😆student_rLink, %@, %@", [student.rLink name], [student.rLink no]);
    
    NSLog(@"-----------①从左向右便利所有节点-----------");
    while (ptr != nil) {
        NSLog(@"%@, %@", [ptr name], [ptr no]);
        if (ptr.rLink == nil) {
            break;
        }
        ptr = ptr.rLink; //将ptr移往右边下一个元素
    }
    
    
    NSLog(@"-----------②从右向左便利所有节点-----------");
    while (ptr != nil) {
        NSLog(@"%@, %@", [ptr name], [ptr no]);
        if (ptr.lLink == student) {
            break;
        }
        ptr = ptr.lLink; //将ptr移往左边上一个元素
    }

}

//lru算法  -- 头部、末尾、中间插入数据
- (void)lru_head_tail_midd
{
    while (true) {
        if (select == 10) {
            break;
        }
        //创建要插入的数据
        NEmployee *employee = [[NEmployee  alloc] init];
        employee.name = [NSString  stringWithFormat:@"刘德华%d", select];
        employee.salary = select;
        employee.no = [NSString stringWithFormat:@"编号, %d", select];
        employee.key = [NSString  stringWithFormat:@"员工%d", select];
        //添加到链表头部
        //[employeeManager  insertEmployeeAtHead:employee];
        
        //如果内存字典中没有, 添加到链表尾部
        [employeeManager  insertEmployeeAtTail:employee];
        select ++;
    }
    
    //便利所有节点数据
    [employeeManager  enumAllEmployee];
}


#pragma mark 添加到缓存

- (IBAction)handleSaveObject:(UIButton *)sender
{
    [self  lru_head_tail_midd];
}

#pragma mark 获取缓存

- (IBAction)handleGetObject:(UIButton *)sender
{
    NEmployee *get_employee = [employeeManager  employeeForKey:@"员工8"];
    if (get_employee) {
        //如果内存字典中有, 移动到链表头部
        [employeeManager  bringEmployeeToHead:get_employee];
    }else{
        get_employee = [[NEmployee  alloc] init];
        get_employee.name = @"刘德华8";
        get_employee.salary = 8;
        get_employee.no = @"编号8";
        get_employee.key = @"员工8";
        //如果内存字典中没有, 添加到链表头部
        [employeeManager  insertEmployeeAtHead:get_employee];
    }
    self.titleLabel.text = get_employee.name;
    //便利所有节点数据
    [employeeManager  enumAllEmployee];
}

#pragma mark 删除缓存

- (IBAction)handlRemoveObject:(UIButton *)sender
{
    //获取节点
    NEmployee *get_employee = [employeeManager  employeeForKey:@"员工8"];
    if (get_employee) {
        //移除节点
        [employeeManager  removeEmployee:get_employee];
    }
    [employeeManager  enumAllEmployee];
}

#pragma mark 删除尾部节点缓存
- (IBAction)handleRemoveTailObject:(UIButton *)sender
{
    //删除尾部节点缓存
    [employeeManager  removeEmployeeAtTail];
    [employeeManager  enumAllEmployee];
}


@end



