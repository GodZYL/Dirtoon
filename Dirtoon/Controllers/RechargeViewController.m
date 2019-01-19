//
//  RechargeViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/10.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "RechargeViewController.h"
#import <WebKit/WebKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Connect.h"
#import "User.h"
#import "PureLayout.h"
#import "LoginRegistField.h"

@interface RechargeViewController ()<WKNavigationDelegate,UIWebViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (assign, nonatomic) int loadtime;

@property (strong, nonatomic) LoginRegistField *rechargeField;

@property (strong, nonatomic) UIButton *rechargeButton;

@property (strong, nonatomic) UIView *messageView;

@end

@implementation RechargeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINORPAY" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    [self loadWithUrlStr:[Connect sharedConnect].rechargeURL];
    
    self.loadtime = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.rechargeField = [[LoginRegistField alloc] init];
    _rechargeField.delegate = self;
    _rechargeField.leftLabel.text = @" 金    额";
    _rechargeField.placeholder = @"请输入充值金额";
    _rechargeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_rechargeField];
    [_rechargeField autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [_rechargeField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_rechargeField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-SCREEN_WIDTH/375*80];
    
    self.rechargeButton = [[UIButton alloc] init];
    _rechargeButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    _rechargeButton.layer.cornerRadius = SCREEN_WIDTH/375*15;
    _rechargeButton.layer.masksToBounds = YES;
    _rechargeButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*20];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rechargeButton setTitle:@"提交" forState:UIControlStateNormal];
    [_rechargeButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rechargeButton];
    [_rechargeButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*50)];
    [_rechargeButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_rechargeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_rechargeField withOffset:SCREEN_WIDTH/375*20];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"充值提示：自助充值目前仅支持支付宝，没有支付宝的用户可以联系客服充值。";
    label.numberOfLines = 0;
    [self.view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_rechargeField withOffset:-SCREEN_WIDTH/375*50];
    [label autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_rechargeButton];
    
    self.messageView = [[UIView alloc] init];
    _messageView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.7);
    _messageView.layer.cornerRadius = SCREEN_WIDTH/375*10;
    _messageView.layer.masksToBounds = YES;
    _messageView.hidden = YES;
    [self.view addSubview:_messageView];
    [_messageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*180, SCREEN_WIDTH/375*70)];
    [_messageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_messageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-SCREEN_WIDTH/375*50];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*26];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = @"正在提交";
    [_messageView addSubview:messageLabel];
    [messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [messageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH/375*15];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [_messageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [activityIndicator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:SCREEN_WIDTH/375*15];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self recharge];
    return YES;
}

- (void)recharge {
    if ([self.rechargeField.text isEqualToString:@""] || [self.rechargeField.text floatValue] <= 0) {
        NSString *message = @"请输入充值金额!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"金额错误" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        });
        return;
    }
    self.messageView.hidden = NO;
    BOOL finished = NO;
    while (!finished) {
        NSLog(@"loadtime == %d",self.loadtime);
        if (self.loadtime >= 1) {
            NSMutableString *str = [NSMutableString string];
            [str appendString:@"function od(){document.wappayselling.action = \"/pay/Paydeal\";document.wappayselling.submit();return true;};"];
            [str appendString:[NSString stringWithFormat:@"$('#CardNoMoney1').val('%d');",[self.rechargeField.text intValue]]];
            [str appendString:@"document.getElementById('bin').onclick = function(){od(); };"];
            [str appendString:@"document.getElementById('bin').onclick();"];
            [self.webView stringByEvaluatingJavaScriptFromString:str];
            finished = YES;
        }
    }
}

#pragma mark -
#pragma mark   ============== webview相关 回调及加载 ==============

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSMutableString *str = [NSMutableString string];
    if (self.loadtime == 0) {
        [str appendString:@"var weixin = document.getElementsByClassName(\"weixinwappay\")[0];"];
        [str appendString:@"weixin.parentNode.removeChild(weixin);"];
        [str appendString:@"var zfbli = document.getElementsByClassName(\"alipaywappay\")[0];"];
        [str appendString:@"zfbli.click();"];
        User *user = [User load];
        [str appendString:[NSString stringWithFormat:@"$('#UName').val('%@');",user.userName]];
        [str appendString:[NSString stringWithFormat:@"$('#UName1').val('%@');",user.userName]];
        [str appendString:@"$('#bin').submit();"];
        [webView stringByEvaluatingJavaScriptFromString:str];
        
        
        
//        NSString *message = @"1.点击弹出框的确认按钮,进入下个页面;\n2.输入账号(区分大小写),付款方式选择微信或支付宝;\n3.将二维码截屏保存到相册,再将二维码发送到电脑或其他设备;\n4.用微信/支付宝扫描二维码付款(不支持相册扫码,必须发送到其他设备,再使用相机扫码);\n5.实在不会可以联系客服人工充值.";
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"充值说明(必看)" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
//        UIView *subView1 = alertController.view.subviews[0];
//        UIView *subView2 = subView1.subviews[0];
//        UIView *subView3 = subView2.subviews[0];
//        UIView *subView4 = subView3.subviews[0];
//        UIView *subView5 = subView4.subviews[0];
//        NSLog(@"%@",subView5.subviews);
//        //取title和message：
//        for (UILabel *messageLabel in subView5.subviews) {
//            if ([messageLabel isKindOfClass:[UILabel class]] && [messageLabel.text isEqualToString:message]) {
//                messageLabel.textAlignment = NSTextAlignmentLeft;
//                break;
//            }
//        }
//
//        [alertController addAction:okAction];           // A
//        [self presentViewController:alertController animated:YES completion:^{
//
//        }];
    } else if (self.loadtime == 1) {
        
    } else if (self.loadtime >= 4){
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.loadtime++;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
    if (orderInfo.length > 0) {
        [self payWithUrlOrder:orderInfo];
        return NO;
    }
    return YES;
}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}


#pragma mark -
#pragma mark   ============== URL pay 开始支付 ==============

- (void)payWithUrlOrder:(NSString*)urlOrder
{
    if (urlOrder.length > 0) {
        __weak RechargeViewController* wself = self;
        [[AlipaySDK defaultService]payUrlOrder:urlOrder fromScheme:@"alisdkdemo" callback:^(NSDictionary* result) {
            // 处理支付结果
            NSLog(@"%@", result);
            // isProcessUrlPay 代表 支付宝已经处理该URL
            if ([result[@"isProcessUrlPay"] boolValue]) {
                // returnUrl 代表 第三方App需要跳转的成功页URL
                NSString* urlStr = result[@"returnUrl"];
                [wself loadWithUrlStr:urlStr];
            }
        }];
    }
}


@end
