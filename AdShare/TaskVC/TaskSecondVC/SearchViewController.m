//
//  SearchViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/5/17.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) NSMutableArray *dataSoure;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    self.dataSoure = [NSMutableArray array];
    [self CreateSearchBar];
    [self initTableView];
}

-(void)CreateSearchBar{
 
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,KSW - 90,30)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KSW - 90, 30)];
    self.searchBar.placeholder = @"请输入信息";
    self.searchBar.layer.cornerRadius = 5;
    self.searchBar.layer.masksToBounds = YES;
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
//    self.searchBar.backgroundImage = [UIImage imageNamed:@"sexBankgroundImage"];
    // 设置SearchBar的主题颜色
//    self.searchBar.barTintColor = [UIColor colorWithRed:111 green:212 blue:163 alpha:1];
    self.searchBar.barTintColor = CColor(whiteColor);
    //设置背景色
//    self.searchBar.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.1];
    self.searchBar.backgroundColor = CColor(whiteColor);
    // 修改cancel
    self.searchBar.showsCancelButton = NO;
    self.searchBar.barStyle = UIBarStyleDefault;
//    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
    
    self.searchBar.delegate = self;
    // 修改cancel
    self.searchBar.showsSearchResultsButton = NO;
    //5. 设置搜索Icon
    [self.searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    /*这段代码有个特别的地方就是通过KVC获得到UISearchBar的私有变量
     
          searchField（类型为UITextField），设置SearchBar的边框颜色和圆角实际上也就变成了设置searchField的边框颜色和圆角，你可以试试直接设置SearchBar.layer.borderColor和cornerRadius，会发现这样做是有问题的。*/
    
    //一下代码为修改placeholder字体的颜色和大小
    
    UITextField*searchField = [_searchBar valueForKey:@"_searchField"];
    
    //2. 设置圆角和边框颜色
    
    if(searchField) {
                [searchField setBackgroundColor:[UIColor clearColor]];
                //        searchField.layer.borderColor = [UIColor colorWithRed:49/255.0f green:193/255.0f blue:123/255.0f alpha:1].CGColor;
                //        searchField.layer.borderWidth = 1;
                //        searchField.layer.cornerRadius = 23.0f;
                //        searchField.layer.masksToBounds = YES;
                // 根据@"_placeholderLabel.textColor" 找到placeholder的字体颜色
                [searchField setValue:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            }
    // 输入文本颜色
    searchField.textColor= CColor(blackColor);
    searchField.font= [UIFont systemFontOfSize:15];
    // 默认文本大小
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    //只有编辑时出现出现那个叉叉
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [titleView addSubview:self.searchBar];
    //Set to titleView
    self.navigationItem.titleView = titleView;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    return YES;
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//
//}
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    return true;
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    WS(weakSelf);
    [searchBar resignFirstResponder];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.searchBar.text, @"title",UserDefaults(@"uid"),@"uid", nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        
        if (self.dataSoure != nil) {
            [self.dataSoure removeAllObjects];
        }
        NSMutableArray * arrOver = response[@"complete"];
        NSMutableArray * arrIng = response[@"conduct"];
        NSMutableArray * arrNO = response[@"whole"];
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
            [EmptyStateView customEmptyViewType:weakSelf.dataSoure.count ? -1 : 0
                                  withSuperView:weakSelf.tableView
                               withButtonAction:nil
                           withBackgroundAction:nil];
        });
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Index/sele" withParameters:dict];
    
}








- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = NavColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(blackColor)};
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TaskModel * model = self.dataSoure[indexPath.row];
    NSLog(@"%@",model);
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
            
        }else {
            cell.tagLabelA.text = model.label[0];
            cell.tagLabelA.hidden = NO;
            cell.tagLabelB.hidden = YES;
            cell.tagLabelC.hidden = YES;
        }

    }
    else if (model.label.count == 2)
    {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelA.hidden = NO;
        cell.tagLabelB.hidden = NO;
        cell.tagLabelC.hidden = YES;
    }
    else if (model.label.count == 3)
    {
        cell.tagLabelA.hidden = NO;
        cell.tagLabelB.hidden = NO;
        cell.tagLabelC.hidden = NO;
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    else if (model.label.count > 3)
    {
        cell.tagLabelA.hidden = NO;
        cell.tagLabelB.hidden = NO;
        cell.tagLabelC.hidden = NO;
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    
    
    
    
    
    
    cell.backgroundColor = CColor(clearColor);
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
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    TaskModel * model = self.dataSoure[index.row];
    PersonalCenterController * buyVC = [PersonalCenterController new];
    [buyVC loadDataWithTaskID:model.idA];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSoure.count;
}



- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = CColor(whiteColor);
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
//http://git.tolinksoft.com/work/iOS-RecruitS.git
