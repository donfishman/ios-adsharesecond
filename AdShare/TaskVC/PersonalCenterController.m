//
//  PersonalCenterController.m
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "PersonalCenterController.h"
#import "PersonalCenterTableView.h"
#import "ContentViewCell.h"
#import "YUSegment.h"
#import "TaskDeatilsView.h"

@interface PersonalCenterController ()<UITableViewDelegate, UITableViewDataSource>

//headView
@property (strong, nonatomic) TaskDeatilsView *headView;
//tableView
@property (strong, nonatomic) PersonalCenterTableView *tableView;
//分段控制器
@property (strong, nonatomic) YUSegment *segment;
//YES代表能滑动
@property (nonatomic, assign) BOOL canScroll;
//pageViewController
@property (strong, nonatomic) ContentViewCell *contentCell;
//导航栏的背景view
@property (strong, nonatomic) UIImageView *barImageView;
@property (strong, nonatomic) NSString * rrrrrrrid;

@end

//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation PersonalCenterController

-(PersonalCenterTableView *)tableView {
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView = [[PersonalCenterTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationController.navigationBar.barTintColor = CColor(whiteColor);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(blackColor)};
    self.tabBarController.tabBar.hidden = YES;
    
    [self creatTaskStateView];
    
    [self.headView.btn_cancel setTitle:@"放弃任务" forState:UIControlStateNormal];
    [self.headView.btn_cancel.layer setMasksToBounds:YES];
    [self.headView.btn_cancel.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [self.headView.btn_cancel.layer setBorderWidth:1.0]; //边框宽度
    [self.headView.btn_cancel.layer setBorderColor:NavColor.CGColor];//边框颜色
    [self.headView.btn_cancel setTitleColor:NavColor forState:UIControlStateNormal];//title color
    self.headView.btn_cancel.titleLabel.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
    self.headView.btn_cancel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [self.headView.btn_cancel addTarget:self action:@selector(cancelbuttonAction:) forControlEvents:UIControlEventTouchDown];//button 点击回调方法
    self.headView.btn_cancel.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    [self tableView];
    [self creatBottomView];
    
    self.navigationItem.title = @"任务详情";
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadSuccess) name:@"uploadSuccess" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.barImageView = self.navigationController.navigationBar.subviews.firstObject;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSoure      = [NSMutableArray array];
    self.dictSoure      = [NSMutableDictionary dictionary];
    self.taskSoure      = [NSMutableDictionary dictionary];
    
  
    
    //通知的处理，本来也不需要这么多通知，只是写一个简单的demo，所以...根据项目实际情况进行优化吧 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
    self.tableView.showsVerticalScrollIndicator = NO;
    [ContentViewCell regisCellForTableView:self.tableView];
    
    //分段控制器 YUSegment
    self.segment = [[YUSegment alloc] initWithTitles:@[@"任务详情",@"相关任务",@"附近任务"]];
    self.segment.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.segment.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.segment addTarget:self action:@selector(onSegmentChange) forControlEvents:UIControlEventValueChanged];
    
    //tableView headerview
    self.headView = [TaskDeatilsView initHeaderView];
    self.headView.frame = CGRectMake(0, 0, KSW, 489 + 26 + 30);

    self.tableView.tableHeaderView = self.headView;
}

