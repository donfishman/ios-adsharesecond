//
//  LaunchAdModel.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  广告数据模型
#import "CardModel.h"

@implementation CardModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.cardUrl = dict[@"cardUrl"];
        self.cardName = dict[@"cardName"];
    }
    return self;
}

@end
