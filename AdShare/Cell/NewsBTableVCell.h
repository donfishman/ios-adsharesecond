//
//  NewsBTableVCell.h
//  AdShare
//
//  Created by ZLWL on 2018/7/11.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NewsModel.h"

@class NewsModel;


@interface NewsBTableVCell : BaseTableViewCell

@property (nonatomic, strong) NewsModel *Model;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;





@end
