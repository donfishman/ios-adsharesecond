//
//  AFNetworkTool.h
//  AdShare
//
//  Created by ZLWL on 2018/5/9.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkSucess) (NSDictionary * response);
typedef void(^NetworkFailure) (NSError *error);
typedef void(^SessionPost) (NSData *data);


@interface AFNetworkTool : NSObject

/**
 *  此处用于模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getNetworkDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr;

+(void)postNetworkDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParameters:(NSDictionary *)dict;

+ (void)postNetworkDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParametersString:(NSString *)str;

+ (void)postDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParameters:(NSDictionary *)dict;

+ (void)postDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParametersString:(NSString *)str;

@end
