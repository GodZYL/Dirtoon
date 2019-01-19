//
//  SignViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "RegistViewController.h"
#import "PureLayout.h"
#import "Connect.h"
#import "User.h"
#import "UIView+Events.h"
#import <AdSupport/AdSupport.h>

@interface RegistViewController ()<UITextFieldDelegate>

@end

@implementation RegistViewController

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
    
    self.QQField = [[LoginRegistField alloc] init];
    _QQField.delegate = self;
    _QQField.leftLabel.text = @"  Q     Q";
    _QQField.placeholder = @"找回密码唯一凭证";
    [self.view addSubview:_QQField];
    [_QQField autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [_QQField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_QQField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:SCREEN_WIDTH/375*20];
    
    UIButton *registButton = [[UIButton alloc] init];
    registButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    registButton.layer.cornerRadius = SCREEN_WIDTH/375*15;
    registButton.layer.masksToBounds = YES;
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*20];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registButton];
    [registButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [registButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [registButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_QQField withOffset:SCREEN_WIDTH/375*20];
    
    __weak __typeof(self)weakSelf = self;
    [self.view addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
        [weakSelf.usernameField resignFirstResponder];
        [weakSelf.passwordField resignFirstResponder];
        [weakSelf.QQField resignFirstResponder];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self regist];
    return YES;
}

- (void)regist {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[Connect sharedConnect] registWithUsername:_usernameField.text password:_passwordField.text udid:adId qq:_QQField.text success:^(id  _Nullable responseObj) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        if (dict == nil) {
            NSString * str  =[[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
            [self messageWithString:str];
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
