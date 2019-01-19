//
//  ChapterCell.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChapterCell : UITableViewCell

@property (strong, nonatomic) UIImageView *coverView;

@property (strong, nonatomic) UILabel *sortLabel;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *buyButton;

@property (strong, nonatomic) Chapter *chapter;

@end

NS_ASSUME_NONNULL_END
