//
//  EmptyStateView.h
//  Join
//
//  Created by JOIN iOS on 2018/1/6.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**点击按钮的回调*/
typedef void(^TapButtonAction)();
/**点击背景的回调*/
typedef void(^TapBackgroundAction)();

@interface EmptyStateView : UIView


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
       withBackgroundAction:(TapBackgroundAction)bgdBlock;

@end

