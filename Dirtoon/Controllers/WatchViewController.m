//
//  WatchViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "WatchViewController.h"
#import "PureLayout.h"
#import "Connect.h"
#import "Chapter.h"
#import "PayMessageView.h"

@interface WatchViewController ()<UIScrollViewDelegate>

@end

@implementation WatchViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createSubviews];
    [self getChapter];
    self.isDragging = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChapter) name:@"LOGINORPAY" object:nil];
}

- (void)createSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREENH_HEIGHT);
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = false;
    _scrollView.alwaysBounceHorizontal = false;
    [self.view addSubview:_scrollView];
    [_scrollView autoPinEdgesToSuperviewEdges];
    
    self.leftScrollView = [[WatchScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    [_scrollView addSubview:_leftScrollView];
    
    
    self.centerScrollView = [[WatchScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    [_scrollView addSubview:_centerScrollView];
    
    
    self.rightScrollView = [[WatchScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    [_scrollView addSubview:_rightScrollView];
    
    
    self.quitButton = [[QuitButton alloc] init];
    [_quitButton addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quitButton];
    [_quitButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_quitButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_quitButton autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50)];
}

- (void)getChapter {
    [self.centerScrollView removeAllImageviews];
    [[Connect sharedConnect] getChapterWithCarid:_caricature.carId sort:_sort success:^(NSDictionary * _Nonnull responseDic) {
        if ([responseDic.allKeys containsObject:@"chapter"]) {
            NSData* Data = [[responseDic objectForKey:@"chapter"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:nil];
            Chapter *chapter = [[Chapter alloc] initWithDic:dict];
            [self.centerScrollView removeAllImageviews];
            [[PayMessageView sharedPayMessageView] showWithChapter:chapter caricature:self.caricature controller:self];
        } else {
            Chapter *chapter = [[Chapter alloc] initWithDic:responseDic];
            self.centerScrollView.sort = self.sort;
            [self.centerScrollView loadImagesWithArray:chapter.pics];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_sort == 1 && scrollView.contentOffset.x < SCREEN_WIDTH) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
    if (_sort == _caricature.chapterCount && scrollView.contentOffset.x > SCREEN_WIDTH) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isDragging = NO;
    if (!decelerate) {
        [self handleScroll];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleScroll];
}

- (void)handleScroll {
    CGFloat offsetX = _scrollView.contentOffset.x;
    int index = (int)offsetX/SCREEN_WIDTH;
    if (index == 0 && (int)offsetX%(int)SCREEN_WIDTH == 0) {
        [_rightScrollView loadImagesWithArray:_centerScrollView.imageArray];
        _rightScrollView.sort = _sort;
        _sort--;
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        if (_leftScrollView.sort == _sort && _leftScrollView.imageArray.count > 0) {
            _centerScrollView.sort = _sort;
            [_centerScrollView loadImagesWithArray: _leftScrollView.imageArray];
        } else {
             [self getChapter];
        }
        [_leftScrollView removeAllImageviews];
    }
    if (index == 2 && (int)offsetX%(int)SCREEN_WIDTH == 0) {
        [_leftScrollView loadImagesWithArray:_centerScrollView.imageArray];
        _leftScrollView.sort = _sort;
        _sort++;
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        if (_rightScrollView.sort == _sort && _rightScrollView.imageArray.count > 0) {
            _centerScrollView.sort = _sort;
            [_centerScrollView loadImagesWithArray:_rightScrollView.imageArray];
        } else {
            [self getChapter];
        }
        [_rightScrollView removeAllImageviews];
    }
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

- (void)quitAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}
@end
