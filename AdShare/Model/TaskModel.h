//
//  TaskModel.h
//  AdShare
//
//  Created by ZLWL on 2018/5/11.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "JSONModel.h"

@interface TaskModel : JSONModel

@property (strong, nonatomic) NSString * idA;
@property (strong, nonatomic) NSString * ctoDid;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * thumbnail;
@property (strong, nonatomic) NSString * min_price;
@property (strong, nonatomic) NSString * max_price;
@property (strong, nonatomic) NSMutableArray * label;
@property (strong, nonatomic) NSString * isIng;


@end
