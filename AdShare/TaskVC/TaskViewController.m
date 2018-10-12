//
//  TaskViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/23.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController ()<GYZChooseCityDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView * _view;
    BOOL isClick;
}

@property (nonatomic, strong) NSMutableArray *dataSoure;

@property (nonatomic, strong) UITableView *tableView;
/** 保存所有的标题按钮 */
@property (nonatomic,strong) NSMutableArray *titleBtns;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *locationStr;

@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, strong) UIButton *chooseCityBtn;

@property (nonatomic, strong) NSString * listOneTag;

@property (nonatomic, strong) NSString * listTwoTag;

@property (nonatomic, strong) UIView *menuList;

@property (nonatomic, strong) NSMutableArray *typeSoure;

@property (nonatomic, strong) NSMutableDictionary *upLoadDict;



@end

@implementation TaskViewController

//- (NSMutableDictionary *)upLoadDict {
//    if (!_upLoadDict) {
//        _upLoadDict = [NSMutableDictionary new];
////        _upLoadDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"type",@"0",@"xu",@"北京市",@"area",UserDefaults(@"uid"),@"uid",  nil];
//    }
//    return _upLoadDict;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    _upLoadDict = [NSMutableDictionary new];

    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(whiteColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    
    self.typeSoure = [NSMutableArray array];
    UIButton * deviceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [deviceBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [deviceBtn setTintColor:CColor(whiteColor)];
    [deviceBtn addTarget:self action:@selector(pushSearchVC) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:deviceBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
  
    
    self.chooseCityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.chooseCityBtn.frame = CGRectMake(0, 0, 60, 40);
    [self.chooseCityBtn setTitle:UserDefaults(@"cityStr") forState:UIControlStateNormal];
    self.chooseCityBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.chooseCityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.chooseCityBtn setTintColor:CColor(whiteColor)];
    [self.chooseCityBtn addTarget:self action:@selector(onClickChooseCity) forControlEvents:UIControlEventTouchDown];
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [vie addSubview:self.chooseCityBtn];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:vie];
    self.navigationItem.leftBarButtonItem = leftBar;
    self.menuList.hidden = NO;
    self.dataSoure = [[NSMutableArray alloc]init];
    [self locationManager];
    [self startLocaition];
    [self initTableView];
    self.listOneTag = @"0";
    self.listTwoTag = @"0";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(whiteColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [self loadFenLeiArray];
//    [self downLoadDataWithType:@"0" withPaiXu:@"0" withAreaStr:UserDefaults(@"cityStr")];
    [self downLoadDataWithType:self.listOneTag withPaiXu:self.listTwoTag withAreaStr:UserDefaults(@"cityStr")];

}

- (void)loadFenLeiArray {
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        [self.typeSoure removeAllObjects];
        NSArray *array = response[@"content"];
        for (NSDictionary * dict in array) {
            TypeModel * model = [TypeModel new];
            model.typeStr = dict[@"name"];
            model.typeId = dict[@"id"];
            [self.typeSoure addObject:model.typeStr];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Index/types"];
}

- (UIView *)menuList {
    if (!_menuList) {
        self.menuList = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSW, 40)];
        // 推荐将`MenuListView`设置为tableView的第一组的组头视图
        UIImage *defImg = [UIImage imageNamed:@"gc_navi_arrow_down"];
        UIImage *selImg = [UIImage imageNamed:@"gc_navi_arrow_up"];
        CGRect frame = CGRectMake(0.f, 0.f, kS_W, 40.f);
        NSArray *titles = @[@"全部分类", @"智能排序"];
        MenuListView *menu = [[MenuListView alloc] initWithFrame:frame Titles:titles defImage:defImg selImage:selImg];
        
        __weak typeof (menu)weakMenu = menu;
        menu.clickMenuButton = ^(MenuButton *button, NSInteger index, BOOL selected){
//            NSLog(@"点击了第 %ld 个按钮，选中还是取消？:%d", index, selected);
            if (index == 0) {
                weakMenu.dataSource = self.typeSoure;
            }
            else if (index == 1) {
                weakMenu.dataSource = @[@"智能排序",@"酬劳最高",@"最新上线",@"首字母升序",@"首字母降序"];
            }
        };
        // 选中下拉列表某行时的回调（这个回调方法请务必实现！）
//            __weak typeof (self)weakSelf = self;
        menu.clickListView = ^(NSInteger index, NSString *title){
//            NSLog(@"选中了：%ld   标题：%@", index, title);
            [self.dataSoure removeAllObjects];
            [self aaaaaaaaaa:title withIndex:index];
        };
        [self.menuList addSubview:menu];
        [self.view addSubview:_menuList];
    }
    return _menuList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (void)aaaaaaaaaa:(NSString *)title withIndex:(NSInteger)index {
    NSArray *arrx = self.typeSoure;
    NSArray *arry = @[@"智能排序",@"酬劳最高",@"最新上线",@"首字母升序",@"首字母降序"];
    if ([arrx containsObject:title]) {
        self.listOneTag = [NSString stringWithFormat:@"%ld",index];
    }
    else if ([arry containsObject:title]) {
        self.listTwoTag = [NSString stringWithFormat:@"%ld",index];
    }
    [self downLoadDataWithType:self.listOneTag withPaiXu:self.listTwoTag withAreaStr:UserDefaults(@"cityStr")];
}


- (void)downLoadDataWithType:(NSString *)type withPaiXu:(NSString *)paixu withAreaStr:(NSString *)area {
    WS(weakSelf);
    [_upLoadDict setObject:type forKey:@"type"];
    [_upLoadDict setObject:paixu forKey:@"xu"];
    [_upLoadDict setObject:area forKey:@"area"];
    if (UserDefaults(@"uid") != nil) {
        [_upLoadDict setObject:UserDefaults(@"uid") forKey:@"uid"];
    }
    NSLog(@"%@",_upLoadDict);

    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        if (self.dataSoure != nil) {
            [self.dataSoure removeAllObjects];
        }
        NSArray * arrOver = response[@"complete"];
        NSArray * arrIng = response[@"conduct"];
        NSArray * arrNO = response[@"whole"];
        if (arrIng.count > 0) {
            for (NSDictionary * dictIng in arrIng) {
                TaskModel * model = [TaskModel new];
                model.idA = dictIng[@"id"];
                model.name = dictIng[@"name"];
                model.thumbnail = dictIng[@"thumbnail"];
                model.min_price = dictIng[@"min_price"];
                model.max_price = dictIng[@"max_price"];
                model.label = dictIng[@"label"];
                model.isIng = @"1";
                [self.dataSoure addObject:model];
            }
        }
        if (arrNO.count > 0) {
            for (NSDictionary * dictNO in arrNO) {
                TaskModel * model = [TaskModel new];
                model.idA = dictNO[@"id"];
                model.name = dictNO[@"name"];
                model.thumbnail = dictNO[@"thumbnail"];
                model.min_price = dictNO[@"min_price"];
                model.max_price = dictNO[@"max_price"];
                model.label = dictNO[@"label"];
                model.isIng = @"0";
                [self.dataSoure addObject:model];
            }
        }
        if (arrOver.count > 0) {
            for (NSDictionary * dictOver in arrOver) {
                TaskModel * model = [TaskModel new];
                model.idA = dictOver[@"id"];
                model.name = dictOver[@"name"];
                model.thumbnail = dictOver[@"thumbnail"];
                model.min_price = dictOver[@"min_price"];
                model.max_price = dictOver[@"max_price"];
                model.label = dictOver[@"label"];
                model.isIng = @"10";
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

    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Index/index" withParameters:_upLoadDict];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menuList.frame.size.height, KScreenWidth, KScreenHeight - 64 - self.menuList.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = CColor(whiteColor);
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    TaskModel * model = self.dataSoure[indexPath.row];
    cell.lb_name.text = model.name;
    [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    NSString * str = [NSString stringWithFormat:@"￥%@-%@",model.min_price,model.max_price];
    NSString * strA = [str stringByReplacingOccurrencesOfString:@".00"withString:@""];
    cell.moneyLabel.text = strA;

    NSString * isING = [NSString stringWithFormat:@"%@",model.isIng];
    NSLog(@"model.ising = %@",model.isIng);
    if ([isING isEqualToString:@"0"]) {
        cell.isIng.hidden = YES;
        cell.lb_name.textColor = CColor(blackColor);
    }
    else if ([isING isEqualToString:@"10"])
    {
        cell.isIng.hidden = NO;
        cell.isIng.text = @"已完成";
        cell.lb_name.textColor = CColor(blackColor);
//        cell.userInteractionEnabled = NO;
        cell.backgroundColor = CColor(grayColor);
    }
    else if ([isING isEqualToString:@"1"]) {
        cell.isIng.hidden = NO;
        cell.isIng.text = @"进行中...";
        cell.lb_name.textColor = NavColor;
    }
    
    
    
    if (model.label.count == 1)
    {
        if ([model.label[0] isEqual:[NSNull null]]) {
            
        } else {
            cell.tagLabelA.text = model.label[0];
            cell.tagLabelA.hidden = NO;
            cell.tagLabelB.hidden = YES;
            cell.tagLabelC.hidden = YES;
        }
    }
    else if (model.label.count == 2){
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelA.hidden = NO;
        cell.tagLabelB.hidden = NO;
        cell.tagLabelC.hidden = YES;
    }
    else if (model.label.count == 3) {
        cell.tagLabelA.hidden = NO;
        cell.tagLabelB.hidden = NO;
        cell.tagLabelC.hidden = NO;
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    else if (model.label.count > 3) {
        cell.tagLabelA.hidden = NO;
        cell.tagLabelB.hidden = NO;
        cell.tagLabelC.hidden = NO;
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    
    cell.backgroundColor = CColor(whiteColor);
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskModel * model = self.dataSoure[indexPath.row];
    PersonalCenterController *ctrl = [PersonalCenterController new];
    [ctrl loadDataWithTaskID:model.idA];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)pushSearchVC {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[SearchViewController new] animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 定位模块
- (void)onClickChooseCity {
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    cityPickerVC.locationCityID = nil;
    cityPickerVC.commonCitys = nil;        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000",@"200010000",@"300110000"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

#pragma mark - GYZCityPickerDelegate
- (void)cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city {
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        [self.chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:city.cityName forKey:@"cityStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self downLoadDataWithType:self.listOneTag withPaiXu:self.listTwoTag withAreaStr:UserDefaults(@"cityStr")];
    }];
}

- (void)cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController {
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 定位方法
- (void)startLocaition {
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        // 开始定位
        [self.locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
        [self.locationManager startUpdatingLocation];
    } else {
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
//        NSLog(@"定位失败，请打开定位");
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSLog(@"%@",locations);
    //    "<+40.04104531,+116.43421232> +/- 1414.00m (speed -1.00 mps / course -1.00) @ 2018/4/12, 13:27:47 China Standard Time"
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loc = [locations firstObject];
//    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
//    NSLog(@"%ld",locations.count);
    //将经度显示到label上
    self.longitude = [NSString stringWithFormat:@"%6f", loc.coordinate.longitude];
    //将纬度现实到label上
    self.latitude = [NSString stringWithFormat:@"%6f", loc.coordinate.latitude];
//    NSLog(@"经度：%@",self.longitude);
//    NSLog(@"纬度：%@",self.latitude);
    self.locationStr = [NSString stringWithFormat:@"%@;%@",self.longitude,self.latitude];
//    NSLog(@"经纬度：%@",self.locationStr);
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSString * str = [NSString string];
        for (CLPlacemark *place in placemarks) {
//            NSLog(@"name,%@",place.name);                      // 位置名
//            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
//            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
//            NSLog(@"locality,%@",place.locality);              // 市
//            NSLog(@"subLocality,%@",place.subLocality);        // 区
//            NSLog(@"country,%@",place.country);                // 国家
            str = [NSString stringWithFormat:@"%@",place.locality];
        }
//        [self.chooseCityBtn setTitle:str forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"cityStr"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
}

#pragma mark - 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"定位失败----%@", error);
}

#pragma mark - 定位懒加载
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        //1.创建位置管理器（定位用户的位置）
        self.locationManager = [[CLLocationManager alloc]init];
        //2.设置代理
        self.locationManager.delegate = self;
        // 设置定位精确度到米
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // 设置过滤器为无
        //    self.locationManager.distanceFilter = 1.0;
    }
    return _locationManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    // 推荐将`MenuListView`设置为tableView的第一组的组头视图
//    UIImage *defImg = [UIImage imageNamed:@"gc_navi_arrow_down"];
//    UIImage *selImg = [UIImage imageNamed:@"gc_navi_arrow_up"];
//    CGRect frame = CGRectMake(0.f, 0.f, kS_W, 40.f);
//    NSArray *titles = @[@"全部分类", @"智能排序"];
//    MenuListView *menu = [[MenuListView alloc] initWithFrame:frame Titles:titles defImage:defImg selImage:selImg];
//
//    __weak typeof (menu)weakMenu = menu;
//    menu.clickMenuButton = ^(MenuButton *button, NSInteger index, BOOL selected){
//         NSLog(@"点击了第 %ld 个按钮，选中还是取消？:%d", index, selected);
//        if (index == 0) {
//            weakMenu.dataSource = @[@"全部分类",@"体验",@"搜罗",@"监察",@"调研"];
//        }
//        else if (index == 1) {
//            weakMenu.dataSource = @[@"智能排序",@"酬劳最高",@"最新上线",@"首字母升序",@"首字母降序"];
//        }
//    };
//    // 选中下拉列表某行时的回调（这个回调方法请务必实现！）
////    __weak typeof (self)weakSelf = self;
//    menu.clickListView = ^(NSInteger index, NSString *title){
//        NSLog(@"选中了：%ld   标题：%@", index, title);
//        [self aaaaaaaaaa:title withIndex:index];
//    };
//
//    return menu;
//}



/*
 - (void)setupTitleView{
 UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 45)];
 _view = view;
 _view.backgroundColor = CColor(whiteColor);
 UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view.bounds.size.height - 1, KScreenWidth, 1)];
 line.backgroundColor = KColor(223, 223, 223);
 [view addSubview:line];
 [self.view addSubview:view];
 
 
 //添加所有的标题按钮
 [self addAllTitleBtns];
 //添加下划线
 //    [self setupUnderLineView];
 }
 
 - (void)addAllTitleBtns {
 NSArray * titles = @[@"全部分类",@"智能排序"];
 CGFloat btnW = _view.bounds.size.width*0.5;
 CGFloat btnH = _view.bounds.size.height;
 for (int i = 0; i < titles.count; i++) {
 UIButton * titleBtn = [[UIButton alloc]init];
 titleBtn.tag = i;
 titleBtn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
 [titleBtn setTitle:titles[i] forState:UIControlStateNormal];
 //设置文字颜色
 [titleBtn setTitleColor:CColor(blackColor) forState:UIControlStateNormal];
 //设置选中按键的文字颜色
 [titleBtn setTitleColor:KColor(251,112,69) forState:UIControlStateSelected];
 titleBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
 [_view addSubview:titleBtn];
 [self.titleBtns addObject:titleBtn];
 [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchDown];
 }
 }
 - (void)titleBtnClick:(UIButton *)titleBtn{
  
 }
 */
