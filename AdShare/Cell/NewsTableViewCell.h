//
//  NewsTableViewCell.h
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface NewsTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *linkBtn;

@end
