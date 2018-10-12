//
//  DTabBarController.m
//  PNHelper
//
//  Created by ZLWL on 2018/3/8.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "DTabBarController.h"
#import "CircleVC.h"


@interface DTabBarController ()

@end

@implementation DTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TaskViewController *homeVC = [[TaskViewController alloc] init];
    [self addChildController:homeVC title:@"任务" imageName:@"tab_renwu_def" selectedImageName:@"tab_renwu_sel" navVc:[UINavigationController class]];
    ShopViewController * shopVC = [[ShopViewController alloc] init];
    [self addChildController:shopVC title:@"商城" imageName:@"tab_renwu_def" selectedImageName:@"tab_renwu_sel" navVc:[UINavigationController class]];
    CircleVC *billVC = [[CircleVC alloc] init];
    [self addChildController:billVC title:@"圈子" imageName:@"tab_xiaoxi_def" selectedImageName:@"tab_quanzi_sel" navVc:[UINavigationController class]];
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addChildController:mineVC title:@"我的" imageName:@"tab_my_def" selectedImageName:@"tab_my_sel" navVc:[UINavigationController class]];
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc {    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:NavColor} forState:UIControlStateSelected];
    
    UINavigationController* nav = [[navVc alloc] initWithRootViewController:childController];
    nav.navigationBar.barTintColor = CColor(whiteColor);
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:NavColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
