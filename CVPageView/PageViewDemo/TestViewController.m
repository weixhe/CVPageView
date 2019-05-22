//
//  TestViewController.m
//  Test
//
//  Created by caven on 2019/5/17.
//  Copyright © 2019 com.caven. All rights reserved.
//

#import "TestViewController.h"
#import "MJRefresh.h"

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *colors ;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.colors = @[[UIColor colorWithRed:252/255.0 green:235/255.0 blue:235/255.0 alpha:1],
                        [UIColor colorWithRed:247/255.0 green:233/255.0 blue:241/255.0 alpha:1],
                        [UIColor colorWithRed:236/255.0 green:232/255.0 blue:242/255.0 alpha:1],
                        [UIColor colorWithRed:249/255.0 green:237/255.0 blue:232/255.0 alpha:1],
                        [UIColor colorWithRed:249/255.0 green:238/255.0 blue:220/255.0 alpha:1],
                        [UIColor colorWithRed:239/255.0 green:243/255.0 blue:222/255.0 alpha:1],
                        [UIColor colorWithRed:228/255.0 green:244/255.0 blue:246/255.0 alpha:1],
                        [UIColor colorWithRed:232/255.0 green:237/255.0 blue:237/255.0 alpha:1]];
    
    
    self.textLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont boldSystemFontOfSize:50];
    self.textLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.textLabel];
    self.textLabel.text = self.text;
    self.textLabel.backgroundColor = self.colors[self.text.integerValue];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataSource removeAllObjects];
            for (int i = 0; i < 10; i ++) {
                [self.dataSource addObject:[NSString stringWithFormat:@"%@-%d", self.text, i + 1]];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int pageFrom = (int)self.dataSource.count;
            for (int i = pageFrom; i < pageFrom + 10; i ++) {
                [self.dataSource addObject:[NSString stringWithFormat:@"%@-%d", self.text, i + 1]];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ will appear", self.text);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@ did appear", self.text);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ will disappear", self.text);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ did disappear", self.text);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)setText:(NSString *)text {
    _text = text;
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
