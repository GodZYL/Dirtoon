//
//  CaricatureCell.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Caricature.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaricatureCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *coverView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UILabel *gradeLabel;

@property (strong, nonatomic) Caricature *caricature;

@end

NS_ASSUME_NONNULL_END