- (void)uploadSuccess {
    self.headView.lb_shengyu.hidden = YES;
    self.headView.btn_cancel.hidden = YES;
    self.headView.lb_shengyuTime.hidden = YES;
    [_taskActionBtn setTitle:@"查看提交" forState:UIControlStateNormal];
    UIAlertController * alert = [YANDTools createAlertWithTitle:@"上传成功" message:@"请耐心等待审核，谢谢！" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dsadsadsads {
    [self.headView.imageBig sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dictSoure[@"cover"]]]];
    [self.headView.imageSmall sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dictSoure[@"thumbnail"]]]];
    self.headView.taskTitle.text = self.dictSoure[@"name"];
    NSArray * arr = self.dictSoure[@"label"];
    if (arr.count == 1) {
        self.headView.lb_tagA.text = [NSString stringWithFormat:@"%@", arr[0]];
        self.headView.lb_tagB.hidden = YES;
        self.headView.lb_tagC.hidden = YES;
    }else if (arr.count == 2) {
        self.headView.lb_tagA.text = [NSString stringWithFormat:@"%@", arr[0]];
        self.headView.lb_tagB.text = [NSString stringWithFormat:@"%@", arr[1]];
        self.headView.lb_tagC.hidden = YES;
    }else if (arr.count == 3) {
        self.headView.lb_tagA.text = [NSString stringWithFormat:@"%@", arr[0]];
        self.headView.lb_tagB.text = [NSString stringWithFormat:@"%@", arr[1]];
        self.headView.lb_tagC.text = [NSString stringWithFormat:@"%@", arr[2]];
    }else if (arr.count > 3) {
        self.headView.lb_tagA.text = [NSString stringWithFormat:@"%@", arr[0]];
        self.headView.lb_tagB.text = [NSString stringWithFormat:@"%@", arr[1]];
        self.headView.lb_tagC.text = [NSString stringWithFormat:@"%@", arr[2]];
    }
    NSString * strd = [NSString stringWithFormat:@"￥%@-%@",self.dictSoure[@"min_price"],self.dictSoure[@"max_price"]];
    self.headView.lb_price.text = [strd stringByReplacingOccurrencesOfString:@".00"withString:@""];
    self.headView.lb_overTime.text = [NSString stringWithFormat:@"结束时间：%@",self.dictSoure[@"end_time"]];
    self.headView.lb_checkTime.text = [NSString stringWithFormat:@"审核时间：%@天",self.dictSoure[@"examine_time"]];
    [self creatBottomView];
    
    if ([self.taskSoure[@"tasktype"][@"type"] isEqualToString:@"1"]) {
        //继续任务
        [self creatTaskStateView];
        [_taskActionBtn setTitle:@"继续任务" forState:UIControlStateNormal];
    }
    else {
        [_taskActionBtn setTitle:@"查看提交" forState:UIControlStateNormal];
        [self creatTaskStateViewAWithType:self.taskSoure[@"tasktype"][@"type"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

///通知的处理
//pageViewController页面变动时的通知
- (void)onPageViewCtrlChange:(NSNotification *)ntf {
    //更改YUSegment选中目标
    self.segment.selectedIndex = [ntf.object integerValue];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.contentCell.canScroll = NO;
}

//当滑动下面的PageView时，当前要禁止滑动
- (void)onScrollBottomView:(NSNotification *)ntf {
    if ([ntf.object isEqualToString:@"ended"]) {
        //bottomView停止滑动了  当前页可以滑动
        self.tableView.scrollEnabled = YES;
    } else {
        //bottomView滑动了 当前页就禁止滑动
        self.tableView.scrollEnabled = NO;
    }
}

//监听segment的变化
- (void)onSegmentChange {
    //改变pageView的页码
    self.contentCell.selectIndex = self.segment.selectedIndex;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //要减去导航栏 状态栏 以及 sectionheader的高度
    return self.view.frame.size.height-44-64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //sectionheader的高度，这是要放分段控件的
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segment;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.contentCell) {
        self.contentCell = [ContentViewCell dequeueCellForTableView:tableView];
        self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentCell.delegate = self;
        [self.contentCell setPageView:self.taskSoure];
//        [self.contentCell customPageView];
    }
//    ContentViewCell *cell = [ContentViewCell dequeueCellForTableView:tableView];
    return self.contentCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-64;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
            _canScroll = NO;
            self.contentCell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
}

- (void)viewDidLayoutSubviews {
    
}




#pragma mark - 按钮点击事件区域
//放弃任务
- (void)cancelbuttonAction:(id)send {
    UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"确定放弃任务么？" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
        self.headView.taskDeatilsV.hidden = YES;
        NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/taskgiveup/uid/%@/rid/%@",UserDefaults(@"uid"),self.dictSoure[@"id"]];
        [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
            NSLog(@"%@",response);
            [self.taskActionBtn setTitle:@"立即执行" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
        } withUrl:str];
        
    } cancleHandler:^(UIAlertAction *cancleAction) {
    }];
    [self presentViewController:alertV animated:YES completion:nil];
}
//左上角返回
- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享按钮
- (void)shanreButtonAction:(id)sender {
    NSString * ShareUrl = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Share/index/id/%@",self.dictSoure[@"id"]];
    [[NSUserDefaults standardUserDefaults] setObject:ShareUrl forKey:@"ShareUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:self.dictSoure[@"name"] forKey:@"ShareTitle"];
    //    [[NSUserDefaults standardUserDefaults] setObject:ShareUrl forKey:@"ShareDetail"];
    [[NSUserDefaults standardUserDefaults] setObject:self.dictSoure[@"thumbnail"] forKey:@"ShareImage"];//cover
    [[NSUserDefaults standardUserDefaults]synchronize];
    UMShareViewController *shareShowVC = [UMShareViewController new];
    [shareShowVC showShareViewClick];
}

//收藏按钮
- (void)collectBtnAction:(UIButton *)btn {
    UIButton * button = btn;
    id btnImage = button.imageView.image;
    if ([btnImage isEqual:[UIImage imageNamed:@"icon_star_def"]]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
            NSString *url = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/collection/id/%@/uid/%@",self.dictSoure[@"id"],UserDefaults(@"uid")];
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
                NSLog(@"%@",response[@"msg"]);
                [button setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
            } failure:^(NSError *error) {
            } withUrl:url];
            
        } else {
            UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[LoginViewController new] animated:YES];
            } cancleHandler:^(UIAlertAction *cancleAction) {
                
            }];
            [self presentViewController:alertV animated:YES completion:nil];
        }
    }
    else if ([btnImage isEqual:[UIImage imageNamed:@"icon_star_sel"]]) {
        NSString *url = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/cancelcollection/id/%@/uid/%@",self.taskSoure[@"collect"],UserDefaults(@"uid")];
        [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
            NSLog(@"%@",response[@"msg"]);
            [button setImage:[UIImage imageNamed:@"icon_star_def"] forState:UIControlStateNormal];
        } failure:^(NSError *error) {
        } withUrl:url];
    }
}
//任务执行按钮
- (void)beginBtnAction:(UIButton *)btn {
    NSString *btnTit = btn.currentTitle;
    NSLog(@"%@",btnTit);
    if ([btnTit isEqualToString:@"立即执行"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
            NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/immediate/id/%@/uid/%@",self.dictSoure[@"id"],UserDefaults(@"uid")];
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {

                NSInteger codeInt = [response[@"code"] integerValue];
                if (codeInt == 200) {
                    [btn setTitle:@"继续任务" forState:UIControlStateNormal];
                    self.headView.lb_shengyu.hidden = NO;
                    self.headView.btn_cancel.hidden = NO;
                    self.headView.lb_shengyuTime.hidden = NO;
                    self.headView.shenheImg.hidden = YES;
                    self.headView.lb_shenhe.hidden = YES;
                    NSString * str = response[@"content"];
                    self.rrrrrrrid = str;
                    self.hidesBottomBarWhenPushed = YES;
                    UpTaskInfoViewController * uptaskVC = [UpTaskInfoViewController new];
                    [uptaskVC setCridStr:str withRid:self.dictSoure[@"id"]withimgCount:self.dictSoure[@"img_num"]];
                    [self.navigationController pushViewController:uptaskVC animated:YES];
                }
                else if (codeInt == 206) {
                    UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                    }];
                    [self presentViewController:alertV animated:YES completion:nil];
                } else {
                    UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
                    } cancleHandler:^(UIAlertAction *cancleAction) {
                    }];
                    [self presentViewController:alertV animated:YES completion:nil];
                }
            } failure:^(NSError *error) {
            } withUrl:str];
        } else {
            UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[LoginViewController new] animated:YES];
            } cancleHandler:^(UIAlertAction *cancleAction) {
            }];
            [self presentViewController:alertV animated:YES completion:nil];
        }
    }
    else if ([btnTit isEqualToString:@"继续任务"]) {
        self.hidesBottomBarWhenPushed = YES;
        UpTaskInfoViewController * uptaskVC = [UpTaskInfoViewController new];
        [uptaskVC setCridStr:self.taskSoure[@"crid"]withRid:self.dictSoure[@"id"]withimgCount:self.dictSoure[@"img_num"]];
        [self.navigationController pushViewController:uptaskVC animated:YES];
    }
