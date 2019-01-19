//
//  HomeViewController.h
//  Dirtoon
//
//  Created by godloong on 2019/1/2.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *caricatureArr;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
