//
//  TaskDeatilsView.h
//  AdShare
//
//  Created by ZLWL on 2018/7/6.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDeatilsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageBig;

@property (weak, nonatomic) IBOutlet UIImageView *imageSmall;

@property (weak, nonatomic) IBOutlet UILabel *taskTitle;

@property (weak, nonatomic) IBOutlet UILabel *lb_tagA;

@property (weak, nonatomic) IBOutlet UILabel *lb_tagB;

@property (weak, nonatomic) IBOutlet UILabel *lb_tagC;

@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UILabel *lb_overTime;

@property (weak, nonatomic) IBOutlet UILabel *lb_checkTime;

@property (weak, nonatomic) IBOutlet UIImageView *shenheImg;

@property (weak, nonatomic) IBOutlet UILabel *lb_shenhe;

@property (weak, nonatomic) IBOutlet UILabel *lb_shengyu;

@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

@property (weak, nonatomic) IBOutlet UIView *taskDeatilsV;

@property (weak, nonatomic) IBOutlet UILabel *lb_shengyuTime;


+(instancetype)initHeaderView;

@end
