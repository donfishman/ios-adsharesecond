//
//  FeeViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/25.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "FeeViewController.h"

@interface FeeViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic) NSArray *listData;
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) UITableViewCell *tableViewCell;


@end

@implementation FeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"佣金";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(pushNextVC)];
    rightBar.tintColor = KColor(102, 102, 102);
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.layoutMargins  = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = KColor(223, 223, 223);
    // 设置表头
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeeTableViewCell" bundle:nil] forCellReuseIdentifier:@"feeCell"];
    [self.view addSubview:self.tableView];
    self.listData = [NSArray arrayWithObjects:@"余额", @"微信提现", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeeTableViewCell * cellA = [tableView dequeueReusableCellWithIdentifier:@"feeCell"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    if (!cellA) {
        cellA = [[FeeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feeCell"];
    }
    if (indexPath.row == 0) {
        cellA.accessoryType = UITableViewCellAccessoryNone;
        cellA.selectionStyle = UITableViewCellSelectionStyleNone;
        cellA.moneyLabel.text = [NSString stringWithFormat:@"￥%@",UserDefaults(@"money")];
        return cellA;
    }
    else if (indexPath.row == 1) {
//        cell.textLabel.text = @"银行卡提现";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    else if (indexPath.row == 2) {
        cell.textLabel.text = @"微信提现";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == 1) {
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:[BangCardViewController new] animated:YES];
//
//    }
//    else if (indexPath.row == 2) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[WXMoneyViewController new] animated:YES];
    }
}
//设置单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 141;
    }
    return 62;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushNextVC {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[MoneyDetailViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
