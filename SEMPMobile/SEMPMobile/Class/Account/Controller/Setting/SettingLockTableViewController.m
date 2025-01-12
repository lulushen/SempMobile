//
//  SettingLockTableViewController.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/10/8.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SettingLockTableViewController.h"
#import "SettingLockTableViewCell.h"
#import "CLLockVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MBProgressHUD+MJ.h"

@interface SettingLockTableViewController ()
@property (nonatomic , strong)NSString * lockString;

@end

@implementation SettingLockTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = DEFAULT_BGCOLOR;
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    

    [self.tableView registerClass:[SettingLockTableViewCell class] forCellReuseIdentifier:@"cell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingLockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString * lockTypeString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SettingLockType"];

    // Configure the cell...
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"选择锁类型";
        cell.titleLabel.textColor = MoreButtonColor;
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"PIN码";
        if ([lockTypeString isEqualToString:@"PIN"]) {
           
            cell.searchImageView.image = [UIImage imageNamed:@"searchLock.png"];

        }
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"手势";
        if ([lockTypeString isEqualToString:@"ShouShi"]) {
            
            cell.searchImageView.image = [UIImage imageNamed:@"searchLock.png"];
            
        }
    }else if (indexPath.row == 3){
        cell.titleLabel.text = @"指纹";
        if ([lockTypeString isEqualToString:@"ZhiWen"]) {
            
            cell.searchImageView.image = [UIImage imageNamed:@"searchLock.png"];
            
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50*KHeight6scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingLockTableViewCell * cell  = [tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath * oneIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath * twoIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath * threeIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    SettingLockTableViewCell * oneCell  = [tableView cellForRowAtIndexPath:oneIndexPath];
    SettingLockTableViewCell * twoCell  = [tableView cellForRowAtIndexPath:twoIndexPath];
    SettingLockTableViewCell * threeCell  = [tableView cellForRowAtIndexPath:threeIndexPath];
    oneCell.searchImageView.image = [UIImage imageNamed:@""];
    twoCell.searchImageView.image = [UIImage imageNamed:@""];
    threeCell.searchImageView.image = [UIImage imageNamed:@""];

    if (indexPath.row == 1) {
        cell.searchImageView.image = [UIImage imageNamed:@"searchLock.png"];
        _lockString = @"PIN";
    }else if (indexPath.row == 2){
        
        cell.searchImageView.image = [UIImage imageNamed:@"searchLock.png"];
        if ([_lockString isEqualToString:@"ShouShi"]) {
            /**
             *  修改密码
             */
            BOOL hasPwd = [CLLockVC hasPwd];
            
            if(!hasPwd){
                
                NSLog(@"你还没有设置密码，请先设置密码");
                
            }else {
                
                [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    [lockVC dismiss:.5f];
                }];
            }
            
        }else{
            _lockString = @"ShouShi";
            /**
             *  设置手势密码
             */
            BOOL hasPwd = [CLLockVC hasPwd];
            hasPwd = NO;
            if(hasPwd){
                
                NSLog(@"已经设置过密码了，你可以验证或者修改密码");
            }else{
                
                [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    NSLog(@"密码设置成功");
                    [lockVC dismiss:1.0f];
                }];
            }

            
        }
        
        
        

    }else if (indexPath.row == 3){
        
        cell.searchImageView.image = [UIImage imageNamed:@"searchLock.png"];
        _lockString = @"ZhiWen";
            
        [self evaluateAuthenticate];
        

    }else{
        _lockString = @"";
    }
    /**
     *  数据持久化（为了判断锁类型）
     */
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:_lockString forKey:@"SettingLockType"];
    [userDefault synchronize];
    
}
- (void)evaluateAuthenticate
{
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                NSLog(@"验证成功");
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权，如其他APP切入
                        NSLog(@"用户取消授权");

                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        NSLog(@"取消验证");
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        NSLog(@"授权失败");

                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        NSLog(@"系统未设置密码");

                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        NSLog(@"设备TouchID不可用");

                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        NSLog(@"设备TouchID不可用，用户未录入");

                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            NSLog(@"用户输入密码");

                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            NSLog(@"其他情况");

                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        NSLog(@"%@",error.localizedDescription);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
