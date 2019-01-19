//
//  LoginViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "LoginViewController.h"
#import "PureLayout.h"
#import "Connect.h"
#import "User.h"
#import "UIView+Events.h"
#import <AdSupport/AdSupport.h>

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.usernameField = [[LoginRegistField alloc] init];
    _usernameField.delegate = self;
    _usernameField.leftLabel.text = @" 用户名";
    _usernameField.placeholder = @"请输入用户名";
    [self.view addSubview:_usernameField];
    [_usernameField autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [_usernameField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_usernameField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-SCREEN_WIDTH/375*80];
    
    self.passwordField = [[LoginRegistField alloc] init];
    _passwordField.delegate = self;
    _passwordField.leftLabel.text = @" 密    码";
    _passwordField.placeholder = @"请输入密码";
    _passwordField.secureTextEntry = YES;
    [self.view addSubview:_passwordField];
    [_passwordField autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [_passwordField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_passwordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_usernameField withOffset:SCREEN_WIDTH/375*20];
    
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    loginButton.layer.cornerRadius = SCREEN_WIDTH/375*15;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*20];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [loginButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:SCREEN_WIDTH/375*20];
    
    __weak __typeof(self)weakSelf = self;
    [self.view addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
        [weakSelf.usernameField resignFirstResponder];
        [weakSelf.passwordField resignFirstResponder];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    return YES;
}

- (void)login {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[Connect sharedConnect] loginWithUsername:_usernameField.text password:_passwordField.text udid:adId success:^(id  _Nullable responseObj) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        if (dict == nil) {
            NSString * str  =[[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
            [self messageWithString:str];
        } else if([dict.allKeys containsObject:@"message"]) {
            NSString *message = @"账号只能在注册时的设备上登录；刷机、还原、更新系统等操作导致无法登录请联系客服。";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"账号与设备不符" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            });
        } else {
            User *user = [[User alloc] initWithDic:dict];
            [user save];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINORPAY" object:nil];;
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)messageWithString:(NSString *)string {
    UILabel *messageView = [[UILabel alloc] init];
    messageView.layer.cornerRadius = SCREEN_WIDTH/375*8;
    messageView.layer.masksToBounds = YES;
    messageView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.5);
    messageView.alpha = 0;
    messageView.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    messageView.textColor = [UIColor whiteColor];
    messageView.textAlignment = NSTextAlignmentCenter;
    messageView.text = string;
    [self.view addSubview:messageView];
    [messageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*40)];
    [messageView autoCenterInSuperview];
    [UIView animateWithDuration:1 animations:^{
        messageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            messageView.alpha = 0;
        } completion:^(BOOL finished) {
            [messageView removeFromSuperview];
        }];
    }];
    
}

@end
