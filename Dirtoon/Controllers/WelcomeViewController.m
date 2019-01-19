//
//  WelcomeViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PureLayout.h"
#import "RegistViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *quitButton = [[UIButton alloc] init];
    [quitButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    [quitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [quitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [quitButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*40, SCREEN_WIDTH/375*40)];
    
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    loginButton.layer.cornerRadius = SCREEN_WIDTH/375*35;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.borderColor = UIColorWithRGBA(43, 125, 188, 1).CGColor;
    loginButton.layer.borderWidth = SCREEN_WIDTH/375*0;
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*30];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [loginButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-SCREEN_WIDTH/375*50];
    [loginButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*70)];
    
    UIButton *signButton = [[UIButton alloc] init];
    signButton.backgroundColor = [UIColor whiteColor];
    signButton.layer.cornerRadius = SCREEN_WIDTH/375*35;
    signButton.layer.masksToBounds = YES;
    signButton.layer.borderColor = UIColorWithRGBA(43, 125, 188, 1).CGColor;
    signButton.layer.borderWidth = SCREEN_WIDTH/375*2;
    signButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*30];
    [signButton setTitleColor:UIColorWithRGBA(43, 125, 188, 1) forState:UIControlStateNormal];
    [signButton setTitle:@"注册" forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(signButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signButton];
    [signButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [signButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:SCREEN_WIDTH/375*50];
    [signButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*70)];
    
}

- (void)loginButtonAction {
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    loginVC.navigationItem.title = @"登录";
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)signButtonAction {
    RegistViewController * signVC = [[RegistViewController alloc] init];
    signVC.navigationItem.title = @"注册";
    [self.navigationController pushViewController:signVC animated:YES];
}

- (void)quitAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
