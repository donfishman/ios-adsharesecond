//
//  LookSubmitVC.m
//  AdShare
//
//  Created by ZLWL on 2018/7/9.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "LookSubmitVC.h"

@interface LookSubmitVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
    
//    @property (nonatomic,strong)UICollectionView *MyCollectionView;
    
    @property (strong, nonatomic) UIView *checkView;
    @property (strong, nonatomic) UILabel *lb_check;
    @property (strong, nonatomic) UILabel *tipsLabel;
    @property (strong, nonatomic) UILabel *lb_beizhu;
    @property (strong, nonatomic) UILabel *lb_renwu;
    @property (strong, nonatomic) UILabel *lb_imgCount;
    @property (nonatomic, strong) NSMutableArray * imgArray;
    @property (nonatomic, strong) NSMutableDictionary   * dictALL;

    @end

@implementation LookSubmitVC

- (void)creatView:(NSDictionary *)dict {
    if ([dict[@"type"] isEqualToString:@"1"]) {
        self.button.hidden = YES;
    } else if ([dict[@"type"] isEqualToString:@"2"]) {
        self.button.hidden = YES;
    } else if ([dict[@"type"] isEqualToString:@"3"]) {
        self.lb_check.text = @"已通过";
        [self.button setTitle:@"领取奖励" forState:UIControlStateNormal];
    } else if ([dict[@"type"] isEqualToString:@"4"]) {
        self.lb_check.text = @"已拒绝";
        [self.button setTitle:@"重新申请" forState:UIControlStateNormal];
        int i = [self compareDate:[self getTimeStrWithString:self.end_time] withDate:[self currentTimeStr]];
        if (i == -1) {
            self.button.hidden = YES;
        } else if (i == 0) {
            self.button.hidden = YES;
        }
    } else if ([dict[@"type"] isEqualToString:@"5"]) {
        self.lb_check.text = @"已放弃";
        [self.button setTitle:@"重新申请" forState:UIControlStateNormal];
    } else if ([dict[@"type"] isEqualToString:@"6"]) {
        self.lb_check.text = @"已领取";
        [self.button setTitle:@"已领取" forState:UIControlStateNormal];
        [self.button setEnabled:NO];
        self.button.backgroundColor = CColor(grayColor);
    } else if ([dict[@"type"] isEqualToString:@""]) {
        [self.button setTitle:@"立即执行" forState:UIControlStateNormal];
    }
    
    [self.button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
    
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


//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}


    
- (void)btnAction:(UIButton * )sender {
    NSString *buttonTitle = sender.titleLabel.text;
    NSLog(@"%@",buttonTitle);
    if ([buttonTitle isEqualToString:@"领取奖励"]) {
        NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php?g=ApiHome&m=Sowing&a=index&uid=%@&rid=%@&rrid=%@",UserDefaults(@"uid"),self.rid,self.rrid1];
        WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
        [wkWebVC loadUrlWithString:str];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wkWebVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }else if ([buttonTitle isEqualToString:@"重新申请"]) {
        NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/myretask/id/%@/uid/%@",self.rrid1,UserDefaults(@"uid")];
        NSLog(@"%@",str);
        [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
            NSInteger codeInt = [response[@"code"] integerValue];
            if (codeInt == 200) {
                self.hidesBottomBarWhenPushed = YES;
                UpTaskInfoViewController * uptaskVC = [UpTaskInfoViewController new];
                [uptaskVC setCridStr:self.rrid1 withRid:self.rid withimgCount:self.img_num];
                [self.navigationController pushViewController:uptaskVC animated:YES];
            }else {
                UIAlertController * alertV =  [YANDTools createAlertWithTitle:@"提示" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                    
                } cancleHandler:^(UIAlertAction *cancleAction) {
                }];
                [self presentViewController:alertV animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
        } withUrl:str];
        
        
        
        
    }else if ([buttonTitle isEqualToString:@"已领取"]) {
        NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php?g=ApiHome&m=Sowing&a=index&uid=%@&rid=%@&rrid=%@",UserDefaults(@"uid"),self.rid,self.rrid1];
        WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
        [wkWebVC loadUrlWithString:str];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wkWebVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
    
    
    
    
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgArray = [NSMutableArray array];
    self.dictALL = [NSMutableDictionary dictionary];
    NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/submitDetails/uid/%@/rrid/%@",self.taskID1,self.rrid1];
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        NSLog(@"%@",response);
        NSDictionary * dict = [[NSDictionary alloc]initWithDictionary:response[@"data"]];
        self.dictALL = [NSMutableDictionary dictionaryWithDictionary:dict];
        for (NSDictionary * dicta in dict[@"img"]) {
            LookModel * model = [LookModel new];
            model.img = dicta[@"photo"];
            model.type = dicta[@"type"];
            [self.imgArray addObject:model];
        }
        [self.MyCollectionView reloadData];
        [self creatView:dict];
        [self createCollectionView:dict];
    } failure:^(NSError *error) {
    } withUrl:str];
}
    
    
    
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationController.navigationBar.barTintColor = CColor(whiteColor);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(blackColor)};
}
    
    
    //左上角返回
- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
- (void)createCollectionView:(NSDictionary *)dict {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //self.MyCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];

    
    self.MyCollectionView.delegate = self;
    
    self.MyCollectionView.dataSource = self;
    
    self.MyCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.MyCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.MyCollectionView.showsVerticalScrollIndicator = NO;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //定义xib文件
    
    [self.MyCollectionView registerNib:[UINib nibWithNibName:@"IndexCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"IndexCellID"];
    
    [self.MyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.MyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
}
    
    
#pragma mark  --------UICollectionVIew 的代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count;
}
    
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IndexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    LookModel * model = self.imgArray[indexPath.row];
    [cell.img_pic sd_setImageWithURL:[NSURL URLWithString:model.img]];
    if ([model.type isEqualToString:@"3"]) {
        cell.img_type.hidden = NO;
    }else {
        cell.img_type.hidden = YES;
    }
    return cell;
}
    
    
    
    //设置尾部视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 80);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 80);
}
    
    
    //添加尾部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        
        self.checkView = [UIView new];
        _checkView.backgroundColor = KColor(242, 244, 247);
        [headerView addSubview:_checkView];
        [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerView.mas_top).mas_offset(0);
            make.left.mas_equalTo(headerView.mas_left).mas_offset(0);
            make.right.mas_equalTo(headerView.mas_right).mas_offset(0);
            make.height.mas_offset(50);
        }];
        
        self.lb_check = [UILabel new];
        _lb_check.text = @"审核中";
        _lb_check.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18.f];
        _lb_check.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [_checkView addSubview:_lb_check];
        [_lb_check mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.checkView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.checkView.mas_left).mas_offset(15);
            make.size.mas_offset(CGSizeMake(kScreenW, 25));
        }];
        
        self.lb_renwu = [UILabel new];
        _lb_renwu.text = @"任务图片";
        _lb_renwu.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _lb_renwu.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [headerView addSubview:_lb_renwu];
        [_lb_renwu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.checkView.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(headerView.mas_left).mas_offset(15);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
        self.lb_imgCount = [UILabel new];
        _lb_imgCount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _lb_imgCount.textColor = RGBA(153, 153, 153, 1);//KColor(153, 153, 153);
        [headerView addSubview:_lb_imgCount];
        [_lb_imgCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.checkView.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(self.lb_renwu.mas_right).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KSW - 60, 20));
        }];
        if ([self.dictALL[@"num"] isEqual:[NSNull null]]) {
            self.lb_imgCount.text = @"（该任务需要上传0张图片）";
        } else {
            self.lb_imgCount.text = [NSString stringWithFormat:@"（该任务需要上传%@张图片）",self.dictALL[@"num"]];
        }
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        self.tipsLabel = [UILabel new];
        _tipsLabel.text = @"备注信息";
        _tipsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _tipsLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [footerView addSubview:_tipsLabel];
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(footerView.mas_top).mas_offset(10);
            make.left.mas_equalTo(footerView.mas_left).mas_offset(15);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
        self.lb_beizhu = [UILabel new];
        NSString *labelText = [NSString stringWithFormat:@"%@",self.dictALL[@"remarks"]];
        [self.lb_beizhu setText:labelText];
        [self.lb_beizhu setNumberOfLines:0];
        [self.lb_beizhu sizeToFit];
        _lb_beizhu.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0f];
        _lb_beizhu.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [footerView addSubview:_lb_beizhu];
        [_lb_beizhu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(footerView.mas_left).mas_offset(15);
            make.width.mas_offset(footerView.frame.size.width - 30);
            make.height.mas_offset(40);
        }];
        return footerView;
    }else {
        return nil;
    }
}
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
    
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = (kScreenW -30 - 15)  * 0.25;
    //    CGFloat height = width *50/83 ;
    return CGSizeMake(width, width);
}
    /**选中时的回调*/
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
    
@end
