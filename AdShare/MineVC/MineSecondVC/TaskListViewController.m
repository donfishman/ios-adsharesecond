//
//  TaskListViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/5/8.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "TaskListViewController.h"

@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TimeLabel *tlable;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSoure;

@end

@implementation TaskListViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的任务";
    self.dataSoure = [NSMutableArray array];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.tlable = [[TimeLabel alloc]initWithFrame:CGRectMake(0, 0, 65, 18)];
    
    UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSW, 38)];
    if (self) {
        NSArray *titlearray = [[NSArray alloc] initWithObjects:@"全部",@"待提交",@"待审核",@"已通过",@"已拒绝", nil];
        for (int i = 0; i<5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(KSW / 5.0*i, 0, KSW/5.0, 38);
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = FontSize(14);
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[titlearray objectAtIndex:i] forState:0];
            [btn setTitleColor:[UIColor blackColor] forState:0];
            [btn setTitleColor:NavColor forState:UIControlStateSelected];
            [viewB addSubview:btn];
            if (i == self.selectTag - 999) {
                btn.selected = YES;
                UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(i * KSW/5, 38, KSW/5.0, 2)];
                line.tag = 15;
                line.backgroundColor = NavColor;
                [viewB addSubview:line];
            } else {
                btn.selected = NO;
            }
        }
    }
    [self.view addSubview:viewB];
    [self initTableView];
}

- (void)loadListData:(NSString *)typeStr {
    WS(weakSelf);
    NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/mytask/uid/%@/type/%@",UserDefaults(@"uid"),typeStr];
    
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        [self.dataSoure removeAllObjects];
        NSLog(@"content = %@",response[@"content"]);
        NSArray *array = response[@"content"];
        if (array.count >0) {
            for (NSDictionary * dict in array) {
                TaskListModel * model = [TaskListModel new];
                model.count_down = dict[@"count_down"];
                model.create_time = dict[@"create_time"];
                model.end_time = dict[@"end_time"];
                model.label = dict[@"label"];
                model.max_price = dict[@"max_price"];
                model.min_price = dict[@"min_price"];
                model.name = dict[@"name"];
                model.rid = dict[@"rid"];
                model.crid = dict[@"id"];
                model.type = dict[@"type"];
                model.thumbnail = dict[@"thumbnail"];
                model.img_num = dict[@"img_num"];
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
        
    } withUrl:str];
}

- (void)dealloc {
    [self.dataSoure removeAllObjects];
}


- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = CColor(whiteColor);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(blackColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TaskListTableViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = CColor(whiteColor);
    
    TaskListModel * model = self.dataSoure[indexPath.row];
    cell.bigTitile.text = model.name;
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
    NSInteger type = model.type.integerValue;
//    NSLog(@"我的任务type = %ld   +++   %@",(long)type,model.type);
    if (type == 1) {
        cell.lb_time.hidden = NO;
        cell.taskButton.hidden = NO;
        cell.taskType.hidden = NO;
        [cell.taskButton setTitle:@"继续任务" forState:UIControlStateNormal];
        cell.taskButton.backgroundColor = NavColor;
        [cell.taskType setText:@"剩余时间："];
        NSString * timeStr = model.count_down;
        int timerCount = [timeStr intValue];
        NSString *hour;
        if (timerCount / (60 * 60) < 10 & timerCount / (60 * 60) >= 0) {
            hour = [NSString stringWithFormat:@"0%ld", (long)timerCount / (60 * 60)];
        } else {
            hour = [NSString stringWithFormat:@"%ld", (long)timerCount / (60 * 60)];
        }
        NSString *minute;
        if (timerCount / 60 % 60 < 10 & timerCount / 60 % 60 >= 0) {
            minute = [NSString stringWithFormat:@"0%ld", (long)timerCount / 60 % 60];
        } else {
            minute = [NSString stringWithFormat:@"%ld", (long)timerCount / 60 % 60];
        }
        NSString *second;
        if (timerCount % 60 < 10 & timerCount % 60 >= 0) {
            second = [NSString stringWithFormat:@"0%ld", (long)timerCount%60];
        }else {
            second = [NSString stringWithFormat:@"%ld", (long)timerCount%60];
        }
        if ([hour isEqualToString:@"00"]) {
            if ([minute isEqualToString:@"00"]) {
                cell.lb_time.text = [NSString stringWithFormat:@"00:00:%@", second];
            } else {
                cell.lb_time.text = [NSString stringWithFormat:@"00:%@:%@", minute, second];
            }
        } else {
            cell.lb_time.text = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
        }
    } else if (type == 2) {
        cell.taskType.hidden = NO;
        cell.taskButton.hidden = YES;
        cell.lb_time.hidden = YES;
        [cell.taskType setText:@"正在审核"];
    } else if (type == 3) {
        cell.taskButton.hidden = NO;
        cell.lb_time.hidden = YES;
        cell.taskType.hidden = NO;
        [cell.taskType setText:@"已通过"];
        [cell.taskButton setTitle:@"领取奖励" forState:UIControlStateNormal];
        cell.taskButton.backgroundColor = NavColor;
    } else if (type == 4) {
        cell.taskType.hidden = NO;
        cell.taskButton.hidden = NO;
        cell.lb_time.hidden = YES;
        [cell.taskType setText:@"已拒绝"];
        [cell.taskButton setTitle:@"重新申请" forState:UIControlStateNormal];
        NSString * time = [self currentTimeStr];
        NSLog(@"%@",time);
        int i = [self compareDate:model.end_time withDate:time];
        if (i == -1) {
            [cell.taskButton setTitle:@"已过期" forState:UIControlStateNormal];
            cell.taskButton.enabled = NO;
            cell.taskButton.backgroundColor = KColor(153, 153, 153);
        } else if (i == 0) {
            [cell.taskButton setTitle:@"已过期" forState:UIControlStateNormal];
            cell.taskButton.enabled = NO;
            cell.taskButton.backgroundColor = KColor(153, 153, 153);
        }
    } else if (type == 5) {
        cell.taskType.hidden = NO;
        cell.taskButton.hidden = NO;
        cell.lb_time.hidden = YES;
        [cell.taskType setText:@"已放弃"];
        [cell.taskButton setTitle:@"重新申请" forState:UIControlStateNormal];
        cell.taskButton.backgroundColor = NavColor;
    } else if (type == 6) {
        cell.taskType.hidden = NO;
        cell.taskButton.hidden = YES;
        cell.lb_time.hidden = YES;
        [cell.taskType setText:@"已领取"];
    }
 
    
    
    [cell.taskButton addTarget:self action:@selector(cellButtonTouchDownAction:event:) forControlEvents:UIControlEventTouchDown];
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}



