//
//  PersonalMiddleViewController.h
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@protocol PersonLeftGoToDelegate <NSObject>

-(void)tableViewDidSelectId:(NSString*)idStr;

@end

@interface PersonalMiddleViewController : BaseTableViewController

@property (strong, nonatomic) NSMutableArray *dataSoureM;

@property (nonatomic,weak)id<PersonLeftGoToDelegate> delegate;

@end
