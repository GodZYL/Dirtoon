//
//  CaricatureCell.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "CaricatureCell.h"
#import "PureLayout.h"
#import "UIImageView+WebCache.h"

@implementation CaricatureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.coverView = [[UIImageView alloc] init];
    [self addSubview:_coverView];
    [_coverView autoPinEdgesToSuperviewEdges];
    
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [self addSubview:blackView];
    [blackView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [blackView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_coverView];
    [blackView autoSetDimension:ALDimensionHeight toSize:(SCREEN_WIDTH-10-20)/2*1.4/4];
    
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_nameLabel];
    [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH/375*5];
    [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:blackView withOffset:SCREEN_WIDTH/375*9];
    
    self.countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_countLabel];
    [_countLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_nameLabel];
    [_countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_nameLabel];
    [_countLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:blackView withOffset:-SCREEN_WIDTH/375*9];
    
    self.gradeLabel = [[UILabel alloc] init];
    _gradeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*15];
    _gradeLabel.textColor = [UIColor whiteColor];
    _gradeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_gradeLabel];
    [_gradeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:blackView withOffset:-SCREEN_WIDTH/375*5];
    [_gradeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:blackView withOffset:-SCREEN_WIDTH/375*9];
    
    UILabel *starLabel = [[UILabel alloc] init];
    starLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*15];
    starLabel.textColor = [UIColor redColor];
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.text = @"★";
    [self addSubview:starLabel];
    [starLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_gradeLabel withOffset:-SCREEN_WIDTH/375*2];
    [starLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_gradeLabel];
    
}

- (void)resetSubviews {
    [self.coverView sd_setImageWithURL:_caricature.cover];
    [self.nameLabel setText:_caricature.name];
    if ([_caricature.end isEqualToString:@"0"]) {
        [self.countLabel setText:[NSString stringWithFormat:@"更新至第%d话",_caricature.chapterCount]];
    } else {
        [self.countLabel setText:[NSString stringWithFormat:@"共%d话（已完结）",_caricature.chapterCount]];
    }
    [self.gradeLabel setText:_caricature.star];
}

- (void)setCaricature:(Caricature *)caricature {
    _caricature = caricature;
    [self resetSubviews];
}

@end
