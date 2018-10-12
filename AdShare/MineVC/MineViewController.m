//
//  MineViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/23.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "MineViewController.h"
#import <Masonry.h>

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSArray           * dataSoure;
@property (nonatomic, strong) NSArray           * imgSoure;
@property (nonatomic, strong) UIView            * headView;
@property (nonatomic, strong) UIView            * headBView;
@property (nonatomic, strong) UIView            * lineView;
@property (nonatomic, strong) UIImageView       * userIcon;
@property (nonatomic, strong) UILabel           * userName;
@property (nonatomic, strong) UIButton          * changeBtn;
@property (nonatomic, strong) UIButton          * loginBtn;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headView.hidden = NO;
    self.changeBtn.hidden = NO;
    self.userIcon.hidden = NO;
    self.loginBtn.hidden = NO;
    self.userName.hidden = NO;
    self.headBView.hidden = NO;
    self.lineView.hidden = NO;
    self.tableView.hidden = NO;
    self.view.backgroundColor = CColor(whiteColor);
    
    self.dataSoure = [NSMutableArray arrayWithObjects:@"佣金",@"我的收藏",@"邀请好友",@"客服电话", @"意见反馈", @"关于我们",nil];
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.tintColor = CColor(clearColor);
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshIcon) name:@"loginSuccess" object:nil];
    
    
    
}

- (void)refreshIcon {
    self.userName.text = UserDefaults(@"username");
    NSString * str = UserDefaults(@"imageUrl");
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:str]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userName.text = UserDefaults(@"username");
    NSString * str = UserDefaults(@"imageUrl");
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:str]];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlqqq = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/UserAccount/myCommission/uid/%@",UserDefaults(@"uid")];
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
                NSString * feeData = response[@"balance"];
                if ([feeData isEqual:[NSNull null]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"money"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else {
                    [[NSUserDefaults standardUserDefaults] setObject:feeData forKey:@"money"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            } failure:^(NSError *error) {
                
            } withUrl:urlqqq];
        });
    });
    
    
    
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/UserAccount/myCommission/uid/%@",UserDefaults(@"uid")]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"从服务器获取到数据");
            NSDictionary * dictt = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSString * feeData = dictt[@"balance"];
                    if ([feeData isEqual:[NSNull null]]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"money"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else {
                        [[NSUserDefaults standardUserDefaults] setObject:feeData forKey:@"money"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
        }];
        [sessionDataTask resume];
    [self.tableView reloadData];
}

#pragma mark - headView
-(UIView *)headView {
    if (!_headView) {
        self.headView = [UIView new];
        self.headView.backgroundColor = KColor(251,112,69);
        [self.view addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, KScreenWidth *0.6));
        }];
    }
    return _headView;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        self.changeBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn.layer setMasksToBounds:YES];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_changeBtn setImage:[UIImage imageNamed:@"xiugaiziliao"] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeUserInfo) forControlEvents:UIControlEventTouchDown];
        [self.headView addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.headView.mas_right).mas_offset(-15);
            make.top.mas_equalTo(self.headView.mas_top).mas_offset(25);
            make.size.mas_offset(CGSizeMake(80, 25));
        }];
    }
    return _changeBtn;
}

- (UIImageView *)userIcon {
    if (!_userIcon) {
        self.userIcon = [UIImageView new];
        NSString * str = UserDefaults(@"imageUrl");
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:str]];
        _userIcon.layer.cornerRadius = 35.0;
        _userIcon.layer.masksToBounds = YES;
        [self.headView addSubview:_userIcon];
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.headView.mas_centerX).mas_offset(0);
            make.top.mas_equalTo(self.changeBtn.mas_bottom).mas_offset(20);
            make.size.mas_offset(CGSizeMake(70, 70));
        }];
    }
    return _userIcon;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        self.loginBtn = [UIButton new];
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.headView addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.headView.mas_centerX).mas_offset(0);
            make.top.mas_equalTo(self.changeBtn.mas_bottom).mas_offset(20);
            make.size.mas_offset(CGSizeMake(70, 70));
        }];
    }
    return _loginBtn;
}



