//
//  TwoViewController.m
//  YTSegmentDemo
//
//  Created by TonyAng on 2018/4/25.
//  Copyright © 2018年 TonyAng. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic)   UITableView* detailTableview;
@property (strong, nonatomic) NSMutableArray *dataSoure;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.dataSoure = [NSMutableArray array];

}


#pragma -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSLog(@"%@",self.dataSoure);
    TaskModel * model = self.dataSoure[indexPath.row];
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
    
    //    cell.backgroundColor = CColor(whiteColor);
    //    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

#pragma -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
