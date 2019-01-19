//
//  PayMessageView.m
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "PayMessageView.h"
#import "UIView+Events.h"
#import "PureLayout.h"
#import "Connect.h"
#import "WelcomeViewController.h"
#import "TabBarViewController.h"
#import "User.h"
#import "RechargeViewController.h"
#import "WatchViewController.h"

@implementation PayMessageView

+ (instancetype)sharedPayMessageView {
    static PayMessageView *_payMessageView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _payMessageView = [[super allocWithZone:NULL] init];
        [_payMessageView setup];
    });
    return _payMessageView;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [PayMessageView sharedPayMessageView];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [PayMessageView sharedPayMessageView];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [PayMessageView sharedPayMessageView];
}

- (void)setup {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, SCREENH_HEIGHT);
    self.backgroundColor = UIColorWithRGBA(0, 0, 0, 0);
    __weak __typeof(self)weakSelf = self;
    [self addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
        [weakSelf back];
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = SCREEN_WIDTH/375*15;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    [whiteView autoCenterInSuperview];
    [whiteView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*275, SCREEN_WIDTH/375*175)];
    UILabel *buyLabel = [[UILabel alloc] init];
    buyLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
    buyLabel.textColor = UIColorWithRGBA(231, 76, 60, 1);
    buyLabel.textAlignment = NSTextAlignmentCenter;
    buyLabel.text = @"购买章节";
    [whiteView addSubview:buyLabel];
    [buyLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:SCREEN_WIDTH/375*10];
    [buyLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [whiteView addSubview:line];
    [line autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:buyLabel withOffset:SCREEN_WIDTH/375*5];
    [line autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH/375*1];
    
    self.sortLabel = [[UILabel alloc] init];
    _sortLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    _sortLabel.textColor = [UIColor blackColor];
    _sortLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:_sortLabel];
    [_sortLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:line withOffset:SCREEN_WIDTH/375*10];
    [_sortLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_sortLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:line];
    
    self.singePriceLabel = [[UILabel alloc] init];
    _singePriceLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    _singePriceLabel.textColor = [UIColor orangeColor];
    _singePriceLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:_singePriceLabel];
    [_singePriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_sortLabel withOffset:SCREEN_WIDTH/375*13];
    [_singePriceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_singePriceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:line];
    
    self.singeButton = [[UIButton alloc] init];
    _singeButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    _singeButton.layer.cornerRadius = SCREEN_WIDTH/375*5;
    _singeButton.layer.masksToBounds = YES;
    [_singeButton setTitle:@"购买单章" forState:UIControlStateNormal];
    _singeButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    [_singeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_singeButton addTarget:self action:@selector(buySingeChaper) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_singeButton];
    [_singeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:SCREEN_WIDTH/375*15];
    [_singeButton autoAlignAxis:ALAxisVertical toSameAxisOfView:_singePriceLabel];
    [_singeButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*40)];
    
    self.allLabel = [[UILabel alloc] init];
    _allLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    _allLabel.textColor = [UIColor blackColor];
    _allLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:_allLabel];
    [_allLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:line withOffset:SCREEN_WIDTH/375*10];
    [_allLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_allLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line];

    self.totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    _totalPriceLabel.textColor = [UIColor orangeColor];
    _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:_totalPriceLabel];
    [_totalPriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_allLabel withOffset:SCREEN_WIDTH/375*13];
    [_totalPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_totalPriceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:line];

    self.totalButton = [[UIButton alloc] init];
    _totalButton.hidden = YES;
    _totalButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    _totalButton.layer.cornerRadius = SCREEN_WIDTH/375*5;
    _totalButton.layer.masksToBounds = YES;
    [_totalButton setTitle:@"购买全部" forState:UIControlStateNormal];
    _totalButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    [_totalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_totalButton addTarget:self action:@selector(buyAllChapter) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_totalButton];
    [_totalButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_singeButton];
    [_totalButton autoAlignAxis:ALAxisVertical toSameAxisOfView:_totalPriceLabel];
    [_totalButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*40)];
}

