//
//  TaskListTableViewCell.h
//  AdShare
//
//  Created by ZLWL on 2018/5/8.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TimeLabel.h"

@interface TaskListTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *bigTitile;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabelA;
@property (weak, nonatomic) IBOutlet UILabel *tagLabelB;
@property (weak, nonatomic) IBOutlet UILabel *tagLabelC;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UILabel *taskType;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end
