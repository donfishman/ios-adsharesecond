//
//  NewsModel.h
//  AdShare
//
//  Created by ZLWL on 2018/5/25.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "JSONModel.h"

@interface NewsModel : JSONModel

@property (strong, nonatomic) NSString * rwId;
@property (strong, nonatomic) NSString * rrid;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * rid;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * create_time;
@property (strong, nonatomic) NSString * status;

@end
