//
//  CollectionViewController.m
//  CityTong
//
//  Created by 闫晓东 on 2018/2/4.
//  Copyright © 2018年 闫晓东. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) UIView *editingView;
@property (strong, nonatomic) NSMutableArray *deleteArr;


@end

@implementation CollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [deleteBtn setTintColor:CColor(whiteColor)];
    [deleteBtn addTarget:self action:@selector(rightBarItemClick:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    rightItem.tintColor = TintColor;
    self.navigationItem.rightBarButtonItem = rightItem;
    [self loadData];
    [self layoutSubviews];
}

- (void)loadData {
    WS(weakSelf);

    self.listData = [NSMutableArray array];
    self.deleteArr = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/mycollect/uid/%@",UserDefaults(@"uid")];
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        NSArray * array = response[@"content"];
        for (NSDictionary * dict in array) {
            TaskModel * model = [TaskModel new];
            model.idA = dict[@"id"];
            model.ctoDid = dict[@"rid"];
            model.name = dict[@"name"];
            model.thumbnail = dict[@"thumbnail"];
            model.min_price = dict[@"min_price"];
            model.max_price = dict[@"max_price"];
            model.label = dict[@"label"];
            [self.listData addObject:model];
        }
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [EmptyStateView customEmptyViewType:weakSelf.listData.count ? -1 : 1
                                  withSuperView:weakSelf.tableView
                               withButtonAction:nil
                           withBackgroundAction:nil];
        });
        
    } failure:^(NSError *error) {
    } withUrl:url];
}

- (void)layoutSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editingView];
}
//- (void)leftBarItemClick:(UIBarButtonItem *)item
//{
//    [self loadData];
//    [self.tableView reloadData];
//}

- (void)rightBarItemClick:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        if (self.listData.count == 0) {
            return;
        }
        item.title = @"取消";
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 45);
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
    }else{
        item.title = @"编辑";
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self.tableView setEditing:NO animated:YES];
        [self showEitingView:NO];
    }
}

- (void)p__buttonClick:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
            TaskModel * model = [TaskModel new];
            model = self.listData[obj.row];
            [self.deleteArr addObject:model.idA];
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSString *string = [self.deleteArr componentsJoinedByString:@","];
            NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/cancelcollection/id/%@",string];
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
                [self.deleteArr removeAllObjects];
            } failure:^(NSError *error) {
            } withUrl:str];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self.listData removeObjectsAtIndexes:insets];
                [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
                
            });
        });
        if (self.listData.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
        }
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:obj animated:YES];
        }];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}


- (void)showEitingView:(BOOL)isShow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.editingView.frame = CGRectMake(0, isShow ? KScreenHeight - 45 : KScreenHeight, KScreenWidth, 45);
    }];
}

#pragma mark -- UITabelViewDelegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CollectionTableViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TaskModel * model = self.listData[indexPath.row];
    cell.titleLabel.text = model.name;
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    NSString * str = [NSString stringWithFormat:@"￥%@-%@",model.min_price,model.max_price];
    NSString * strA = [str stringByReplacingOccurrencesOfString:@".00"withString:@""];
    cell.moneyLabel.text = strA;
    
    if (model.label.count == 1) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.hidden = YES;
        cell.tagLabelC.hidden = YES;
    }
    else if (model.label.count == 2) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.hidden = YES;
    }
    else if (model.label.count == 3) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    else if (model.label.count > 3) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    cell.backgroundColor = CColor(whiteColor);
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return;
    }
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    TaskModel * model = self.listData[index.row];
    PersonalCenterController * buyVC = [PersonalCenterController new];
    [buyVC loadDataWithTaskID:model.ctoDid];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark -- lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectionTableViewCell"];
    }
    return _tableView;
}

- (UIView *)editingView
{
    if (!_editingView) {
        _editingView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 45)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = NavColor;
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:CColor(whiteColor) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(KScreenWidth *0.4, 0, KScreenWidth *0.6, 45);
        [_editingView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = CColor(whiteColor);
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:NavColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, KScreenWidth *0.4, 45);
        [_editingView addSubview:button];
    }
    return _editingView;
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
