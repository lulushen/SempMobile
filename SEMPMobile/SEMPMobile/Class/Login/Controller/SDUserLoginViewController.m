//
//  SDUserLoginViewController.m
//  SempMobile
//
//  Created by 上海数聚 on 16/7/9.
//  Copyright © 2016年 上海数聚. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "SDUserLoginViewController.h"
#import "TabBarControllerConfig.h"
#import "MBProgressHUD+MJ.h"
#import "userModel.h"
#import "AFNetworking.h"
#import "DashBoardModel.h"
#import "DashBoardViewController.h"


@interface SDUserLoginViewController ()<UITextFieldDelegate>
{
    UIImageView * userLoginImageView;
    UIAlertController * _alert;
    UIAlertController * _alertLoginFail;
    UIAlertController * _alertDidRegiest;
    NSMutableDictionary *_temDic;
    userModel * model;
    NSMutableArray    * _dashDictArray;
    NSInteger infoCount;
    NSMutableArray * infoArray;
}
@property (nonatomic , strong)NSString * info;

@end

@implementation SDUserLoginViewController
//#pragma mrak 声明一个md5加密方法
//- (NSString *)md5HexDigest:(NSString*)password
//{
//    const char *original_str = [password UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(original_str, (int)strlen(original_str), result);
//    NSMutableString *hash = [NSMutableString string];
//    for (int i = 0; i < 16; i++)
//    {
//        [hash appendFormat:@"%02x", result[i]];
//    }
//    NSString *mdfiveString = [hash lowercaseString];
//
//    NSLog(@"Encryption Result = %@",mdfiveString);
//    return mdfiveString;
//}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userlogin.png"]];
    
    userLoginImageView  = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    userLoginImageView.image = [UIImage imageNamed:@"userlogin.png"];
    
    userLoginImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:userLoginImageView];
    
    // 调用设置控件的方法
    [self makeUI];
    
}
- (void)makeUI{
    
    
    self.biaoshiTextField  = [[UITextField alloc] initWithFrame:CGRectMake(100*KWidth6scale, 232*KHeight6scale, 200*KWidth6scale, 35*KHeight6scale)];
    
    self.biaoshiTextField.backgroundColor = [UIColor whiteColor];
    
    [userLoginImageView addSubview:self.biaoshiTextField];
    
    self.userTextField  = [[UITextField alloc] initWithFrame:CGRectMake(100*KWidth6scale, CGRectGetMaxY(self.biaoshiTextField.frame) + 27*KHeight6scale, 200*KWidth6scale, CGRectGetHeight(self.biaoshiTextField.frame))];
    
    self.userTextField.backgroundColor = [UIColor whiteColor];
    
    [userLoginImageView addSubview:self.userTextField];
    
    self.passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userTextField.frame), CGRectGetMaxY(self.userTextField.frame)+27*KHeight6scale, CGRectGetWidth(self.userTextField.frame), CGRectGetHeight(self.userTextField.frame))];
    
    self.passWordTextField.backgroundColor = [UIColor whiteColor];
    
    self.passWordTextField.secureTextEntry = YES;
    
    [userLoginImageView addSubview:self.passWordTextField];
    
    self.LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.LoginButton.frame = CGRectMake(Main_Screen_Width/2 - 75*KWidth6scale,CGRectGetMaxY(self.passWordTextField.frame) + 30*KHeight6scale, 150*KWidth6scale, CGRectGetHeight(self.passWordTextField.frame));
    //    [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    //    self.LoginButton.backgroundColor = [UIColor grayColor];
    [self.LoginButton addTarget:self action:@selector(LoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [userLoginImageView addSubview:self.LoginButton];
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    backbutton.frame = CGRectMake(10, 20, 80, 50);
    
    [userLoginImageView addSubview:backbutton];
    
    [backbutton addTarget:self action:@selector(backbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backbuttonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)LoginButtonClick:(UIButton *)button{
    if (button.selected == YES) {
        
    }else{
        button.selected = YES;
        
        
        self.userTextField.text = @"mobile";
        self.passWordTextField.text = @"111111";
        //1.获取一个全局串行队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.把任务添加到队列中执行
        dispatch_async(queue, ^{
            
            // 1.设置请求路径
            NSString * urlStr = [NSString stringWithFormat:LoginHttp];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            NSDictionary *parameters = @{@"loginname":self.userTextField.text,@"password":self.passWordTextField.text};
            
            [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"---用户登录的responseObject--%@",responseObject);
                //            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                NSMutableDictionary * dict = nil;
                dict = responseObject;
                
                if (responseObject != nil) {
                    
                    model = [[userModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:responseObject];
                    
                    NSInteger status = model.status;
                    
                    if (status == 1) {
                        
                        // 数据持久化
                        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setObject:dict forKey:@"userResponseObject"];
                        [userDefault synchronize];
                        
                        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
                        NSLog(@"APP_Path = %@", path);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self makeInfoData];
                            [self makeDashBoardData];
                            
                            [MBProgressHUD showSuccess:model.message];
                            
                            //  AppDelegate * app = [[AppDelegate alloc] init];
                            //  [app mainTab];
                            
                        });
                        
                    } else {
                        
                        [MBProgressHUD showSuccess:model.message];
                    }
                    dict = nil;
                    
                    
                }else{
                    
                    [MBProgressHUD showSuccess:@"请求数据为空，登录失败"];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD showSuccess:@"可能服务器停止或断网，解析登录失败"];
                
            }];
            
        });
    }
}
- (void)GoToDashView
{
    TabBarControllerConfig *tabBarConfig = [[TabBarControllerConfig alloc]init];
    
    tabBarConfig.tabBarBadgeValueString = [NSString stringWithFormat:@"%ld",infoCount];
    
    [self presentViewController:tabBarConfig.tabBarController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.userTextField resignFirstResponder];
    
    [self.passWordTextField resignFirstResponder];
}
#pragma == 指标
- (void)makeDashBoardData
{
    
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        NSMutableDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userResponseObject"];
        NSString * token = [userDict valueForKey:@"user_token"];
        
        NSMutableDictionary * dict = [userDict valueForKey:@"resdata"];
        
        NSString * time = [NSString stringWithFormat:@"%@",dict[@"defaulttime"]];
        
        // 指标界面的接口
        NSString * urlStr = [NSString stringWithFormat:DashBoardHttp,token,time];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _dashDictArray = [NSMutableArray array];
            //成功
            if (responseObject != nil) {
                
                //                NSMutableArray * array = [NSMutableArray array];
                NSMutableArray * array = nil;
                array = [responseObject valueForKey:@"resdata"];
                
                for (NSDictionary * dict in array) {
                    
                    [_dashDictArray addObject:dict];
                    
                }
                [[NSUserDefaults standardUserDefaults] setObject:_dashDictArray forKey:@"array"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 延迟0.1秒跳转页面
                [self performSelector:@selector(GoToDashView) withObject:self afterDelay:0.1f];
                array = nil;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            [MBProgressHUD showSuccess:@"请检查网略"];
            
        }];
        
    });
    
}
/**
 *   消息中心数据
 */
- (void)makeInfoData
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * urlStr = [NSString stringWithFormat:userInfoHttp];
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //这里可以用来显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject != nil) {
                
                infoArray = [NSMutableArray array];
                
                infoArray = responseObject[@"resdata"];
                
                NSMutableArray * noReadInfoArray = [NSMutableArray array];
                
                for (NSMutableDictionary * dict in infoArray) {
                    
                    if ([dict[@"readflag"] integerValue] == 0) {
                        
                        [noReadInfoArray addObject:dict];
                        
                    }else{
                        
                    }
                    
                }
                
                infoCount = noReadInfoArray.count;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            NSLog(@"failure  error ： %@",error);
            
        }];
        
    });
    
}

- (void)dealloc
{
    NSLog(@"userLoginDealloc");
    _dashDictArray = nil;
    infoArray = nil;
    userLoginImageView = nil;
    _alert = nil;
    _alertLoginFail = nil;
    _alertDidRegiest = nil;
    _temDic = nil;
    model = nil;
    _info = nil;
    [self.view removeFromSuperview];
    
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
