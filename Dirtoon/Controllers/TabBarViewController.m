//
//  TabBarViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)sharedTabBarViewController {
    static TabBarViewController *_tabBarViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _tabBarViewController = [[super allocWithZone:NULL] init];
    });
    return _tabBarViewController;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [TabBarViewController sharedTabBarViewController];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [TabBarViewController sharedTabBarViewController];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [TabBarViewController sharedTabBarViewController];
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
