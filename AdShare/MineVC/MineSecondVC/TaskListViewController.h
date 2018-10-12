//
//  TaskListViewController.h
//  AdShare
//
//  Created by ZLWL on 2018/5/8.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BsaeViewController.h"

@interface TaskListViewController : BsaeViewController
{
    int selectindex;
}
@property (nonatomic,assign) NSInteger selectTag;

- (void)loadListData:(NSString *)typeStr;

@end
