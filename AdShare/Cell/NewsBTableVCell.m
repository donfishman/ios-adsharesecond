//
//  NewsBTableVCell.m
//  AdShare
//
//  Created by ZLWL on 2018/7/11.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "NewsBTableVCell.h"

@implementation NewsBTableVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *superView = self.contentView;
        [self.contentView addSubview:self.titleLabel];
        //需要注意的是，使用这个自适应高度的三方，不要在layoutSubviews中设置约束。
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(superView.mas_left).offset(15);
            make.top.mas_equalTo(superView.mas_top).offset(15);
            make.right.mas_equalTo(superView.mas_right).offset(-KSW * 0.5);
            make.height.mas_offset(21);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
            make.top.mas_equalTo(superView.mas_top).offset(15);
            make.right.mas_equalTo(superView.mas_right).offset(-35);
            make.height.mas_offset(21);
        }];
        
        [self.contentView addSubview:self.subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(superView.mas_left).offset(15);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(superView.mas_right).offset(-15);
            make.bottom.mas_equalTo(superView.mas_bottom).offset(-10);
        }];
    }
    return self;
    
}

-(void)setModel:(NewsModel *)model{
    _Model = model;
    if (model.title == nil) {
        self.titleLabel.text = @"系统提醒";
    }else {
        self.titleLabel.text = model.title;
    }
    self.subTitleLabel.text = model.content;
    
    self.timeLabel.text = [YANDTools timeStampWithTimeStr:model.create_time];
}

//使用Masonry需要实现这个方法，下面加的10是因为label距离上面为5，距离下面为5，需要加上10.
- (CGSize)sizeThatFits:(CGSize)size{
    
    CGFloat cellHeight = 0;
    //如果有其他控件，也如法炮制。
    cellHeight += [self.titleLabel sizeThatFits:size].height;
    cellHeight += [self.subTitleLabel sizeThatFits:size].height;
    //这是计算各个控件之间的间隙。
    cellHeight += 20;
    return CGSizeMake(size.width, cellHeight);
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = 0;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.backgroundColor = [UIColor blueColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = 0;
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = KColor(191, 191, 191);
//        _timeLabel.backgroundColor = [UIColor yellowColor];
    }
    return _timeLabel;
}


- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textAlignment = 0;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = KColor(128, 128, 128);
        //        _subTitleLabel.backgroundColor = [UIColor greenColor];
    }
    return _subTitleLabel;
}












@end
