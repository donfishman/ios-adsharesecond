//
//  YANDTools.h
//  AdShare
//
//  Created by ZLWL on 2018/5/10.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YANDTools : NSObject

+(UIAlertController *)createAlertWithTitle:(NSString *)title message:(NSString *)message preferred:(UIAlertControllerStyle)preferred confirmHandler:(void(^)(UIAlertAction *confirmAction))confirmHandler cancleHandler:(void(^)(UIAlertAction *cancleAction))cancleHandler;

+(UIAlertController *)createAlertWithTitle:(NSString *)title message:(NSString *)message preferred:(UIAlertControllerStyle)preferred confirmHandler:(void(^)(UIAlertAction *confirmAction))confirmHandler;

+(NSString *)zipNSDataWithImage:(UIImage *)sourceImage;

+(NSString *)AAAZipNSDataWithImage:(UIImage *)sourceImage;

+(NSString *)timeStampWithTimeStr:(NSString *)timeStamp;

+(UIImage *)imageToImage:(UIImage *)sourceImage;


@end
