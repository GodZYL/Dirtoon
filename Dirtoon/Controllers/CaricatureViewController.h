//
//  CaricatureViewController.h
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Caricature.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaricatureViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *chapterArr;

@property (strong, nonatomic) Caricature *caricature;

@end

NS_ASSUME_NONNULL_END
