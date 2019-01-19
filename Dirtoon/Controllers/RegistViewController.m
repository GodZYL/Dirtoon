//
//  SignViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginRegistField.h"
#import "PureLayout.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LoginRegistField *usernameField = [[LoginRegistField alloc] init];
    usernameField.leftLabel.text = @" 用户名";
    [self.view addSubview:usernameField];
    [usernameField autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [usernameField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [usernameField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-SCREEN_WIDTH/375*80];
    
    LoginRegistField *passwordField = [[LoginRegistField alloc] init];
    passwordField.leftLabel.text = @" 密    码";
    [self.view addSubview:passwordField];
    [passwordField autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [passwordField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [passwordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:usernameField withOffset:SCREEN_WIDTH/375*20];
    
    UIButton *signButton = [[UIButton alloc] init];
    signButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    signButton.layer.cornerRadius = SCREEN_WIDTH/375*15;
    signButton.layer.masksToBounds = YES;
    signButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*20];
    [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signButton setTitle:@"注册" forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signButton];
    
}

@end
