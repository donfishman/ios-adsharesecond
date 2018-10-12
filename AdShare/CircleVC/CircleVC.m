//
//  CircleVC.m
//  AdShare
//
//  Created by work on 2018/10/11.
//  Copyright © 2018 YAND. All rights reserved.
//

#import "CircleVC.h"
#import "TopTitleView.h"

@interface CircleVC () <UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *ScrollView;
@property (strong,nonatomic) TopTitleView *topView;


@end

@implementation CircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"圈子";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutSubviews];
    [self setupScrollView];
    
    
    // Do any additional setup after loading the view.
}




//- (void)showEitingView:(BOOL)isShow {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.editingView.frame = CGRectMake(0, isShow ? KScreenHeight - 158 - 45: KScreenHeight, KScreenWidth, 45);
//    }];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(whiteColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNavItem" object:@"1"];
//    [self loadNewsData:@"1"];
}

- (void)layoutSubviews {
    
    NSArray *params = @[@"最新",@"热点",@"关注"];

    self.topView = [[TopTitleView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44) Params:params];
    [self.view addSubview:self.topView];
    
    __weak typeof(self)weakSelf = self;
    self.topView.block = ^(NSInteger tag) {
        
        CGPoint point = CGPointMake(KScreenWidth * tag, 0);
        
        [weakSelf.ScrollView setContentOffset:point animated:YES];
    };
    
    NSArray *vc_names = @[@"HotViewController",@"FocusViewController",@"MostNewViewController"];
    
    for (int i = 0; i< vc_names.count; i++) {
        
        NSString *vc_name = vc_names[i];
        
        UIViewController *VC = [[NSClassFromString(vc_name) alloc]init];
        
        [self addChildViewController:VC];
    }
}

-(void)setupScrollView
{
    self.ScrollView = [[UIScrollView alloc]init];
    self.ScrollView.delegate = self;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.backgroundColor = CColor(redColor);
    
    self.ScrollView.contentSize = CGSizeMake(KScreenWidth * 3, 0);
    [self.view addSubview:self.ScrollView];
    
    [self.ScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self scrollViewDidEndDecelerating:self.ScrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    CGFloat width = KScreenWidth;
    
    CGFloat offset = scrollView.contentOffset.x;
    
    NSInteger idx = offset / width;
    
#warning 设置topView按钮的联动
    // 设置topView按钮的联动
    [self.topView scrolling:idx];
    
    UIViewController *VC = self.childViewControllers[idx];
    
    if ([VC isViewLoaded]) return;
    
    VC.view.frame = CGRectMake(offset, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    
    [scrollView addSubview:VC.view];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


@end
