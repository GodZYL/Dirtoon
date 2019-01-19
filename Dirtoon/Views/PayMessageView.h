//
//  PayMessageView.h
//  Dirtoon
//
//  Created by godloong on 2019/1/8.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chapter.h"
#import "Caricature.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayMessageView : UIView
+ (instancetype)sharedPayMessageView;

- (void)showWithChapter:(Chapter *)chapter caricature:(Caricature *)caricature controller:(UIViewController *)controller;

@property (strong, nonatomic) Chapter *chapter;

@property (strong, nonatomic) Caricature *caricature;

@property (assign, nonatomic) int totalPrice;

@property (strong, nonatomic) UILabel *sortLabel;

@property (strong, nonatomic) UILabel *allLabel;

@property (strong, nonatomic) UILabel *singePriceLabel;

@property (strong, nonatomic) UILabel *totalPriceLabel;

@property (strong, nonatomic) UIButton *totalButton;

@property (strong, nonatomic) UIButton *singeButton;

@property (assign, nonatomic) UIViewController *controller;

@end

NS_ASSUME_NONNULL_END
