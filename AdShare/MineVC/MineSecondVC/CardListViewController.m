//
//  CardListViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/25.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "CardListViewController.h"

@interface CardListViewController ()<UITextFieldDelegate,GYZChooseCityDelegate>

@property (nonatomic, strong) UIView *viewA;
@property (nonatomic, strong) UILabel *labelA;
@property (nonatomic, strong) UITextField * textFeildA;

@property (nonatomic, strong) UIView *viewB;
@property (nonatomic, strong) UILabel *labelB;
@property (nonatomic, strong) UITextField * textFeildB;

@property (nonatomic, strong) UIView *viewC;
@property (nonatomic, strong) UILabel *labelC;
@property (nonatomic, strong) UITextField * textFeildC;

@property (nonatomic, strong) UIView *viewD;
@property (nonatomic, strong) UILabel *labelD;
@property (nonatomic, strong) UITextField * textFeildD;

@property (nonatomic, strong) UIView *viewE;
@property (nonatomic, strong) UILabel *labelE;
@property (nonatomic, strong) UITextField * textFeildE;

@property (nonatomic, strong) UIView *viewF;
@property (nonatomic, strong) UILabel *labelF;
@property (nonatomic, strong) UIButton * buttonF;

@property (nonatomic, strong) UIButton * btn;


@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加/修改银行卡";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = TintColor;
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.viewA.hidden = NO;
    self.labelA.hidden = NO;
    self.textFeildA.hidden = NO;
    
    self.viewB.hidden = NO;
    self.labelB.hidden = NO;
    self.textFeildB.hidden = NO;
    
    self.viewC.hidden = NO;
    self.labelC.hidden = NO;
    self.textFeildC.hidden = NO;
    
    self.viewD.hidden = NO;
    self.labelD.hidden = NO;
    self.textFeildD.hidden = NO;
    
    self.viewE.hidden = NO;
    self.labelE.hidden = NO;
    self.textFeildE.hidden = NO;
    
    self.viewF.hidden = NO;
    self.labelF.hidden = NO;
    self.buttonF.hidden = NO;
    
    self.btn.hidden = NO;
}



#pragma mark - 控件懒加载

-(UIView *)viewA {
    if (!_viewA) {
        self.viewA = [UIView new];
        _viewA.backgroundColor = CColor(whiteColor);
        UIView * line = [UIView new];
        line.backgroundColor = KColor(223, 223, 223);
        [_viewA addSubview:line];
        [self.view addSubview:self.viewA];
        [self.viewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 1));
        }];
    }
    return _viewA;
}

-(UILabel *)labelA {
    if (!_labelA) {
        self.labelA = [UILabel new];
        _labelA.text = @"持卡人姓名";
        _labelA.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelA.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewA addSubview:_labelA];
        [_labelA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
    }
    return _labelA;
}

- (UITextField *)textFeildA {
    if (!_textFeildA) {
        self.textFeildA = [UITextField new];
        _textFeildA.backgroundColor = CColor(whiteColor);
        _textFeildA.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textFeildA.userInteractionEnabled = YES;
        _textFeildA.textColor = [UIColor blackColor];
//        _textFeildA.keyboardType = UIKeyboardTypeNumberPad;
        _textFeildA.font = [UIFont systemFontOfSize:15.0];
        _textFeildA.placeholder = @"请输入持卡人姓名";
        [self.viewA addSubview:_textFeildA];
        [_textFeildA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelA.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.viewA.mas_right).mas_offset(-10);
        }];
    }
    return _textFeildA;
}

-(UIView *)viewB {
    if (!_viewB) {
        self.viewB = [UIView new];
        _viewB.backgroundColor = CColor(whiteColor);
        UIView * line = [UIView new];
        line.backgroundColor = KColor(223, 223, 223);
        [_viewB addSubview:line];
        [self.view addSubview:self.viewB];
        [self.viewB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 1));
        }];
    }
    return _viewB;
}

-(UILabel *)labelB {
    if (!_labelB) {
        self.labelB = [UILabel new];
        _labelB.text = @"银行卡号";
        _labelB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelB.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewB addSubview:_labelB];
        [_labelB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
    }
    return _labelB;
}

- (UITextField *)textFeildB {
    if (!_textFeildB) {
        self.textFeildB = [UITextField new];
        _textFeildB.backgroundColor = CColor(whiteColor);
        _textFeildB.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textFeildB.userInteractionEnabled = YES;
        _textFeildB.textColor = [UIColor blackColor];
        _textFeildB.keyboardType = UIKeyboardTypeNumberPad;
        _textFeildB.font = [UIFont systemFontOfSize:15.0];
        _textFeildB.placeholder = @"请输入银行卡号";
        [self.viewB addSubview:_textFeildB];
        [_textFeildB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelB.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.viewB.mas_right).mas_offset(-10);
        }];
    }
    return _textFeildB;
}


