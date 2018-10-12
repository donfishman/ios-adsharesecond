//
//  TopTitleView.m
//  AdShare
//
//  Created by work on 2018/10/11.
//  Copyright © 2018 YAND. All rights reserved.
//

#import "TopTitleView.h"

@interface TopTitleView ()

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *selBtn;
@property (nonatomic,strong)NSMutableArray *Buttons;

@end

@implementation TopTitleView

-(NSMutableArray *)Buttons
{
    if (!_Buttons) {
        _Buttons = [[NSMutableArray alloc]init];
    }
    return _Buttons;
}

-(instancetype)initWithFrame:(CGRect)frame Params:(NSArray *)params
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NavColor;

//        NSMutableArray *btnArray = [NSMutableArray array];
        
        CGFloat width = self.yj_width / params.count;
        
        for (int i = 0; i < params.count; i++) {
            
            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Btn.yj_height = 21;
            Btn.yj_width = width;
            Btn.yj_x = i * width;
            Btn.yj_y = 13;
            Btn.tag = 1000+i;
            [Btn setTitle:params[i] forState:UIControlStateNormal];
            [Btn setTitleColor:CColor(whiteColor) forState:UIControlStateNormal];
            [Btn.titleLabel sizeToFit];
            [Btn addTarget:self action:@selector(btn_click_action:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:Btn];
            [self.Buttons addObject:Btn];
            
            if (i == 0&& !_selBtn) {
                Btn.enabled = NO;
                _selBtn = Btn;
                self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 5, _selBtn.titleLabel.yj_width, 2)];
                self.lineView.yj_centerX = _selBtn.yj_centerX;
                self.lineView.backgroundColor = CColor(whiteColor);

            }
        }
                       /*使用masonry实现多个按钮的布局*/
//        [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
//
//        [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_top).mas_offset(13);
//            make.height.mas_equalTo(21);
//        }];
        
        
        
        [self addSubview:self.lineView];
    }
    return self;
}


-(void)btn_click_action:(UIButton *)button
{
    NSInteger idx = button.tag - 1000;
    [self scrolling:idx];

    if (self.block) {
        self.block(idx);
    }
}

-(void)scrolling:(NSInteger)tag
{
    self.selBtn.enabled = YES;
    UIButton *btn = self.Buttons[tag];
    btn.enabled = NO;
    self.selBtn = btn;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.yj_width = btn.titleLabel.yj_width;
        self.lineView.yj_centerX = btn.yj_centerX;
    }];
  
}




@end
