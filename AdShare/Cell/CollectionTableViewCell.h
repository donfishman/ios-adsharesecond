//
//  CollectionTableViewCell.h
//  AdShare
//
//  Created by ZLWL on 2018/4/25.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CollectionTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagLabelA;

@property (weak, nonatomic) IBOutlet UILabel *tagLabelB;

@property (weak, nonatomic) IBOutlet UILabel *tagLabelC;

@end
