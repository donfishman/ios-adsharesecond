//
//  BsaeViewController.m
//  CityTong
//
//  Created by 闫晓东 on 2018/1/24.
//  Copyright © 2018年 闫晓东. All rights reserved.
//

#import "BsaeViewController.h"

@interface BsaeViewController ()

@end

@implementation BsaeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CColor( whiteColor);
    self.navigationItem.title = @"此页标题还没改~";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(blackColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // 隐藏系统的导航栏分割线
    UIImageView *navigationBarBottomLine = [self _findHairlineImageViewUnder:self.navigationController.navigationBar];
    navigationBarBottomLine.hidden = YES;
    //控制是否显示导航栏
    if ([self isKindOfClass:[MineViewController class]]  ||  [self isKindOfClass:[MineViewController class]])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)_findHairlineImageViewUnder:(UIView *)view{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews){
        UIImageView *imageView = [self _findHairlineImageViewUnder:subview];
        if (imageView){ return imageView; }
    }
    return nil;
}



@end
