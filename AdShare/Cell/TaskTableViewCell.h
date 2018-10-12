//
//  TaskTableViewCell.h
//  AdShare
//
//  Created by ZLWL on 2018/5/7.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TaskTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *isIng;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagLabelA;

@property (weak, nonatomic) IBOutlet UILabel *tagLabelB;

@property (weak, nonatomic) IBOutlet UILabel *tagLabelC;

@end
