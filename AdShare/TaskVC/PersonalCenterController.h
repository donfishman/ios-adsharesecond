//
//  PersonalCenterController.h
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewCell.h"
@interface PersonalCenterController : UIViewController<PersonLeftGoToDelegateA,PersonLeftGoToDelegateR>

#pragma mark - 数据创建
@property (strong, nonatomic) NSMutableArray *dataSoure;
@property (nonatomic, strong) NSMutableDictionary *dictSoure;
@property (nonatomic, strong) NSMutableDictionary *taskSoure;


//最下任务执行收藏分享UI
@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UIButton *shareBtn;
@property(strong,nonatomic) UIButton *collectBtn;
@property(strong,nonatomic) UIButton *taskActionBtn;
//最下任务执行收藏分享UI over


- (void)loadDataWithTaskID:(NSString *)idStr;


@end
