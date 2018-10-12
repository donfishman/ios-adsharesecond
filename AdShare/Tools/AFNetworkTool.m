//
//  AFNetworkTool.m
//  AdShare
//
//  Created by ZLWL on 2018/5/9.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "AFNetworkTool.h"

@implementation AFNetworkTool

#pragma mark --  使用单例、GCD一次创建
+ (AFNetworkTool *)sharedManager
{
    static AFNetworkTool *af=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af=[[AFNetworkTool alloc]init];
    });
    return af;
}


+ (void)getNetworkDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr {

    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
    [afHttpSessionManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"get success:%@",responseObject);
        //回调是在主线程中，可以直接更新UI
        NSLog(@"%@", [NSThread currentThread]);
        if(success) success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get failure:%@",error);

    }];
}

+ (void)postNetworkDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParameters:(NSDictionary *)dict {
    
    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [afHttpSessionManager setSecurityPolicy:securityPolicy];
    afHttpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    afHttpSessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    afHttpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    afHttpSessionManager.requestSerializer= [AFHTTPRequestSerializer serializer];
    [afHttpSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"If-None-Match"];

    [afHttpSessionManager POST:urlStr parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"get success:%@",responseObject);
        //回调是在主线程中，可以直接更新UI
        NSLog(@"%@", [NSThread currentThread]);
        if(success) success(responseObject);
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get failure:%@",error);
    }];
}

+ (void)postNetworkDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParametersString:(NSString *)str {
    
    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];

    [afHttpSessionManager POST:urlStr parameters:str progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"get success:%@",responseObject);
        //回调是在主线程中，可以直接更新UI
        NSLog(@"%@", [NSThread currentThread]);
        if(success) success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get failure:%@",error);
    }];
}



+ (void)postDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParameters:(NSDictionary *)dict {
    
    AFHTTPSessionManager * afHttpSessionManager = [AFHTTPSessionManager manager];

    [afHttpSessionManager POST:urlStr parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"get success:%@",responseObject);
        //回调是在主线程中，可以直接更新UI
        NSLog(@"%@", [NSThread currentThread]);
        if(success) success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get failure:%@",error);
    }];
}

+ (void)postDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure withUrl:(NSString *)urlStr withParametersString:(NSString *)str {
    
    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
    
    [afHttpSessionManager POST:urlStr parameters:str progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"get success:%@",responseObject);
        //回调是在主线程中，可以直接更新UI
        NSLog(@"%@", [NSThread currentThread]);
        if(success) success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get failure:%@",error);
    }];
}



@end
