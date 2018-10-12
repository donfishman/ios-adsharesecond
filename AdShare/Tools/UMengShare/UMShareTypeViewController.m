//
//  UMShareTypeViewController.m
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/16/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import "UMShareTypeViewController.h"
#import <UShareUI/UShareUI.h>

typedef NS_ENUM(NSUInteger, UMS_SHARE_TYPE)
{
    UMS_SHARE_TYPE_WEB_LINK,
};

@interface UMShareTypeViewController ()

@property (nonatomic, assign) UMSocialPlatformType platform;
@property (nonatomic, strong) NSDictionary *platfomrSupportTypeDict;

@end


@implementation UMShareTypeViewController

- (instancetype)initWithType:(UMSocialPlatformType)type {
    if (self = [super init]) {
        self.platform = type;
        [self initPlatfomrSupportType];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *typeList = self.platfomrSupportTypeDict[@(self.platform)];
    NSLog(@"typeList == %@",typeList);
    
    [self shareWithType:[typeList[0] integerValue]];
    NSLog(@"typeList == %@",typeList[0]);

    NSString *platformName = @"123";
    NSString *iconName = @"456";
    [UMSocialUIUtility configWithPlatformType:self.platform withImageName:&iconName withPlatformName:&platformName];
    self.titleString = [NSString stringWithFormat:@"分享到%@", platformName];
  }

- (void)viewWillLayoutSubviews {

}

- (void)initPlatfomrSupportType {
    self.platfomrSupportTypeDict =
    @{
      @(UMSocialPlatformType_WechatSession): @[@(UMS_SHARE_TYPE_WEB_LINK)],
      
      @(UMSocialPlatformType_WechatTimeLine): @[@(UMS_SHARE_TYPE_WEB_LINK)],
      
      @(UMSocialPlatformType_Sina): @[@(UMS_SHARE_TYPE_WEB_LINK)],
      
      @(UMSocialPlatformType_QQ): @[@(UMS_SHARE_TYPE_WEB_LINK)],
      
      @(UMSocialPlatformType_Qzone): @[@(UMS_SHARE_TYPE_WEB_LINK)],};
}

- (NSString *)typeNameWithType:(UMS_SHARE_TYPE)type {
    switch (type) {
        case UMS_SHARE_TYPE_WEB_LINK:
        {
            return @"网页链接";
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)shareWithType:(UMS_SHARE_TYPE)type {
    switch (type) {
        case UMS_SHARE_TYPE_WEB_LINK:
        {
            [self shareWebPageToPlatformType:self.platform];
        }
        default:
            break;
    }
}

#pragma mark - share type
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString* sUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"ShareUrl"];
    NSString* sTitle = [[NSUserDefaults standardUserDefaults]objectForKey:@"ShareTitle"];
    NSString* sDetail = [[NSUserDefaults standardUserDefaults]objectForKey:@"ShareDetail"];
    NSString* sImage =  [[NSUserDefaults standardUserDefaults]objectForKey:@"ShareImage"];
    
    //创建网页内容对象
    if (UMSocialPlatformType_WechatTimeLine == platformType) {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:sDetail descr:sDetail thumImage:sImage];
        //设置网页地址
        shareObject.webpageUrl = sUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    else {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:sTitle descr:sDetail thumImage:sImage];
        //设置网页地址
        shareObject.webpageUrl = sUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [self alertWithError:error];
        }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
        
        NSString *strA = [[NSUserDefaults standardUserDefaults]objectForKey:@"isHD"];
        if ([strA isEqualToString:@"YES"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshWebView" object:nil];
        }
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"分享没有成功哦"];
            NSLog(@"%d \n %@",(int)error.code,str);
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

@end
