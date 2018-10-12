//
//  AppDelegate.m
//  AdShare
//
//  Created by ZLWL on 2018/4/23.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "AppDelegate.h"
#import <JPush/JPUSHService.h>
#import "JPUSHService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


static NSString *appKey = @"b863a02984a087ab99f276dd";//（与plist文件里面的相同）
static NSString *channel = @"Publish channel";
//static BOOL isProduction = NO;

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:YES
            advertisingIdentifier:nil];
    

#pragma mark - UMeng设置
    
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a4106f4f43e4836f800000f"];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;


    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动
        [[NSUserDefaults standardUserDefaults] setObject:@"全国" forKey:@"cityStr"];
        [[NSUserDefaults standardUserDefaults] setObject:@"未登陆" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:@"http://139.196.101.133:8085/public/images/headicon.png" forKey:@"imageUrl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        //不是第一次启动了
    }
    [self launchImage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addJpushTags:) name:@"addJpushTags" object:nil];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[DTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    [self didPUSH:launchOptions];
    return YES;
}


- (void)didPUSH:(NSDictionary *)launchOptions {
    NSDictionary* dict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dict) {// 如果通知不为空，则证明收到了推送
        [self push:dict];
    }
    
}

- (void)addJpushTags:(NSNotification *)noti {
    NSString * tel = [NSString stringWithFormat:@"%@",noti.object];
    [JPUSHService setAlias:tel completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
}


- (void)nofiReceivedActonWithOptions:(NSDictionary *)launchOptions {
    if(launchOptions) {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(remoteNotification) {
            NSLog(@"推送过来的消息是%@",remoteNotification);
            //点击推送通知进入指定界面（这个肯定是相当于从后台进入的）
            NSString * returndata  = [launchOptions objectForKey:@"returndata"];
            returndata = [returndata stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            ////字符串转化成NSData数据后，再解析成字典
            NSData *JSONData = [returndata dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            NSMutableDictionary *pushDict=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
            NSLog(@"%@",pushDict);
            
            NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php?g=ApiHome&m=Sowing&a=index&uid=%@&rid=%@&rrid=%@",UserDefaults(@"uid"),pushDict[@"rid"],pushDict[@"rrid"]];
            WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"newsPushDeatil" object:wkWebVC];
            [wkWebVC loadUrlWithString:str];
            UITabBarController *tab = (UITabBarController *)_window.rootViewController;
            UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
            wkWebVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:wkWebVC animated:YES];
        }
    }
}
//使用DeviceToken注册远程通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    //传给极光
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
//将要在手机上推送远程通知 iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

//接收到远程通知 iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {//前台运行时，收到推送的通知会弹出alertview提醒
        NSDictionary*oneDict = [userInfo objectForKey:@"aps"];
        NSString * returndata  = [userInfo objectForKey:@"returndata"];
        returndata = [returndata stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        ////字符串转化成NSData数据后，再解析成字典
        NSData *JSONData = [returndata dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary *pushDict=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
        NSLog(@"%@",pushDict);
        
        
        [self push:pushDict];
        
        
    }
}

//接收到远程通知iOS 7 Support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {//前台运行时，收到推送的通知会弹出alertview提醒
        NSDictionary*oneDict = [userInfo objectForKey:@"aps"];
        NSString * returndata  = [userInfo objectForKey:@"returndata"];
        returndata = [returndata stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        ////字符串转化成NSData数据后，再解析成字典
        NSData *JSONData = [returndata dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary *pushDict=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
        NSLog(@"%@",pushDict);


        [self push:pushDict];
        
        
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {//点击推送通知进入界面的时候
        NSString * returndata  = [userInfo objectForKey:@"returndata"];
        returndata = [returndata stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        ////字符串转化成NSData数据后，再解析成字典
        NSData *JSONData = [returndata dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary *pushDict=[NSMutableDictionary dictionaryWithDictionary:responseJSON];
        NSLog(@"%@",pushDict);
        

    }
}




- (void)push:(NSDictionary *)params {
    if ( [params[@"status"] isEqualToString:@"10"]) {
        // 获取导航控制器
        UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
        UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
        // 跳转到对应的控制器
        [pushClassStance pushViewController:[MoneyDetailViewController new] animated:YES];
    }
}





//接收到远程通知 iOS6.0以下
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self goToMssageViewControllerWith:userInfo];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
}


//图片开屏广告 - 网络数据
-(void)launchImage{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:1.6];
    
    //广告数据请求
    [Network getLaunchAdImageDataSuccess:^(NSDictionary * response) {
//        NSLog(@"广告数据 = %@",response);
        //广告数据转模型
//        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
        //配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = 3;//model.duration;
        //广告frame
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height );
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = response[@"conduct"];//model.content;
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
//        imageAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
        //广告显示完成动画时间
        imageAdconfiguration.showFinishAnimateTime = 0.8;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        
        //图片已缓存 - 显示一个 "已预载" 视图 (可选)
        if([XHLaunchAd checkImageInCacheWithURL:[NSURL URLWithString:response[@"conduct"]]]){
            //设置要添加的自定义视图(可选)
            
        }
        //显示开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms {

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5c92e3d333ef9324" appSecret:@"95b3e76090126153183a4a72a08f616e" redirectURL:nil];

    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101453174"/*设置QQ平台的appID*/  appSecret:@"cb1a9861b0727565fb7db05183f9ceb5" redirectURL:nil];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2196140544"  appSecret:@"4de491953b708111cb3b798cf5216183" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
