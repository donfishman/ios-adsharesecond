//
//  AboutMine.m
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "AboutMine.h"

@interface AboutMine ()

@property (strong, nonatomic) UILabel * labelOne;

@end

@implementation AboutMine

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.labelOne.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction:)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        NSString * str = response[@"content"][@"content"];
        self.labelOne.text = [NSString stringWithString:str];
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Task/viewmysafe"];
    
}

- (void)backBtnAction: (id)send {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UILabel *)labelOne {
    if (!_labelOne) {
        self.labelOne = [UILabel new];
        _labelOne.font = [UIFont systemFontOfSize:14];
        _labelOne.backgroundColor = CColor(clearColor);
        _labelOne.numberOfLines = 0;
        [self.view addSubview:_labelOne];
        [_labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).mas_offset(15);
            make.top.mas_equalTo(self.view).mas_offset(15);
            make.right.mas_equalTo(self.view).mas_offset(-15);
//            make.height.mas_equalTo(200);
        }];
    }
    return _labelOne;
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
