//
//  EmptyStateView.m
//  Join
//
//  Created by JOIN iOS on 2018/1/6.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import "EmptyStateView.h"
#import <Masonry.h>
#import "UIKit+BaseExtension.h"
@interface EmptyStateView ()

@property (copy, nonatomic) TapButtonAction tapBtnBlock;
@property (copy, nonatomic) TapBackgroundAction tapBgdBlock;
@property (assign, nonatomic) int typeIndex;

@end

@implementation EmptyStateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 空数据类型展示

 @param emptyType 造成空数据的类型(负数时如果存在则删除，正数时根据下标查找展示的内容并进行显示)
 @param sView superView
 @param btnBlock 点击按钮的回调
 @param bgdBlock 点击背景的回调
*/
+ (void)customEmptyViewType:(int)emptyType
              withSuperView:(UIView *)sView
           withButtonAction:(TapButtonAction)btnBlock
       withBackgroundAction:(TapBackgroundAction)bgdBlock {
    
    //查询sView上是否已经有该view了
    EmptyStateView *eView;
    BOOL isExist = NO;//记录在sView是否已经存在eView，避免重复addSubview
    for (UIView *view in sView.subviews) {
        if ([view isKindOfClass:[EmptyStateView class]]) {
            eView = (EmptyStateView *)view;
            isExist = YES;
            break;
        }
    }
    if (emptyType < 0) {//如果type为负数，则删除显示
        if (eView) {
            [eView removeFromSuperview];
            eView = nil;
        }
        return;
    }
    
    if (eView) {
        if (eView.typeIndex == emptyType) {//如果已经存在并且状态没有改变，则不需要重新创建子视图
            return;
        }
        //如果已经存在但是状态改变了，则重新创建子视图
        [eView removeAllSubviews];
    } else {
        //如果不存在  则创建
        eView = [[EmptyStateView alloc] initWithFrame:CGRectMake(0, 0, sView.width, sView.height)];
        eView.backgroundColor = [UIColor clearColor];
    }

    eView.backgroundColor = UIColorFromRGB(0xF2F4F7);
    eView.tapBtnBlock = btnBlock;//点击按钮的回调
    eView.tapBgdBlock = bgdBlock;//点击背景的回调
    eView.typeIndex = emptyType;//记录状态，用于第二次创建做判断是否重新创建子视图
    
    //根据状态emptyType取出子视图要显示的内容
    NSDictionary *typeObject = [EmptyStateView getEmptyViewType:emptyType];
    
    if (typeObject[@"color"]) {
        eView.backgroundColor = typeObject[@"color"];
    }
    CGFloat topSpace = -44;
    if (typeObject[@"topSpace"]) {
        NSNumber * space  = typeObject[@"topSpace"];
        topSpace = space.floatValue;
    }
    
    //子视图的背景view
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:eView action:@selector(didTapBackgroundAction)];
    [bgView addGestureRecognizer:tap];
    [eView addSubview:bgView];
    [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(eView);
        make.centerY.equalTo(eView.mas_centerY).offset(topSpace);
        make.width.mas_equalTo(eView.frame.size.width - 26.0*2);
    }];
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:typeObject[@"image"]];
    [bgView addSubview:imgView];
    [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(0);
        make.centerX.equalTo(bgView);
        make.height.mas_equalTo(imgView.image ? imgView.image.size.height : 0.f);
    }];

    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = UIColorFromRGB(0xC2C2C2);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = typeObject[@"content"];
    label.numberOfLines = 0;
    [bgView addSubview:label];
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(imgView.image ? 10.0 : 0.f);
        make.left.equalTo(bgView.mas_left).offset (0);
        make.right.equalTo(bgView.mas_right).offset(0);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (typeObject[@"button"]) {
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn setTitle:typeObject[@"button"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:eView action:@selector(didButtonAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 2.0;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor redColor];
    }
    [bgView addSubview:btn];
    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(typeObject[@"button"] ? 10.0 : 0.f);
        make.height.mas_equalTo(typeObject[@"button"] ? 36.0 : 0.f);
        make.width.mas_equalTo(126.0f);
        make.bottom.equalTo(bgView.mas_bottom).offset(0);
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
    }];
    
    if (!isExist) {//如果不存在 则addSubview
        [sView addSubview:eView];
    }
}

- (void)didButtonAction {
    if (self.tapBtnBlock) {
        self.tapBtnBlock();
    }
}

- (void)didTapBackgroundAction {
    if (self.tapBgdBlock) {
        self.tapBgdBlock();
    }
}

/**
 获取显示内容
 示例说明：
    分三个字段 content、image-图片的名字字符串、button-按钮的文案、color-UIColor对象、topSpace-整体向上偏移多少(默认向上偏移44)
    例如：
        @{@"content":xxx} - 就是纯文字展示
        @{@"content":xxx,@"image":xxx} - 就是图片和文字的结合展示(图片在上，文案在下)
        @{@"content":xxx,@"image:xxx,@"button":@"按钮上的文案"} - 图片 文字 按钮的结合展示(图片在上 文案居中 按钮在下)
    有几个字段就显示几个，但是同一个字段只能有一个
 */
+ (NSDictionary *)getEmptyViewType:(NSInteger)type {
    
    NSArray *typeArray = @[
                           @{@"content":@"搜索不到相关内容，换个关键词吧",@"image":@"img_search_blank"},
                             
                           @{ @"content":@"暂时没有相关内容",@"image":@"img_task_blank"
                             } ,
                           @{ @"content":@"暂无相关记录",@"image":@"img_task_blank"
                              }
                          
                           ];
    
    return typeArray[type];
}


@end
