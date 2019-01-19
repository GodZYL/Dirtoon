//
//  HomeViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/2.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "HomeViewController.h"
#import "PureLayout.h"
#import "Connect.h"
#import "Caricature.h"
#import "CaricatureCell.h"
#import "MJRefresh.h"
#import "CaricatureViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];
}

- (NSMutableArray *)caricatureArr {
    if (_caricatureArr == nil) {
        self.caricatureArr = [[NSMutableArray alloc] init];
    }
    return _caricatureArr;
}

- (void)createSubviews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CaricatureCell class] forCellWithReuseIdentifier:@"CaricatureCell"];
    [self.view addSubview:_collectionView];
    [_collectionView autoPinEdgesToSuperviewEdges];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadCaricatures)];
    
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置刷新控件
    self.collectionView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCaricatures)];
    
    // 设置文字
    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor blueColor];
    
    // 设置footer
    self.collectionView.mj_footer = footer;
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
}

- (void)reloadCaricatures {
    [[Connect sharedConnect] getCaricaturesWithlimit:20 offset:0 success:^(NSArray * _Nonnull responseArray) {
        [self.caricatureArr removeAllObjects];
        [self.caricatureArr addObjectsFromArray:[Caricature caricaturesWithArray:responseArray]];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        self.collectionView.mj_footer.hidden = NO;
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadMoreCaricatures {
    int offset = (int)_caricatureArr.count;
    [[Connect sharedConnect] getCaricaturesWithlimit:20 offset:offset success:^(NSArray * _Nonnull responseArray) {
        [self.caricatureArr addObjectsFromArray:[Caricature caricaturesWithArray:responseArray]];
        [self.collectionView reloadData];
        if (responseArray.count < 20) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CaricatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CaricatureCell" forIndexPath:indexPath];
    cell.caricature = [self.caricatureArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CaricatureViewController *carVC = [[CaricatureViewController alloc] init];
    carVC.caricature = [self.caricatureArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:carVC animated:YES];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caricatureArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-20-10)/2, (SCREEN_WIDTH-10-20)/2*1.4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

@end
