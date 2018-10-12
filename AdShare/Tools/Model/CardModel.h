//
//  LaunchAdModel.h
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  广告数据模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CardModel : NSObject

/**
 *  卡的名字种类
 */
@property (nonatomic, copy) NSString *cardName;

/**
 *  卡的购买连接
 */
@property (nonatomic, copy) NSString *cardUrl;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
