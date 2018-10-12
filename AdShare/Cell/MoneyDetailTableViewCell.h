//
//  MoneyDetailTableViewCell.h
//  AdShare
//
//  Created by ZLWL on 2018/4/26.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MoneyDetailTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleText;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *price;
@end
