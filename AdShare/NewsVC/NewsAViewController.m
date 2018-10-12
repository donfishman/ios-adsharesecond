//
//  NewsAViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "NewsAViewController.h"

@interface NewsAViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSMutableArray    * dataSoure;
@property (strong, nonatomic) UIView *editingView;
@property (strong, nonatomic) NSMutableArray *deleteArr;


@end

@implementation NewsAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadNewsData:@"1"];
    [self tableView];
    [self layoutSubviews];
}


-(void)setTypeStr:(NSString *)typeStr{

    if ([typeStr isEqualToString:@"1"]) {
        if (self.dataSoure.count == 0) {
            return;
        }
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 158 - 45);
        [_tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
    } else if ([typeStr isEqualToString:@"2"]) {
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 158);
        [_tableView setEditing:NO animated:YES];
        [self showEitingView:NO];
    }
    [self.tableView reloadData];
   
    
}


- (void)showEitingView:(BOOL)isShow {
    [UIView animateWithDuration:0.3 animations:^{
        self.editingView.frame = CGRectMake(0, isShow ? KScreenHeight - 158 - 45: KScreenHeight, KScreenWidth, 45);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(whiteColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNavItem" object:@"1"];
    [self loadNewsData:@"1"];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
//    //删除
//    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
////        [self.titleArr removeObjectAtIndex:indexPath.row];
//        completionHandler (YES);
//        [self.tableView reloadData];
//    }];
//    deleteRowAction.image = [UIImage imageNamed:@"删除"];
//    deleteRowAction.backgroundColor = [UIColor redColor];
//
//    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
//    return config;
//}

- (UIView *)editingView {
    if (!_editingView) {
        _editingView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 109, KScreenWidth, 45)];
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

- (void)layoutSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editingView];
}

- (void)loadNewsData:(NSString * )typeStr {
    WS(weakSelf);
    self.deleteArr = [NSMutableArray array];
    self.dataSoure = [NSMutableArray array];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:UserDefaults(@"uid"),@"uid",typeStr,@"type", nil];
    [self.dataSoure removeAllObjects];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSArray *array = response[@"content"];
        if (array.count >0) {
            for (NSDictionary * dict in array) {
                NewsModel * model = [NewsModel new];
                if ([dict[@"status"] isEqual:[NSNull null]]) {
                    model.status = @"9";
                }else {
                    model.status = dict[@"status"];
                }
                model.create_time = dict[@"create_time"];
                model.type = dict[@"type"];
                model.content = dict[@"content"];
                model.title = dict[@"title"];
                model.rid = dict[@"rid"];
                model.uid = dict[@"uid"];
                model.rrid = dict[@"rrid"];
                model.rwId = dict[@"id"];
                NSLog(@"modellll   ***   %@",model);
                [self.dataSoure addObject:model];
            }
        }
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [EmptyStateView customEmptyViewType:weakSelf.dataSoure.count ? -1 : 1
                                  withSuperView:weakSelf.tableView
                               withButtonAction:nil
                           withBackgroundAction:nil];
        });
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Task/smslist" withParameters:dict];
}


- (UITableView *)tableView {
    if (!_tableView) {
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 158)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        //        _tableView.editing = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.layoutMargins  = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = KColor(223, 223, 223);
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellA"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



- (void)p__buttonClick:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
            NewsModel * model = [NewsModel new];
            model = self.dataSoure[obj.row];
            [self.deleteArr addObject:model.rwId];
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSString *string = [self.deleteArr componentsJoinedByString:@","];
            NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/smslistdelete/id/%@",string];
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
                [self.deleteArr removeAllObjects];
            } failure:^(NSError *error) {
            } withUrl:str];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self.dataSoure removeObjectsAtIndexes:insets];
                [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
            });
        });
        if (self.dataSoure.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"删除";
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
        }
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.dataSoure enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//    }
//    //从数据源中删除
//    [_dataSoure removeObjectAtIndex:indexPath.row];
//    // 从列表中删除
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
//}


#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

#pragma mark - cell点击执行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return;
    }
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    NewsModel * model = self.dataSoure[index.row];
    PersonalCenterController * buyVC = [PersonalCenterController new];
    NSInteger rridInt = model.rrid.integerValue;
    MoneyDetailViewController * newVC = [MoneyDetailViewController new];
    if (rridInt == 0) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"newsPushDeatil" object:buyVC];
        [buyVC loadDataWithTaskID:model.rid];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:buyVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)cellButtonTouchDownAction:(id)sender event:(id)event {
    //获取触摸点的集合，可以判断多点触摸事件
    NSSet *touches=[event allTouches];
    //两句话是保存触摸起点位置
    UITouch *touch = [touches anyObject];
    CGPoint cureentTouchPosition = [touch locationInView:self.tableView];
    //得到cell中的IndexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cureentTouchPosition];
    NSLog(@"section----%li,----row---%li",(long)indexPath.section,(long)indexPath.row);
    NewsModel * model = self.dataSoure[indexPath.row];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:model.rid,@"rid",model.rrid,@"rrid", nil];
    [self pushMoneyWithDict:dict];
}

- (void)pushMoneyWithDict:(NSDictionary *)model {
    NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php?g=ApiHome&m=Sowing&a=index&uid=%@&rid=%@&rrid=%@",UserDefaults(@"uid"),model[@"rid"],model[@"rrid"]];
    WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"newsPushDeatil" object:wkWebVC];
    [wkWebVC loadUrlWithString:str];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wkWebVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

#pragma mark cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellA";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataSoure.count > 0) {
        NewsModel * model = self.dataSoure[indexPath.row];
        cell.titleLabel.text = model.title;
        cell.subTitleLabel.text = model.content;
        cell.timeLabel.text = [YANDTools timeStampWithTimeStr:model.create_time];
        if (![model.status isEqual:[NSNull null]]) {
            NSInteger statusInt = model.status.integerValue;
            NSLog(@"%ld +-*/ %@",statusInt,model.status);
            if (statusInt == 3) {
                cell.linkBtn.hidden = NO;
            } else {
                cell.linkBtn.hidden = YES;
            }
        }
    }
    
    [cell.linkBtn addTarget:self action:@selector(cellButtonTouchDownAction:event:) forControlEvents:UIControlEventTouchDown];
    cell.backgroundColor = CColor(whiteColor);
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
