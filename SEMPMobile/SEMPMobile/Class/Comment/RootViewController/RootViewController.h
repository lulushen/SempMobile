//
//  RootViewController.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/8/1.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "YXCustomActionSheet.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+Helper.h"

@interface RootViewController : BaseViewController

/**
 *  显示标签栏
 */
- (void)showTabBar;
/**
 *  隐藏标签栏
 */
- (void)hideTabbar;


- (void)ScreenShot;

@end
