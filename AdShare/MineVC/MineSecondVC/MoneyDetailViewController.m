//
//  MoneyDetailViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/26.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "MoneyDetailViewController.h"

@interface MoneyDetailViewController ()<UIScrollViewDelegate>
{
    
    UIView * _view;
    BOOL isClick;
}

/** 保存所有的标题按钮 */
@property (nonatomic,strong) NSMutableArray *titleBtns;


/**内容视图*/
@property (nonatomic,strong)UIScrollView * contentScrollow;

/** 下滑线 */
@property (nonatomic,strong) UIView *lineView;


/** 保存上一次点击的按钮 */
@property (nonatomic,strong) UIButton *preBtn;


@end

@implementation MoneyDetailViewController


- (NSMutableArray *)titleBtns
{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"佣金明细";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    [self setupTitleView];
    [self customScrollview];
    //添加子控制器
    [self addChildCustomViewController];
    // 默认点击下标为0的标题按钮
    [self titleBtnClick:self.titleBtns[0]];
}



- (void)setupTitleView{
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    _view = view;
    _view.backgroundColor = CColor(whiteColor);
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view.bounds.size.height - 1, KScreenWidth, 1)];
    line.backgroundColor = KColor(223, 223, 223);
    [view addSubview:line];
    [self.view addSubview:view];
    
    
    //添加所有的标题按钮
    [self addAllTitleBtns];
    //添加下划线
    [self setupUnderLineView];
}


#pragma mark - 添加下滑线
- (void)setupUnderLineView
{
    // 获取下标为0的标题按钮
    UIButton *titleBtn = self.titleBtns[0];
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = NavColor;
    // 下滑线高度
    CGFloat lineViewH = 2;
    CGFloat y = _view.yj_height - lineViewH;
    lineView.yj_height = lineViewH;
    lineView.yj_y = y;
    // 设置下划线的宽度比文本内容宽度大10
    [titleBtn.titleLabel sizeToFit];
    lineView.yj_width = titleBtn.titleLabel.yj_width + 100;
    lineView.yj_centerX = titleBtn.yj_centerX + 15;
    // 添加到titleView里
    [_view addSubview:lineView];
//    NSLog(@"%@",lineView);
}




- (void)customScrollview {
    UIScrollView * contentScrollow = [[UIScrollView alloc]init];
    self.contentScrollow = contentScrollow;
    contentScrollow.frame = CGRectMake(0, 45, KScreenWidth, KScreenHeight -45);
    // contentScrollow.contentSize = CGSizeMake(SCW, 0);
    [self.view addSubview:contentScrollow];
    contentScrollow.delegate = self;
    contentScrollow.pagingEnabled = YES;
    contentScrollow.bounces = NO;
    contentScrollow.showsHorizontalScrollIndicator = NO;
}


- (void)addChildCustomViewController {
    //第一个
    MoneyInViewController * fristVc = [[MoneyInViewController alloc]init];
    [self addChildViewController:fristVc];
    
    //第二个
    MoneyOutViewController * secondVc = [[MoneyOutViewController alloc]init];
    [self addChildViewController:secondVc];
    
    NSInteger count = self.childViewControllers.count;
    self.contentScrollow.contentSize = CGSizeMake(count * KScreenWidth, 0);
}

- (void)addAllTitleBtns {
    NSArray * titles = @[@"收入",@"支出"];
    CGFloat btnW = _view.bounds.size.width*0.5;
    CGFloat btnH = _view.bounds.size.height;
    for (int i = 0; i < titles.count; i++) {
        UIButton * titleBtn = [[UIButton alloc]init];
        titleBtn.tag = i;
        titleBtn.frame = CGRectMake(i * btnW, 7, btnW, btnH);
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
    
    isClick = YES;
    //    // 判断标题按钮是否重复点击
    //    if (titleBtn == self.preBtn) {
    //        // 重复点击标题按钮，发送通知给帖子控制器，告诉它刷新数据
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"titleBtnRefreshClick" object:nil];
    //    }
    // 1.标题按钮点击三步曲
    self.preBtn.selected = NO;
    titleBtn.selected = YES;
    self.preBtn = titleBtn;
    NSInteger tag = titleBtn.tag;
    // 2.处理下滑线的移动
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.yj_width = titleBtn.titleLabel.yj_width;
        self.lineView.yj_centerX = titleBtn.yj_centerX;
        
        // 3.修改contentScrollView的偏移量,点击标题按钮的时候显示对应子控制器的view
        self.contentScrollow.contentOffset = CGPointMake(tag * KScreenWidth, 0);
    }];
    
    // 添加子控制器的view
    UIViewController *vc = self.childViewControllers[tag];
    // 如果子控制器的view已经添加过了，就不需要再添加了
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(tag * KScreenWidth, 0 , KScreenWidth, KScreenHeight - 64);
    [self.contentScrollow addSubview:vc.view];
    
    
    
}


