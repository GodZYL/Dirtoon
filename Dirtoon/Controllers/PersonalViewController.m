//
//  PersonalViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/9.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "PersonalViewController.h"
#import "PureLayout.h"
#import "PersonalCell.h"
#import "User.h"
#import "TabBarViewController.h"
#import "WelcomeViewController.h"
#import "RechargeViewController.h"
#import "Connect.h"
#import "XHChatQQ.h"

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINORPAY" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWithRGBA(244, 244, 244, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.sectionHeaderHeight = SCREEN_WIDTH/375*260;
    _tableView.sectionFooterHeight = SCREEN_WIDTH/375*150;
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgesToSuperviewEdges];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUser) name:@"LOGINORPAY" object:nil];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateUser) userInfo:nil repeats:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*230)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*230, SCREEN_WIDTH, SCREEN_WIDTH/375*30)];
    bottomView.backgroundColor = UIColorWithRGBA(244, 244, 244, 1);
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = UIColorWithRGBA(188, 188, 188, 1);
    [bottomView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*30, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = line1.backgroundColor;
    [bottomView addSubview:line2];
    [headerView addSubview:bottomView];
    headerView.backgroundColor = [UIColor whiteColor];
    self.faceImageView = [[UIImageView alloc] init];
    _faceImageView.layer.cornerRadius = SCREEN_WIDTH/375*50;
    _faceImageView.layer.masksToBounds = YES;
    [headerView addSubview:_faceImageView];
    [_faceImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*100)];
    [_faceImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_faceImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:SCREEN_WIDTH/375*25];
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*22];
    [headerView addSubview:_nameLabel];
    [_nameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_faceImageView withOffset:SCREEN_WIDTH/375*25];
    self.priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*18];
    _priceLabel.textColor = [UIColor orangeColor];
    [headerView addSubview:_priceLabel];
    [_priceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_priceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLabel withOffset:SCREEN_WIDTH/375*15];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*200)];
    self.logoutButton = [[UIButton alloc] init];
    _logoutButton.backgroundColor = UIColorWithRGBA(231, 76, 60, 1);
    _logoutButton.layer.cornerRadius = SCREEN_WIDTH/375*10;
    _logoutButton.layer.masksToBounds = YES;
    _logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*18];
    [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_logoutButton];
    [_logoutButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_logoutButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:SCREEN_WIDTH/375*10];
    [_logoutButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*50)];
    [self loadUser];
    return footerView;
}

- (void)logoutButtonAction {
    User *user = [User load];
    if (user == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        UINavigationController *welcomeNav = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
        TabBarViewController * tabBarController = [TabBarViewController sharedTabBarViewController];
        [tabBarController presentViewController:welcomeNav animated:YES completion:^{

        }];
        });
    } else {
        [user logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINORPAY" object:nil];;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/375*50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCell"];
    
    if (!cell) {
        cell = [[PersonalCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PersonalCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"充  值";
        cell.arrowImageView.hidden = NO;
        cell.BottomLineShort.hidden = YES;
        cell.BottomLineLong.hidden = NO;
    }
    if (indexPath.row == 1) {
        cell.titleLabel.text = @"安装VPN";
        cell.arrowImageView.hidden = NO;
        cell.BottomLineShort.hidden = YES;
        cell.BottomLineLong.hidden = NO;
    }
    if (indexPath.row == 2) {
        cell.titleLabel.text = @"联系客服";
        cell.arrowImageView.hidden = NO;
        cell.BottomLineShort.hidden = YES;
        cell.BottomLineLong.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([User load] == nil) {
            NSString *message = @"登录后才可以充值";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先登录" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            });
        } else {
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
    }
    if (indexPath.row == 1) {
        NSString *message = @"使用VPN可以明显提高图片加载速度,进入加速器按提示操作,选择香港或台湾节点(可以多试几个节点,选一个最快的)";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"强烈建议安装VPN" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://www.gxgnsm.com/manifest.plist"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不用了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        });
    }
    if (indexPath.row == 2) {
        if([XHChatQQ haveQQ])//是否有安装QQ客户端
        {
            
            //2.此处传入的QQ号,需开通QQ推广功能,不然"陌生人"无法向此QQ号发送临时消,(发送时会直接失败).
            //开通QQ推广方法:1.打开QQ推广网址http://shang.qq.com并用QQ登录  2.点击顶部导航栏:推广工具  3.在弹出菜单中点击'立即免费开通' 即可
            
            [XHChatQQ chatWithQQ:@"452550771"];//发起QQ临时会话
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备尚未安装QQ客户端,不能进行QQ临时会话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)updateUser {
    [[Connect sharedConnect] loadUserWithSuccess:^(id  _Nullable responseObj) {
        NSDictionary * dict = (NSDictionary *)responseObj;
        if (![dict.allKeys containsObject:@"message"]) {
            User *user = [[User alloc] initWithDic:responseObj];
            [user save];
        }
        [self loadUser];
    } failure:^(NSError * _Nonnull error) {
        [self loadUser];
        NSLog(@"%@",error);
    }];
}

- (void)loadUser {
    User *user = [User load];
    if (user != nil) {
        _faceImageView.image = [UIImage imageNamed:@"login"];
        _nameLabel.text = user.userName;
        _priceLabel.hidden = NO;
        _priceLabel.text = [NSString stringWithFormat:@"点券：%@",user.price];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    } else {
        _faceImageView.image = [UIImage imageNamed:@"not_login"];
        _nameLabel.text = @"未登录";
        _priceLabel.hidden = YES;
        [_logoutButton setTitle:@"登录" forState:UIControlStateNormal];
    }
}

@end
