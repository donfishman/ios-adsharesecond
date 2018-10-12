//
//  PersonalRightViewController.h
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@protocol PersonLeftGoToDelegateR <NSObject>
-(void)tableViewDidSelectId:(NSString*)idStr;
@end
@interface PersonalRightViewController : BaseTableViewController
@property (strong, nonatomic) NSArray *dataSoureR;
@property (nonatomic,weak)id<PersonLeftGoToDelegateR> delegate;
@end