#pragma mark -- uscrollviewDelegate
//开始拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isClick = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算拖拽的比例
    CGFloat ratio = scrollView.contentOffset.x / scrollView.yj_width;
    // 将整数部分减掉，保留小数部分的比例(控制器比例的范围0~1.0)
    ratio = ratio - self.preBtn.tag;
    
    NSInteger index = scrollView.contentOffset.x / scrollView.yj_width;
    
    
    
    if (isClick) {
        UIButton * titleBtn = self.titleBtns[index];
        
        self.lineView.yj_x = titleBtn.titleLabel.yj_x;
        self.lineView.yj_width = titleBtn.titleLabel.yj_width;
        self.lineView.yj_centerX = titleBtn.yj_centerX;
        isClick = YES;
    }else{
        
//        NSLog(@"ratio = %0.1f",ratio);
        //         设置下划线的centerX
        
        //         self.lineView.yj_centerX = self.preBtn.yj_centerX + ratio * self.preBtn.yj_width;
        //
        //                if (ratio > 0) {
        //                    self.lineView.yj_x = self.preBtn.titleLabel.yj_x;
        //                    self.lineView.yj_width = self.preBtn.yj_centerX + scrollView.contentOffset.x / 5 + 18;
        //                }else{
        //                    self.lineView.yj_x = 18 + scrollView.contentOffset.x / 5;
        //                    self.lineView.yj_width = self.preBtn.yj_centerX - (scrollView.contentOffset.x / 5);
        //                }
        
        
        if (ratio > 0) {
            self.lineView.yj_x = self.preBtn.titleLabel.yj_x;
            self.lineView.yj_width = self.preBtn.yj_centerX + scrollView.contentOffset.x / 2.5 + 15;
            if (scrollView.contentOffset.x > 180) {
                UIButton * btn = self.titleBtns[1];
                self.lineView.yj_x =  scrollView.contentOffset.x / 2.5 + 15 - self.preBtn.yj_centerX;
                self.lineView.yj_width = (btn.yj_centerX + btn.yj_width) - (scrollView.contentOffset.x / 2.5) - 45;
            }
        }else{
            self.lineView.yj_x = 15 + scrollView.contentOffset.x / 5 ;
            self.lineView.yj_width = self.preBtn.yj_centerX - (scrollView.contentOffset.x / 5);
            if (scrollView.contentOffset.x < 180) {
                UIButton * btn = self.titleBtns[0];
                self.lineView.yj_x = btn.titleLabel.yj_x;
                self.lineView.yj_width  = btn.yj_width + (scrollView.contentOffset.x / 5) - 20;
            }
        }
        
        
        
        
        
    }
}


////滚动的调用，可以实时监控滚动的变化
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger index = scrollView.contentOffset.x / scrollView.yj_width;
//    CGFloat roffset = fmod(scrollView.contentOffset.x, scrollView.yj_width);
//    CGFloat centerX = ((UIButton *)self.titleBtns[index]).yj_centerX;
//    CGFloat nextCenterX = ((UIButton *)self.titleBtns[index+1 >= self.titleBtns.count ? self.titleBtns.count - 1 : index + 1]).yj_centerX;
//    CGFloat gapWidth = fabs(nextCenterX - centerX);
//    CGFloat bOffsetX = (roffset / scrollView.yj_width) * gapWidth;
//    if (bOffsetX < gapWidth / 2) {
//        self.lineView.yj_x = centerX - 7.5;
//        self.lineView.yj_width = bOffsetX * 2 + 15;
//
//    }else {
//        self.lineView.yj_width = (gapWidth - bOffsetX) * 2 + 15;
//
//        self.lineView.yj_x = nextCenterX + 7.5 - self.lineView.yj_width;
//    }
//}


//开始减速的时候调用
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}


//结束拖动的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.yj_width;
    UIButton *titleBtn = self.titleBtns[index];
    
    // 调用标题按钮的点击事件
    [self titleBtnClick:titleBtn];
}


- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
