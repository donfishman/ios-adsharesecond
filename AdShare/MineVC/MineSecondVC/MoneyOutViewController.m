//
//  MoneyOutViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/26.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "MoneyOutViewController.h"

@interface MoneyOutViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic) NSMutableArray *dataSoure;
@property(strong,nonatomic) UITableView *tableView;

@end

@implementation MoneyOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 46 - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.layoutMargins  = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = KColor(223, 223, 223);
    // 设置表头
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"moneyDCell"];
    [self.view addSubview:self.tableView];
    
    self.dataSoure = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadMoneyInDataAAA];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)loadMoneyInDataAAA {
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:UserDefaults(@"uid"),@"uid",@"2",@"type", nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSArray * array = response[@"data"];
        if (array.count >0) {
            for (NSDictionary * diction in array) {
                MoneyModel * model = [MoneyModel new];
                model.mId = diction[@"id"];
                model.mPrice = diction[@"price"];
                model.mTime = diction[@"create_time"];
                if ([diction[@"status"] isEqual:[NSNull null]]) {
                    model.status = @"0";
                }else {
                    model.status = diction[@"status"];
                }
                [self.dataSoure addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/UserAccount/CommissionDetails" withParameters:dict];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"moneyDCell"];
    
    if (!cell) {
        cell = [[MoneyDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moneyDCell"];
    }
    //    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MoneyModel * model = self.dataSoure[indexPath.row];
    cell.titleText.text = @"提现";
    NSInteger status = model.status.integerValue;
    if (status == 0) {
        cell.titleText.text = @"提现到银行卡";
    }else if (status == 1) {
        cell.titleText.text = @"提现到微信";
    }
    
    cell.time.text = model.mTime;
    cell.price.text = [NSString stringWithFormat:@"-%@",model.mPrice];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"此页点击cell无效果");
}

//设置单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
