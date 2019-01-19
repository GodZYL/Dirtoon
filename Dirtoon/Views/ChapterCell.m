//
//  ChapterCell.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "ChapterCell.h"
#import "PureLayout.h"
#import "UIImageView+WebCache.h"

@implementation ChapterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = SCREEN_WIDTH/375*15;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    [whiteView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH/375*10];
    [whiteView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:SCREEN_WIDTH/375*10];
    [whiteView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [whiteView autoSetDimension:ALDimensionHeight toSize:SCREEN_WIDTH/375*70];
    
    self.coverView = [[UIImageView alloc] init];
    _coverView.layer.cornerRadius = SCREEN_WIDTH/375*15;
    _coverView.layer.masksToBounds = YES;
    [whiteView addSubview:_coverView];
    [_coverView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*60*2, SCREEN_WIDTH/375*60)];
    [_coverView autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    [_coverView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH/375*5];
    
    self.sortLabel = [[UILabel alloc] init];
    _sortLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
    _sortLabel.textColor = [UIColor blackColor];
    _sortLabel.textAlignment =NSTextAlignmentLeft;
    [whiteView addSubview:_sortLabel];
    [_sortLabel autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    [_sortLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_coverView withOffset:SCREEN_WIDTH/375*5];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:_titleLabel];
    [_titleLabel autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_sortLabel withOffset:SCREEN_WIDTH/375*2];
    
    self.buyButton = [[UIButton alloc] init];
    _buyButton.userInteractionEnabled = NO;
    _buyButton.layer.cornerRadius = SCREEN_WIDTH/375*15;
    _buyButton.layer.masksToBounds = YES;
    _buyButton.layer.borderColor = UIColorWithRGBA(43, 125, 188, 1).CGColor;
    _buyButton.layer.borderWidth = SCREEN_WIDTH/375*0;
    _buyButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    [whiteView addSubview:_buyButton];
    [_buyButton autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    [_buyButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:SCREEN_WIDTH/375*8];
    [_buyButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*60, SCREEN_WIDTH/375*30)];
}

- (void)resetSubviews {
    [self.coverView sd_setImageWithURL:_chapter.cover];
    [self.sortLabel setText:[NSString stringWithFormat:@"第%d话",_chapter.sort]];
    [self.titleLabel setText:_chapter.title];
    if (_chapter.price > 0) {
        if ([_chapter.payed isEqualToString:@"1"]) {
            [self.buyButton setTitle:@"已购买" forState:UIControlStateNormal];
            self.buyButton.backgroundColor = [UIColor whiteColor];
            self.buyButton.layer.borderWidth = SCREEN_WIDTH/375*2;
            [self.buyButton setTitleColor:UIColorWithRGBA(43, 125, 188, 1) forState:UIControlStateNormal];
        } else {
            [self.buyButton setTitle:[NSString stringWithFormat:@"%d点券",_chapter.price] forState:UIControlStateNormal];
            self.buyButton.backgroundColor = UIColorWithRGBA(206, 54, 53, 1);
            self.buyButton.layer.borderWidth = SCREEN_WIDTH/375*0;
            [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    } else {
        //免费
        [self.buyButton setTitle:@"免费" forState:UIControlStateNormal];
        self.buyButton.backgroundColor = UIColorWithRGBA(22, 160, 93, 1);
        self.buyButton.layer.borderWidth = SCREEN_WIDTH/375*0;
        [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setChapter:(Chapter *)chapter {
    _chapter = chapter;
    [self resetSubviews];
}

@end
