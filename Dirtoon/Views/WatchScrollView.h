//
//  WatchScrollView.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchScrollView : UIScrollView

- (void)loadImagesWithArray:(NSArray *)imageArray;

- (void)removeAllImageviews;

@property (assign, nonatomic) int sort;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end

NS_ASSUME_NONNULL_END
