//
//  AppDelegate.m
//  Dirtoon
//
//  Created by godloong on 2018/12/26.
//  Copyright © 2018 godloong. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Connect.h"
#import "TabBarViewController.h"
#import "PersonalViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
    [self.window setRootViewController:tabBarController];
    HomeViewController * cartoonRoot = [[HomeViewController alloc]init];
    cartoonRoot.view.backgroundColor = [UIColor greenColor];
    cartoonRoot.navigationItem.title = @"热门推荐";
    UINavigationController * cartoonNav = [[UINavigationController alloc] initWithRootViewController:cartoonRoot];
    cartoonNav.tabBarItem.title = @"小漫";
    cartoonNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_cartoon_normal"];
    
    PersonalViewController * personalRoot = [[PersonalViewController alloc]init];
    personalRoot.navigationItem.title = @"个人";
    UINavigationController * personalNav = [[UINavigationController alloc] initWithRootViewController:personalRoot];
    personalNav.tabBarItem.title = @"个人";
    personalNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_personal_normal"];
    
    tabBarController.viewControllers = @[cartoonNav,personalNav];
    [[Connect sharedConnect] checkVersion];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}



@end
