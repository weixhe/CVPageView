//
//  TabPageListViewController.m
//  CVPageView
//
//  Created by caven on 2019/6/5.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "TabPageListViewController.h"
#import "TabPageErrorView.h"
#import "MJRefresh.h"

@interface TabPageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TabPageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self loadMoreData];
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear", self.identify);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     NSLog(@"%@ viewWillDisappear", self.identify);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.dataSource.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
#pragma mark - Request
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.dataSource removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        int number = arc4random() % 100;
        if (number < 10) {
            [TabPageErrorView showInView:self.view];
            [self.tableView reloadData];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        } else {
            for (int i = 0; i < 20; i ++) {
                [self.dataSource addObject:[NSString stringWithFormat:@"%@-%d", self.identify, i + 1]];
            }
            [self.tableView reloadData];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    });
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int pageFrom = (int)self.dataSource.count;
        for (int i = pageFrom; i < pageFrom + 20; i ++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"%@-%d", self.identify, i + 1]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = self.dataSource[(NSUInteger)indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