-(UIView *)viewF {
    if (!_viewF) {
        self.viewF = [UIView new];
        _viewF.backgroundColor = CColor(whiteColor);
        UIView * line = [UIView new];
        line.backgroundColor = KColor(223, 223, 223);
        [_viewF addSubview:line];
        UIImageView * imView = [UIImageView new];
        imView.backgroundColor = CColor(clearColor);
        [imView setImage:[UIImage imageNamed:@"xuanze"]];
        [_viewF addSubview:imView];
        [self.view addSubview:_viewF];
        [_viewF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewF.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 1));
        }];
        [imView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.viewF.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.viewF.mas_right).mas_equalTo(-15);
            make.size.mas_offset(CGSizeMake(10, 20));
        }];
    }
    return _viewF;
}

-(UILabel *)labelF {
    if (!_labelF) {
        self.labelF = [UILabel new];
        _labelF.text = @"请选择开户行所在城市";
        _labelF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelF.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewF addSubview:_labelF];
        [_labelF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.viewF.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(140, 20));
        }];
    }
    return _labelF;
}

- (UIButton *)buttonF {
    if (!_buttonF) {
        self.buttonF = [UIButton new];
        _buttonF.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_buttonF setTitleColor:NavColor forState:UIControlStateNormal];
        [_buttonF setTitleColor:CColor(grayColor) forState:UIControlStateSelected];
        [_buttonF addTarget:self action:@selector(buttonFAction) forControlEvents:UIControlEventTouchDown];
        [self.viewF addSubview:_buttonF];
        [self.buttonF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.viewF.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.labelF.mas_right).mas_offset(0);
            make.right.mas_equalTo(self.viewF.mas_right).mas_offset(-5);
        }];
    }
    return _buttonF;
}

-(UIView *)viewC {
    if (!_viewC) {
        self.viewC = [UIView new];
        _viewC.backgroundColor = CColor(whiteColor);
        UIView * line = [UIView new];
        line.backgroundColor = KColor(223, 223, 223);
        [_viewC addSubview:line];
        [self.view addSubview:self.viewC];
        [self.viewC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewF.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 1));
        }];
    }
    return _viewC;
}

-(UILabel *)labelC {
    if (!_labelC) {
        self.labelC = [UILabel new];
        _labelC.text = @"开户银行";
        _labelC.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelC.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewC addSubview:_labelC];
        [_labelC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.viewC.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
    }
    return _labelC;
}

- (UITextField *)textFeildC {
    if (!_textFeildC) {
        self.textFeildC = [UITextField new];
        _textFeildC.backgroundColor = CColor(whiteColor);
        _textFeildC.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textFeildC.userInteractionEnabled = YES;
        _textFeildC.textColor = [UIColor blackColor];
//        _textFeildC.keyboardType = UIKeyboardTypeNumberPad;
        _textFeildC.font = [UIFont systemFontOfSize:15.0];
        _textFeildC.placeholder = @"请输入开户行";
        [self.viewC addSubview:_textFeildC];
        [_textFeildC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelC.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.viewC.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.viewC.mas_right).mas_offset(-10);
        }];
    }
    return _textFeildC;
}

-(UIView *)viewD {
    if (!_viewD) {
        self.viewD = [UIView new];
        _viewD.backgroundColor = CColor(whiteColor);
        UIView * line = [UIView new];
        line.backgroundColor = KColor(223, 223, 223);
        [_viewD addSubview:line];
        [self.view addSubview:self.viewD];
        [self.viewD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewD.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 1));
        }];
    }
    return _viewD;
}

-(UILabel *)labelD {
    if (!_labelD) {
        self.labelD = [UILabel new];
        _labelD.text = @"开户行支行";
        _labelD.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelD.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewD addSubview:_labelD];
        [_labelD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.viewD.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
    }
    return _labelD;
}

- (UITextField *)textFeildD {
    if (!_textFeildD) {
        self.textFeildD = [UITextField new];
        _textFeildD.backgroundColor = CColor(whiteColor);
        _textFeildD.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textFeildD.userInteractionEnabled = YES;
        _textFeildD.textColor = [UIColor blackColor];
//        _textFeildD.keyboardType = UIKeyboardTypeNumberPad;
        _textFeildD.font = [UIFont systemFontOfSize:15.0];
        _textFeildD.placeholder = @"请输入开户行支行（如中关村支行）";
        [self.viewD addSubview:_textFeildD];
        [_textFeildD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelD.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.viewD.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.viewD.mas_right).mas_offset(-10);
        }];
    }
    return _textFeildD;
}

