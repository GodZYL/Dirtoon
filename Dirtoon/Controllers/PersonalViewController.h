//
//  PersonalViewController.h
//  Dirtoon
//
//  Created by godloong on 2019/1/9.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *faceImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UIButton *logoutButton;

@end

NS_ASSUME_NONNULL_END
