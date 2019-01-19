//
//  QuitButton.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "QuitButton.h"
#import "PureLayout.h"

@implementation QuitButton

- (instancetype)init {
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"quit_button"];
        [self addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:SCREEN_WIDTH/375*0];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:SCREEN_WIDTH/375*0];
        [imageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*30, SCREEN_WIDTH/375*30)];
    }
    return self;
}

@end
