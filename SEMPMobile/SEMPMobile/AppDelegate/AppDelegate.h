//
//  AppDelegate.h
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/10.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)SDTabBarViewController * tabBarController;

- (void)mainTab;


@end