- (UILabel *)userName {
    if (!_userName) {
        self.userName = [UILabel new];
        _userName.text = UserDefaults(@"username");
        _userName.textColor = CColor(whiteColor);
        _userName.backgroundColor = CColor(clearColor);
        [self.headView addSubview:_userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.userIcon.mas_centerX).mas_offset(0);
            make.top.mas_equalTo(self.userIcon.mas_bottom).mas_offset(10);
            make.height.mas_offset(20);
        }];
    }
    return _userName;
}

- (UIView *)headBView {
    if (!_headBView) {
        self.headBView = [UIView new];
        self.headBView.backgroundColor = CColor(whiteColor);
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"待提交" forState:UIControlStateNormal];
        btn1.tag = 1000;
        [btn1 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchDown];
        [btn1 setTitleColor:KColor(153, 153, 153) forState:UIControlStateNormal];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"待审核" forState:UIControlStateNormal];
        btn2.tag = 1001;
        [btn2 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchDown];
        [btn2 setTitleColor:KColor(153, 153, 153) forState:UIControlStateNormal];
        
        UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setTitle:@"已通过" forState:UIControlStateNormal];
        btn3.tag = 1002;
        [btn3 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchDown];
        [btn3 setTitleColor:KColor(153, 153, 153) forState:UIControlStateNormal];
        
        UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setTitle:@"未通过" forState:UIControlStateNormal];
        btn4.tag = 1003;
        [btn4 addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchDown];
        [btn4 setTitleColor:KColor(153, 153, 153) forState:UIControlStateNormal];
        
        [btn1 setImage:[UIImage imageNamed:@"me_daitijiao"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"me_daishenhe"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"me_yitongguo"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"me_weitongguo"] forState:UIControlStateNormal];
        
        
        
        btn1.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn3.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn4.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [self initButton:btn1];
        [self initButton:btn2];
        [self initButton:btn3];
        [self initButton:btn4];
        
        NSArray * arr = [NSArray arrayWithObjects:btn1,btn2,btn3,btn4, nil];
        
        [self.headBView addSubview:btn1];
        [self.headBView addSubview:btn2];
        [self.headBView addSubview:btn3];
        [self.headBView addSubview:btn4];
        
        [self test_masonry_horizontal_fixItemWidth:arr];
        [self.view addSubview:self.headBView];
        [self.headBView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 90));
        }];
        
    }
    return _headBView;
}

- (UIView *)lineView {
    if (!_lineView) {
        self.lineView = [UIView new];
        self.lineView.backgroundColor = KColor(233, 233, 233);
        [self.view addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headBView.mas_bottom).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 10));
        }];
    }
    return _lineView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.layoutMargins  = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = KColor(223, 223, 223);
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = CColor(whiteColor);
        [self.tableView registerNib:[UINib nibWithNibName:@"ShopTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopTextTableViewCellID"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
            make.width.mas_offset(KScreenWidth);
        }];
    }
    return _tableView;
}



#pragma mark - 设置四个按钮
//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setImageEdgeInsets:UIEdgeInsetsMake(- btn.titleLabel.intrinsicContentSize.height, 0, 0, - btn.titleLabel.intrinsicContentSize.width)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.currentImage.size.height + 5, - btn.currentImage.size.width, 0, 0)];
    //    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,- btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    //    [btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0, btn.titleLabel.bounds.size.width*0.5, btn.titleLabel.bounds.size.height, btn.titleLabel.bounds.size.width*0.5 )];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)test_masonry_horizontal_fixItemWidth:(NSArray *)array {
    // 实现masonry水平固定控件宽度方法
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:20 tailSpacing:20];
    // 设置array的垂直方向的约束
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headBView.mas_centerY).mas_offset(0);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - 点击事件
- (void)changeUserInfo {
    //    NSString * uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    //    if (uid != nil) {
    //
    //    }else {
    //        self.changeBtn.userInteractionEnabled = YES;
    //    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else {
        UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            [self loginBtnAction];
        } cancleHandler:^(UIAlertAction *cancleAction) {
            
        }];
        [self presentViewController:alertV animated:YES completion:nil];
    }
}

