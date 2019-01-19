//
//  CaricatureViewController.m
//  Dirtoon
//
//  Created by godloong on 2019/1/7.
//  Copyright © 2019 godloong. All rights reserved.
//

#import "CaricatureViewController.h"
#import "PureLayout.h"
#import "ChapterCell.h"
#import "Connect.h"
#import "Chapter.h"
#import "WatchViewController.h"
#import "PayMessageView.h"

@interface CaricatureViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CaricatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = _caricature.name;
    [self createSubviews];
    [self loadChapters];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadChapters) name:@"LOGINORPAY" object:nil];
}

- (void)createSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.sectionHeaderHeight = SCREEN_WIDTH/375*12;
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgesToSuperviewEdges];
}

- (NSMutableArray *)chapterArr {
    if (_chapterArr == nil) {
        self.chapterArr = [[NSMutableArray alloc] init];
    }
    return _chapterArr;
}

- (void)loadChapters {
    [[Connect sharedConnect] getChaptersWithCarid:_caricature.carId success:^(NSArray * _Nonnull responseArray) {
        [self.chapterArr removeAllObjects];
        [self.chapterArr addObjectsFromArray:[Chapter chaptersWithArray:responseArray]];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [[UIView alloc] initWithFrame:CGRectZero];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/375*90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChapterCell"];
    
    if (!cell) {
        cell = [[ChapterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChapterCell"];
    }
    cell.chapter = [self.chapterArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        Chapter *chapter = [self.chapterArr objectAtIndex:indexPath.row];
        if (chapter.price > 0 && [chapter.payed isEqualToString:@"0"]) {
            [[PayMessageView sharedPayMessageView] showWithChapter:chapter caricature:self.caricature controller:self];
        } else {
            WatchViewController * watchVC = [[WatchViewController alloc] init];
            watchVC.sort = (int)indexPath.row+1;
            watchVC.caricature = self.caricature;
            [self presentViewController:watchVC animated:YES completion:^{
                
            }];
        }
    });
}


@end
