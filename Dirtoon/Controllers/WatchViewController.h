//
//  WatchViewController.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuitButton.h"
#import "WatchScrollView.h"
#import "Caricature.h"
NS_ASSUME_NONNULL_BEGIN

@interface WatchViewController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) WatchScrollView *leftScrollView;

@property (strong, nonatomic) WatchScrollView *centerScrollView;

@property (strong, nonatomic) WatchScrollView *rightScrollView;

@property (strong, nonatomic) QuitButton *quitButton;

@property (assign, nonatomic) BOOL statusBarHidden;

@property (assign, nonatomic) int sort;

@property (strong, nonatomic) Caricature *caricature;

@property (assign, nonatomic) BOOL isDragging;

@end

NS_ASSUME_NONNULL_END