- (void)getChapter {
    [[Connect sharedConnect] getChapterWithCarid:_caricature.carId sort:_chapter.sort success:^(NSDictionary * _Nonnull responseDic) {
        //NSDictionary *chapterDic = [responseDic objectForKey:@"chapter"];
        //Chapter *chapter = [[Chapter alloc] initWithDic:chapterDic];
        NSString * totalCount = [responseDic objectForKey:@"total_count"];
        NSString * totalPrice = [responseDic objectForKey:@"total_price"];
        self.allLabel.text = [NSString stringWithFormat:@"全部章节(%@)",totalCount];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%@点券",totalPrice];
        self.totalButton.hidden = NO;
        self.totalPrice = [totalPrice intValue];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showWithChapter:(Chapter *)chapter caricature:(nonnull Caricature *)caricature controller:(UIViewController *)controller{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
    } completion:^(BOOL finished) {
        self.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.5);
    }];
    self.chapter = chapter;
    self.caricature = caricature;
    self.controller = controller;
    [self getChapter];
    _sortLabel.text = [NSString stringWithFormat:@"第%d话",_chapter.sort];
    _singePriceLabel.text = [NSString stringWithFormat:@"%d点券",_chapter.price];
    [[Connect sharedConnect] loadUserWithSuccess:^(id  _Nullable responseObj) {
        User *user = [[User alloc] initWithDic:responseObj];
        [user save];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)back {
    self.backgroundColor = UIColorWithRGBA(0, 0, 0, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, SCREENH_HEIGHT);
    } completion:^(BOOL finished) {
        self.allLabel.text = @"";
        self.totalPriceLabel.text = @"";
        self.totalButton.hidden = YES;
        self.hidden = NO;
        self.singeButton.userInteractionEnabled = YES;
        self.totalButton.userInteractionEnabled = YES;
    }];
}

- (void)buySingeChaper {
    _singeButton.userInteractionEnabled = NO;
    _totalButton.userInteractionEnabled = NO;
    User *user = [User load];
    if (user == nil) {
        self.hidden = YES;
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        UINavigationController *welcomeNav = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
        TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
        if ([self.controller isKindOfClass:[WatchViewController class]]) {
            [self.controller dismissViewControllerAnimated:YES completion:^{
                [tabBarController presentViewController:welcomeNav animated:YES completion:^{
                    [self back];
                }];
            }];
        } else {
            [tabBarController presentViewController:welcomeNav animated:YES completion:^{
                [self back];
            }];
        }
    } else {
        if ([user.price intValue] < _chapter.price) {
            //跳转充值
            TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            if ([self.controller isKindOfClass:[WatchViewController class]]) {
                [self.controller dismissViewControllerAnimated:YES completion:^{
                    [tabBarController.viewControllers[0] pushViewController:rechargeVC animated:YES];
                }];
            } else {
                [tabBarController.viewControllers[0] pushViewController:rechargeVC animated:YES];
            }
            [self back];
        } else {
            [[Connect sharedConnect] payChapterWithChaid:_chapter.chaid success:^(id  _Nullable responseObj) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
                if (dict == nil) {
                    NSString * str  =[[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
                    [self messageWithString:str];
                } else {
                    User *user = [[User alloc] initWithDic:dict];
                    [user save];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINORPAY" object:nil];;
                    [self back];
                    if (![self.controller isKindOfClass:[WatchViewController class]]) {
                        WatchViewController * watchVC = [[WatchViewController alloc] init];
                        watchVC.sort = self.chapter.sort;
                        watchVC.caricature = self.caricature;
                        [self.controller presentViewController:watchVC animated:YES completion:^{
                            
                        }];
                    }
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
}

- (void)buyAllChapter {
    _singeButton.userInteractionEnabled = NO;
    _totalButton.userInteractionEnabled = NO;
    User *user = [User load];
    if (user == nil) {
        self.hidden = YES;
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        UINavigationController *welcomeNav = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
        TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
        if ([self.controller isKindOfClass:[WatchViewController class]]) {
            [self.controller dismissViewControllerAnimated:YES completion:^{
                [tabBarController presentViewController:welcomeNav animated:YES completion:^{
                    [self back];
                }];
            }];
        } else {
            [tabBarController presentViewController:welcomeNav animated:YES completion:^{
                [self back];
            }];
        }
    } else {
        if ([user.price intValue] < _totalPrice) {
            //跳转充值
            TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            if ([self.controller isKindOfClass:[WatchViewController class]]) {
                [self.controller dismissViewControllerAnimated:YES completion:^{
                    [tabBarController.viewControllers[0] pushViewController:rechargeVC animated:YES];
                }];
            } else {
                [tabBarController.viewControllers[0] pushViewController:rechargeVC animated:YES];
            }
            [self back];
        } else {
            [[Connect sharedConnect] payChaptersWithCarid:_caricature.carId success:^(id  _Nullable responseObj) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
                if (dict == nil) {
                    NSString * str  =[[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
                    [self messageWithString:str];
                } else {
                    User *user = [[User alloc] initWithDic:dict];
                    [user save];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINORPAY" object:nil];;
                    [self back];
                    if (![self.controller isKindOfClass:[WatchViewController class]]) {
                        WatchViewController * watchVC = [[WatchViewController alloc] init];
                        watchVC.sort = self.chapter.sort;
                        watchVC.caricature = self.caricature;
                        [self.controller presentViewController:watchVC animated:YES completion:^{
                            
                        }];
                    }
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }
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
    [self addSubview:messageView];
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
