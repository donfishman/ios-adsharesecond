//
//  TaskListModel.h
//  AdShare
//
//  Created by ZLWL on 2018/5/25.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "JSONModel.h"

@interface TaskListModel : JSONModel

@property (strong, nonatomic) NSString * count_down;
@property (strong, nonatomic) NSString * create_time;
@property (strong, nonatomic) NSString * end_time;
@property (strong, nonatomic) NSString * rid;
@property (strong, nonatomic) NSString * crid;
@property (strong, nonatomic) NSString * min_price;
@property (strong, nonatomic) NSString * max_price;
@property (strong, nonatomic) NSString * thumbnail;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * img_num;

@property (strong, nonatomic) NSArray  * label;


@end
