//
//  SDAddViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/11.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDAddViewController.h"
#import "SDAddTableViewCell.h"

@interface SDAddViewController ()<UITableViewDelegate,UITableViewDataSource>

// 表
@property (nonatomic , strong) UITableView * AddTabelView;

@end

@implementation SDAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Add";

    // 自定义返回按钮LeftButtonItme
    [self makeLeftButtonItme];
    
    // 定义tabelView
    [self makeAddTabelView];
    
    // Do any additional setup after loading the view.
}
- (void)makeLeftButtonItme
{
    UIImage * backImage = [UIImage imageNamed:@"back.png"];
    CGRect backframe = CGRectMake(0, 0, 54, 30);
    UIButton * backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
   
}
- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeAddTabelView
{
    self.AddTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.AddTabelView.delegate = self;
    self.AddTabelView.dataSource = self;
    
    [self.AddTabelView registerClass:[SDAddTableViewCell class]
              forCellReuseIdentifier:@"AddCELL"];
    
    [self.view addSubview:self.AddTabelView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForRowAtIndexPath:( NSIndexPath *)indexPath
{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDAddTableViewCell * addCell = [tableView dequeueReusableCellWithIdentifier:@"AddCELL" forIndexPath:indexPath];
    addCell.textLabel.text = @"测试";
    return addCell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"我的指标";
    }else{
        return @"推荐指标";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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