- (void)cellButtonTouchDownAction:(id)sender event:(id)event {
    //获取触摸点的集合，可以判断多点触摸事件
    NSSet *touches=[event allTouches];
    //两句话是保存触摸起点位置
    UITouch *touch = [touches anyObject];
    CGPoint cureentTouchPosition = [touch locationInView:self.tableView];
    //得到cell中的IndexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cureentTouchPosition];
//    NSLog(@"section----%li,----row---%li",(long)indexPath.section,(long)indexPath.row);
    TaskListTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    TaskListModel * model = self.dataSoure[indexPath.row];
//    NSLog(@"%@",model.rid);
//    NSLog(@"%@",model.crid);

    NSString * buttonTitle = [NSString stringWithFormat:@"%@",cell.taskButton.currentTitle];
    
    if ([buttonTitle isEqualToString:@"领取奖励"]) {
        NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php?g=ApiHome&m=Sowing&a=index&uid=%@&rid=%@&rrid=%@",UserDefaults(@"uid"),model.rid,model.crid];
        WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
        [wkWebVC loadUrlWithString:str];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wkWebVC animated:NO];
    } else if ([buttonTitle isEqualToString:@"重新申请"]) {
        NSString *stssr = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/myretask/id/%@/uid/%@",model.crid,UserDefaults(@"uid")];
        [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
            NSInteger codeInt = [response[@"code"] integerValue];
            if (codeInt == 200) {
                self.hidesBottomBarWhenPushed = YES;
                UpTaskInfoViewController * uptaskVC = [UpTaskInfoViewController new];
                [uptaskVC setCridStr:model.crid withRid:model.rid withimgCount:model.img_num];
                [self.navigationController pushViewController:uptaskVC animated:YES];
            }else {
                UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
                } cancleHandler:^(UIAlertAction *cancleAction) {
                }];
                [self presentViewController:alertV animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
        } withUrl:stssr];
    } else if ([buttonTitle isEqualToString:@"继续任务"]) {
        self.hidesBottomBarWhenPushed = YES;
        UpTaskInfoViewController * uptaskVC = [UpTaskInfoViewController new];
        [uptaskVC setCridStr:model.crid withRid:model.rid withimgCount:model.img_num];
        [self.navigationController pushViewController:uptaskVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;

    } else {
        PersonalCenterController * buyVC = [PersonalCenterController new];
        [buyVC loadDataWithTaskID:model.rid];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:buyVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
    
    
    
}







- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 138.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}



-(void)selectbtn:(UIButton *)btn {
    selectindex = (int)btn.tag - 100;
    btn.selected = YES;
    for (int i = 0; i < 5; i++) {
        UIButton *button1 = (UIButton *)[self.view viewWithTag:100 + i];
        if (i == selectindex ) {
            button1.selected = YES;
            UILabel *lab = (UILabel *)[self.view viewWithTag:15];
            CGRect frame = lab.frame;
            frame.origin.x = button1.frame.origin.x;
            [UIView animateWithDuration: 0.15 animations: ^{
                lab.frame = CGRectMake(KSW / 5.0 * self->selectindex, 38, KSW / 5.0, 2);
            } completion: nil];
            NSString * str = [NSString stringWithFormat:@"%d",selectindex];
            [self loadListData:str];
        } else {
            button1.selected = NO;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListModel * model = self.dataSoure[indexPath.row];
    PersonalCenterController *ctrl = [PersonalCenterController new];
    [ctrl loadDataWithTaskID:model.rid];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