- (void)pushNextVC:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
        TaskListViewController *vc = [[TaskListViewController alloc]init];
        vc.selectTag = sender.tag;
        NSString * str = [NSString stringWithFormat:@"%ld",sender.tag - 999];
        [vc loadListData:str];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            [self loginBtnAction];
        } cancleHandler:^(UIAlertAction *cancleAction) {
            
        }];
        [self presentViewController:alertV animated:YES completion:nil];
    }
    self.hidesBottomBarWhenPushed = NO;
    
}
- (void)loginBtnAction {
    
    NSString * uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    if (uid == nil) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}


#pragma mark - cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ShopTextTableViewCell *cellA = [tableView dequeueReusableCellWithIdentifier:@"ShopTextTableViewCellID"];
    if (!cellA) {
        cellA = [[ShopTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopTextTableViewCellID"];
    }
    if (!cell) {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.row == 0) {
        NSLog(@"%@",UserDefaults(@"money"));
        cellA.textLabel.text = @"佣金";
        cellA.rightLabel.text = [NSString stringWithFormat:@"￥%@",UserDefaults(@"money")];
        cellA.rightLabel.font = [UIFont systemFontOfSize:15.0];
        cellA.rightLabel.textColor = NavColor;
        cellA.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell右侧有小箭头
        cellA.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellA;
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = self.dataSoure[indexPath.row];
        cell.backgroundColor = CColor(whiteColor);
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }
}


#pragma mark - cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

#pragma mark - cell点击执行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
            [self.navigationController pushViewController:[FeeViewController new] animated:YES];
        }
        else {
            UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [self loginBtnAction];
            } cancleHandler:^(UIAlertAction *cancleAction) {
                
            }];
            [self presentViewController:alertV animated:YES completion:nil];
        }
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.row == 1){
        self.hidesBottomBarWhenPushed = YES;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
            [self.navigationController pushViewController:[CollectionViewController new] animated:YES];
        }
        else {
            UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [self loginBtnAction];
            } cancleHandler:^(UIAlertAction *cancleAction) {
                
            }];
            [self presentViewController:alertV animated:YES completion:nil];
        }
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.row == 2){
        self.hidesBottomBarWhenPushed = YES;
        
        [[NSUserDefaults standardUserDefaults]setObject:@"https://itunes.apple.com/cn/app/pai-shi-jie/id1404693769?mt=8" forKey:@"ShareUrl"];
        [[NSUserDefaults standardUserDefaults]setObject:@"欢迎下载拍世界App！" forKey:@"ShareTitle"];
        //        [[NSUserDefaults standardUserDefaults]setObject:@"欢迎下载拍世界App！" forKey:@"ShareDetail"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        // 在这里执行分享的操作
        UMShareViewController *shareShowVC = [UMShareViewController new];
        [shareShowVC showShareViewClick];
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.row == 3){
        [self callPhoneWithNumber:@"110"];
    }else if (indexPath.row == 4){
        self.hidesBottomBarWhenPushed = YES;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ISLOGIN"]) {
            [self.navigationController pushViewController:[BackSuggestViewController new] animated:YES];
        }
        else {
            UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:@"您当前未登录，不能使用此功能，是否前往登录" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [self loginBtnAction];
            } cancleHandler:^(UIAlertAction *cancleAction) {
                
            }];
            [self presentViewController:alertV animated:YES completion:nil];
        }
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.row == 5){
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[AboutMine new] animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}


#pragma mark - 拨打手机
- (void)callPhoneWithNumber:(NSString *)number {
    NSString *num = [NSString stringWithFormat:@"tel://%@",number];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:num]];
}

#pragma mark - cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

#pragma mark - section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark - 注册这里是 willShowViewController 不是didShow
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[self class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
