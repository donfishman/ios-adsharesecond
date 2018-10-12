//
//  TaskDeatilsView.m
//  AdShare
//
//  Created by ZLWL on 2018/7/6.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "TaskDeatilsView.h"

@implementation TaskDeatilsView

+(instancetype)initHeaderView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"TaskDeatilsView" owner:self options:nil]lastObject];
}

@end