//    else if ([btnTit isEqualToString:@"领取奖励"]) {
//        NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php?g=ApiHome&m=Sowing&a=index&uid=%@&rid=%@&rrid=%@",UserDefaults(@"uid"),self.dictSoure[@"id"],self.taskSoure[@"crid"]];
//        WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
//        [wkWebVC loadUrlWithString:str];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:wkWebVC animated:NO];
//    }
    else {
//        self.hidesBottomBarWhenPushed = YES;
//        UpTaskInfoViewController * uptaskVC = [UpTaskInfoViewController new];
//        [uptaskVC setCridStr:self.taskSoure[@"crid"]withRid:self.dictSoure[@"id"]withimgCount:self.dictSoure[@"img_num"]];
//        [self.navigationController pushViewController:uptaskVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        LookSubmitVC * vc = [LookSubmitVC new];
        NSString * str = self.taskSoure[@"crid"];
        if ([str isEqualToString:@""]) {
            vc.rrid1 = self.rrrrrrrid;
        }else {
            vc.rrid1 = self.taskSoure[@"crid"];
        }
        NSLog(@"%@",self.taskSoure);
        vc.img_num = self.taskSoure[@"msg"][@"img_num"];
        vc.end_time = self.taskSoure[@"msg"][@"end_time"];
        vc.taskID1 = UserDefaults(@"uid");
        vc.rid = self.taskSoure[@"msg"][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 设置四个按钮
//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setImageEdgeInsets:UIEdgeInsetsMake(- btn.titleLabel.intrinsicContentSize.height, 0, 0, - btn.titleLabel.intrinsicContentSize.width)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.currentImage.size.height + 5, - btn.currentImage.size.width, 0, 0)];
}

- (void)loadDataWithTaskID:(NSString *)idStr {
    NSString * url = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/index/id/%@/uid/%@", idStr,UserDefaults(@"uid")];
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        self.dictSoure = response[@"msg"];
        self.taskSoure = [NSMutableDictionary dictionaryWithDictionary:response];
        NSLog(@"%@",self.dictSoure);
        NSLog(@"%@",self.taskSoure);
        [self dsadsadsads];
        [self.tableView reloadData];
        [self.contentCell setPageView:self.taskSoure];
    } failure:^(NSError *error) {
        
    } withUrl:url];
}

