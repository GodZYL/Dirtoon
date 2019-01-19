//
//  PersonalCell.m
//  Dirtoon
//
//  Created by godloong on 2019/1/9.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "PersonalCell.h"
#import "PureLayout.h"

@implementation PersonalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [whiteView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [whiteView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [whiteView autoSetDimension:ALDimensionHeight toSize:SCREEN_WIDTH/375*50];
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:_titleLabel];
        [_titleLabel autoPinEdgesToSuperviewEdges];

        self.arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.hidden = YES;
        _arrowImageView.image = [UIImage imageNamed:@"personal_arrow"];
        [whiteView addSubview:_arrowImageView];
        [_arrowImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*9, SCREEN_WIDTH/375*15)];
        [_arrowImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_arrowImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:SCREEN_WIDTH/375*12];
        
        self.BottomLineShort = [[UIView alloc] init];
        _BottomLineShort.hidden = YES;
        _BottomLineShort.backgroundColor = UIColorWithRGBA(188, 188, 188, 1);
        [whiteView addSubview:_BottomLineShort];
        [_BottomLineShort autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*300, 0.5)];
        [_BottomLineShort autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_BottomLineShort autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        self.BottomLineLong = [[UIView alloc] init];
        _BottomLineLong.hidden = YES;
        _BottomLineLong.backgroundColor = UIColorWithRGBA(188, 188, 188, 1);
        [whiteView addSubview:_BottomLineLong];
        [_BottomLineLong autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 0.5)];
        [_BottomLineLong autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_BottomLineLong autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    return self;
}

@end
