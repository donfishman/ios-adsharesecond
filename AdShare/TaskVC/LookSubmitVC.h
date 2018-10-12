//
//  LookSubmitVC.h
//  AdShare
//
//  Created by ZLWL on 2018/7/9.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookSubmitVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UICollectionView *MyCollectionView;
    
@property (nonatomic,strong)NSString *taskID1;
@property (nonatomic,strong)NSString *rrid1;
@property (nonatomic,strong)NSString *rid;
@property (nonatomic,strong)NSString *img_num;
@property (nonatomic,strong)NSString *end_time;

@end
