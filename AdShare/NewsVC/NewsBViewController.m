//
//  NewsBViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "NewsBViewController.h"

@interface NewsBViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSMutableArray    * dataSoure;


@end

@implementation NewsBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
    self.dataSoure = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = NavColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(whiteColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [self loadNewsData:@"2"];
}

- (void)loadNewsData:(NSString * )typeStr {
    WS(weakSelf);
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:UserDefaults(@"uid"),@"uid", nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSArray *array = response[@"content"];
        if (array.count >0) {
            [self.dataSoure removeAllObjects];
            for (NSDictionary * dict in array) {
                NewsModel * model = [NewsModel new];
                model.create_time = dict[@"create_time"];
                model.content = dict[@"content"];
                model.rwId = dict[@"id"];
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
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Sowing/smsselect" withParameters:dict];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 158)];
        self.tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.layoutMargins  = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = KColor(223, 223, 223);

        [self.view addSubview:self.tableView];
        UIView *superView = self.view;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(superView.mas_left);
            make.right.mas_equalTo(superView.mas_right);
            make.top.mas_equalTo(superView.mas_top);
//            make.bottom.mas_equalTo(superView.mas_bottom).offset(0);
            make.height.mas_offset([UIScreen mainScreen].bounds.size.height - 158);
        }];
        [self.tableView registerClass:[NewsBTableVCell class] forCellReuseIdentifier:@"NewsBTableVCellID"];
        

        
        
    }
    return _tableView;
}

#pragma mark cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewsBTableVCellID";
    NewsBTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:nil].firstObject;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.dataSoure[indexPath.row]];
    cell.backgroundColor = CColor(whiteColor);
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //     从数据源中删除
    [_dataSoure removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}


#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //使用这个框架需要这个。
    return [tableView fd_heightForCellWithIdentifier:@"NewsBTableVCellID" cacheByIndexPath:indexPath configuration:^(NewsBTableVCell *cell) {
        cell.Model = self.dataSoure[indexPath.row];
    }];
}




#pragma mark - cell点击执行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

#pragma mark - cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

#pragma mark - section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
