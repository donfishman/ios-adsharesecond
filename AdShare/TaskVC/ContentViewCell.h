//
//  ContentViewCell.h
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalMiddleViewController.h"
#import "PersonalRightViewController.h"

@protocol PersonLeftGoToDelegateA <NSObject>

-(void)tableViewDidSelectIdA:(NSString*)idStr;

@end

@interface ContentViewCell : UITableViewCell <PersonLeftGoToDelegate,PersonLeftGoToDelegateR>

@property (nonatomic,weak)id<PersonLeftGoToDelegateA> delegate;


//cell注册
+ (void)regisCellForTableView:(UITableView *)tableView;
+ (ContentViewCell *)dequeueCellForTableView:(UITableView *)tableView;
//子控制器是否可以滑动  YES可以滑动
@property (nonatomic, assign) BOOL canScroll;
//外部segment点击更改selectIndex,切换页面
@property (assign, nonatomic) NSInteger selectIndex;

//创建pageViewController
- (void)setPageView:(NSMutableDictionary*)dataDict;
- (void)customPageView;
@end