- (void)creatTaskStateViewAWithType:(NSString *)typrStr {
    self.headView.lb_shengyu.hidden = YES;
    self.headView.btn_cancel.hidden = YES;
    self.headView.lb_shengyuTime.hidden = YES;

    
    if ([typrStr isEqualToString:@"2"]) {
        //继续任务
        [self creatTaskStateView];
        [_taskActionBtn setTitle:@"查看提交" forState:UIControlStateNormal];
    } else if ([typrStr isEqualToString:@"3"]) {
        //领取奖励
        self.headView.shenheImg.hidden = NO;
        self.headView.lb_shenhe.hidden = NO;
        self.headView.lb_shenhe.text = @"已通过";
        [self.headView.shenheImg setImage:[UIImage imageNamed:@"icon_state_tongguo"]];
    } else if ([typrStr isEqualToString:@"4"]) {
        //已拒绝
        self.headView.shenheImg.hidden = NO;
        self.headView.lb_shenhe.hidden = NO;
        self.headView.lb_shenhe.text = @"已拒绝";
        [self.headView.shenheImg setImage:[UIImage imageNamed:@"icon_state_shenhezhong"]];
    } else if ([typrStr isEqualToString:@"5"]) {
        //已放弃
        self.headView.shenheImg.hidden = NO;
        self.headView.lb_shenhe.hidden = NO;
        self.headView.lb_shenhe.text = @"已放弃";
        [self.headView.shenheImg setImage:[UIImage imageNamed:@"icon_state_shenhezhong"]];
    } else if ([typrStr isEqualToString:@"6"]) {
        //已领取
        self.headView.shenheImg.hidden = NO;
        self.headView.lb_shenhe.hidden = NO;
        self.headView.lb_shenhe.text = @"已领取";
        [self.headView.shenheImg setImage:[UIImage imageNamed:@"icon_state_shenhezhong"]];
    } else if ([typrStr isEqualToString:@""]) {
        self.headView.shenheImg.hidden = YES;
        self.headView.lb_shenhe.hidden = YES;
        self.headView.lb_shengyu.hidden = YES;
        self.headView.btn_cancel.hidden = YES;
        self.headView.lb_shengyuTime.hidden = YES;
        //立即执行
        [_taskActionBtn setTitle:@"立即执行" forState:UIControlStateNormal];
    }
}

