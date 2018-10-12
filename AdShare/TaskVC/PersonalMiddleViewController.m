//
//  PersonalMiddleViewController.m
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "PersonalMiddleViewController.h"

@interface PersonalMiddleViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonalMiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"PersonalMiddleViewController---%@",self.dataSoureM);
    return self.dataSoureM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCellID"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSLog(@"%@",self.dataSoureM);
    TaskModel * model = self.dataSoureM[indexPath.row];
    NSLog(@"%@",model);
    cell.lb_name.text = model.name;
    [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    NSString * str = [NSString stringWithFormat:@"￥%@-%@",model.min_price,model.max_price];
    NSString * strA = [str stringByReplacingOccurrencesOfString:@".00"withString:@""];
    cell.moneyLabel.text = strA;
    cell.isIng.hidden = YES;
    if (model.label.count == 1) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.hidden = YES;
        cell.tagLabelC.hidden = YES;
    }
    else if (model.label.count == 2) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.hidden = YES;
    }
    else if (model.label.count == 3) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    else if (model.label.count > 3) {
        cell.tagLabelA.text = model.label[0];
        cell.tagLabelB.text = model.label[1];
        cell.tagLabelC.text = model.label[2];
    }
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskModel * model = self.dataSoureM[indexPath.row];
    if (_delegate) {
        [_delegate tableViewDidSelectId:model.idA];
    }
}



@end
