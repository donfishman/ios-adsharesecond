//
//  UMShareViewController.m
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/8/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import "UMShareViewController.h"
#import <UShareUI/UShareUI.h>
#import "UMShareTypeViewController.h"

static NSString *UMS_NAV_NAME = @"UMS_NAV_NAME";
static NSString *UMS_NAV_ICON = @"UMS_NAV_ICON";
static NSString *UMS_NAV_ICON_SIZE = @"UMS_NAV_ICON_SIZE";
static NSString *UMS_NAV_SELECTOR = @"UMS_NAV_SELECTOR";
static NSString *UMS_NAV_TBL_CELL = @"UMS_NAV_TBL_CELL";

@interface UMShareViewController ()<UMSocialShareMenuViewDelegate>

@end

@implementation UMShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina),
                                               ]];
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}
- (void)showShareViewClick {
    [self showBottomCircleView];
}

- (void)viewWillLayoutSubviews {
    
    CGFloat y = [self viewOffsetY] + 20.f;
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat pad = 20.f;
    
    CGRect viewFrame = self.view.frame;
    CGFloat viewWidth = viewFrame.size.width - 20.f * 4;
    viewWidth /= 2;
    
    CGRect frame;
    frame.origin.x = width / 4.f - viewWidth / 2.f;
    frame.origin.y = y;
    frame.size.width = viewWidth;
    frame.size.height = viewWidth / 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showBottomCircleView
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self runShareWithType:platformType];
    }];
}

- (void)runShareWithType:(UMSocialPlatformType)type
{
    UMShareTypeViewController *VC = [[UMShareTypeViewController alloc] initWithType:type];
    [self presentViewController:VC animated:YES completion:nil];
}


- (UILabel *)labelWithName:(NSString *)name
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 140.f, 33.f)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = name;
    label.textColor = [UIColor colorWithRed:0.f green:0.53f blue:0.86f alpha:1.f];
    return label;
}


#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return defaultSuperView;
}

@end