- (void)creatTaskStateView {
    self.headView.lb_shenhe.hidden = YES;
    self.headView.shenheImg.hidden = YES;
    self.headView.lb_shengyu.text = @"剩余时间：";
    self.headView.lb_shengyu.backgroundColor = CColor(clearColor);
    
    TimeLabel *tlable = [TimeLabel new];
    tlable.frame = CGRectMake(0, 0, 70, 18);
    tlable.font = [UIFont systemFontOfSize:13.0];
    tlable.textColor = NavColor;
    NSString * timeStr = self.taskSoure[@"tasktype"][@"count_down"];
    int totalSeconds = [timeStr intValue];
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    tlable.hour = hours;
    tlable.minute = minutes;
    tlable.second = seconds;
    
    [self.headView.lb_shengyuTime addSubview:tlable];

    [self.headView.btn_cancel setTitle:@"放弃任务" forState:UIControlStateNormal];
    [self.headView.btn_cancel.layer setMasksToBounds:YES];
    [self.headView.btn_cancel.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [self.headView.btn_cancel.layer setBorderWidth:1.0]; //边框宽度
    [self.headView.btn_cancel.layer setBorderColor:NavColor.CGColor];//边框颜色
    [self.headView.btn_cancel setTitleColor:NavColor forState:UIControlStateNormal];//title color
    self.headView.btn_cancel.titleLabel.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
    self.headView.btn_cancel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [self.headView.btn_cancel addTarget:self action:@selector(cancelbuttonAction:) forControlEvents:UIControlEventTouchDown];//button 点击回调方法
    self.headView.btn_cancel.backgroundColor = [UIColor clearColor];
}


- (void)creatBottomView {
    self.bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.height.mas_offset(49);
    }];
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KSW * 0.29, 49)];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    _shareBtn.backgroundColor = CColor(whiteColor);
    [_shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [_shareBtn setTitleColor:KColor(151, 151, 151) forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = FontSize(11);
    [_shareBtn addTarget:self action:@selector(shanreButtonAction:) forControlEvents:UIControlEventTouchDown];
    self.collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSW * 0.29, 0, KSW * 0.29, 49)];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    if ([self.taskSoure[@"collect"] isEqualToString:@"0"]) {
        [_collectBtn setImage:[UIImage imageNamed:@"icon_star_def"] forState:UIControlStateNormal];
    }
    else {
        [_collectBtn setImage:[UIImage imageNamed:@"icon_star_sel"] forState:UIControlStateNormal];
    }
    _collectBtn.backgroundColor = CColor(whiteColor);
    [_collectBtn setTitleColor:KColor(151, 151, 151) forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = FontSize(11);
    [_collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchDown];
    self.taskActionBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSW * 0.58, 0, KSW * 0.42, 49)];
    [_taskActionBtn addTarget:self action:@selector(beginBtnAction:) forControlEvents:UIControlEventTouchDown];
    _taskActionBtn.backgroundColor = NavColor;
    _taskActionBtn.titleLabel.font = FontSize(18);
   
    //1,待提交2,待审核3,已通过4,已拒绝，5放弃，6已领取
    [self initButton:_shareBtn];
    [self initButton:_collectBtn];
    [_bottomView addSubview:_shareBtn];
    [_bottomView addSubview:_collectBtn];
    [_bottomView addSubview:_taskActionBtn];
}

-(void)tableViewDidSelectIdA:(NSString *)idStr{
    
    PersonalCenterController *ctrl = [PersonalCenterController new];
    [ctrl loadDataWithTaskID:idStr];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}




@end