-(UIView *)viewE {
    if (!_viewE) {
        self.viewE = [UIView new];
        _viewE.backgroundColor = CColor(whiteColor);
        UIView * line = [UIView new];
        line.backgroundColor = KColor(223, 223, 223);
        [_viewE addSubview:line];
        [self.view addSubview:self.viewE];
        [self.viewE mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewD.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewE.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 1));
        }];
    }
    return _viewE;
}

-(UILabel *)labelE {
    if (!_labelE) {
        self.labelE = [UILabel new];
        _labelE.text = @"身份证号";
        _labelE.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelE.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewE addSubview:_labelE];
        [_labelE mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.centerY.mas_equalTo(self.viewE.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(70, 20));
        }];
    }
    return _labelE;
}

- (UITextField *)textFeildE {
    if (!_textFeildE) {
        self.textFeildE = [UITextField new];
        _textFeildE.backgroundColor = CColor(whiteColor);
        _textFeildE.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textFeildE.userInteractionEnabled = YES;
        _textFeildE.textColor = [UIColor blackColor];
        _textFeildE.keyboardType = UIKeyboardTypeNumberPad;
        _textFeildE.font = [UIFont systemFontOfSize:15.0];
        _textFeildE.placeholder = @"请输入持卡人身份证号";
        [self.viewE addSubview:_textFeildE];
        [_textFeildE mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelE.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.viewE.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.viewE.mas_right).mas_offset(-10);
        }];
    }
    return _textFeildE;
}





- (UIButton *)btn {
    if (!_btn) {
        self.btn = [UIButton new];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(addOrEdit) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewE.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
}

- (void)addOrEdit {
    ;
    if (UserDefaults(@"FeeName") == nil) {
        [self uploadBangCard];
    }else {
        [self editBankCard];
    }
}

- (void)editBankCard {
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           UserDefaults(@"BankCardID"),@"id",
                           @"0",@"type",
                           self.textFeildA.text,@"name",
                           self.textFeildB.text,@"bank_card",
                           self.labelF.text,@"address",
                           self.textFeildC.text,@"kh_bank",
                           self.textFeildD.text,@"kh_other_bank",
                           self.textFeildE.text,@"identity", nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSLog(@"%@",response);
        NSLog(@"%@",response[@"msg"]);
        if ([response[@"code"] isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"bank_card"] forKey:@"bank_card"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"kh_bank"] forKey:@"kh_bank"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"name"] forKey:@"FeeName"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"id"] forKey:@"BankCardID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBankCard" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/BankManage/doEdit" withParameters:dict];
}

- (void)uploadBangCard {
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           UserDefaults(@"uid"),@"uid",
                           @"0",@"type",
                           self.textFeildA.text,@"name",
                           self.textFeildB.text,@"bank_card",
                           self.labelF.text,@"address",
                           self.textFeildC.text,@"kh_bank",
                           self.textFeildD.text,@"kh_other_bank",
                           self.textFeildE.text,@"identity", nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSLog(@"%@",response);
        NSLog(@"%@",response[@"msg"]);
        if ([response[@"code"] isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"bank_card"] forKey:@"bank_card"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"kh_bank"] forKey:@"kh_bank"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"name"] forKey:@"FeeName"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"id"] forKey:@"BankCardID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBankCard" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/BankManage/addComment" withParameters:dict];
}



#pragma mark - 点击事件
- (void)buttonFAction {
    [self onClickChooseCity];
}

#pragma mark - 定位模块
- (void)onClickChooseCity {
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    cityPickerVC.locationCityID = nil;
    cityPickerVC.commonCitys = nil;        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000",@"200010000",@"300110000"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

#pragma mark - GYZCityPickerDelegate
- (void)cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city {
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        self.labelF.text = [NSString stringWithFormat:@"%@",city.cityName];
    }];
}

- (void)cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController {
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFiled代理方法

//开始编辑页面上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat offset = self.view.bounds.size.height - (textField.frame.origin.y + textField.frame.size.height + 217 + 60);
//    NSLog(@"%f",offset);
    if (offset <=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

//停止编辑页面回到原位置
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textfieldDone:(id)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textFeildA resignFirstResponder];
    [self.textFeildB resignFirstResponder];
    [self.textFeildC resignFirstResponder];
    [self.textFeildD resignFirstResponder];
    [self.textFeildE resignFirstResponder];
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
