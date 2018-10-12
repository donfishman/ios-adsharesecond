//
//  TopTitleView.h
//  AdShare
//
//  Created by work on 2018/10/11.
//  Copyright © 2018 YAND. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonClickBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface TopTitleView : UIView

@property(nonatomic,copy)buttonClickBlock block;

-(instancetype)initWithFrame:(CGRect)frame Params:(NSArray *)params;

-(void)scrolling:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
