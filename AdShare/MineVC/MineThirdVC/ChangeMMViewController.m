//
//  ChangeMMViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "ChangeMMViewController.h"

@interface ChangeMMViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *viewA;
@property (nonatomic, strong) UIView *viewB;
@property (nonatomic, strong) UIView *viewC;

@property(nonatomic,strong) UITextField  *passwordOld;
@property(nonatomic,strong) UITextField  *passwordNew;
@property(nonatomic,strong) UITextField  *passwordNewS;

@property (nonatomic, strong) UIButton * btn;


@end

@implementation ChangeMMViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.viewA.hidden = NO;
    self.viewB.hidden = NO;
    self.viewC.hidden = NO;
    
    self.passwordOld.hidden = NO;
    self.passwordNew.hidden = NO;
    self.passwordNewS.hidden = NO;
    
    self.btn.hidden = NO;
}

#pragma mark - 修改密码请求
- (void)changePwdBtnAction {
    if ([_passwordNew.text isEqualToString:@""]||[_passwordNewS.text isEqualToString:@""]||[_passwordOld.text isEqualToString:@""]) {
        UIAlertController *alert = [YANDTools createAlertWithTitle:@"提示" message:@"密码输入不能为空" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self changMMAction];
    }
}
- (void)changMMAction {
    if (_passwordOld.text.length >=6 && _passwordNew.text.length >=6 && _passwordNewS.text.length >=6) {
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:UserDefaults(@"uid"),@"id",_passwordOld.text,@"pwd", _passwordNew.text,@"newpwd",_passwordNewS.text,@"renewpwd", nil];

    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSString *codeStr = response[@"code"];
        if ([codeStr isEqualToString:@"200"]) {
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"密码修改成功" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([self.passwordOld.text isEqualToString:self.passwordNew.text]) {
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"新旧密码相同" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"修改失败" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Login/editpwd/" withParameters:postDict];
        
    }else {
        UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"密码长度必须6位以上" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
        }];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

#pragma mark - 返回上级VC
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_passwordOld endEditing:YES];
    [_passwordNew endEditing:YES];
    [_passwordNewS endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
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
            make.size.mas_offset(CGSizeMake(KScreenWidth, 1));
        }];
    }
    return _viewA;
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
            make.size.mas_offset(CGSizeMake(KScreenWidth, 1));
        }];
    }
    return _viewB;
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
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_bottom).mas_equalTo(-1);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 1));
        }];
    }
    return _viewC;
}

- (UIButton *)btn {
    if (!_btn) {
        self.btn = [UIButton new];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(changePwdBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
}

- (UITextField *)passwordOld {
    if (!_passwordOld) {
        self.passwordOld = [UITextField new];
        _passwordOld.secureTextEntry = YES;
        _passwordOld.background = [UIImage imageNamed:@"login_Register_Bord"];
        _passwordOld.userInteractionEnabled = YES;
        _passwordOld.textColor = [UIColor blackColor];
        _passwordOld.font = [UIFont systemFontOfSize:14];
        _passwordOld.placeholder = @"请输入旧密码";
        [self.view addSubview:_passwordOld];
        [_passwordOld mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewA.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 44));
        }];
    }
    return _passwordOld;
}

- (UITextField *)passwordNew {
    if (!_passwordNew) {
        self.passwordNew = [UITextField new];
        _passwordNew.secureTextEntry = YES;
        _passwordNew.background = [UIImage imageNamed:@"login_Register_Bord"];
        _passwordNew.userInteractionEnabled = YES;
        _passwordNew.textColor = [UIColor blackColor];
        _passwordNew.font = [UIFont systemFontOfSize:14];
        _passwordNew.placeholder = @"请输入新密码";
        [self.view addSubview:_passwordNew];
        [_passwordNew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewB.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 44));
        }];
    }
    return _passwordNew;
}

- (UITextField *)passwordNewS {
    if (!_passwordNewS) {
        self.passwordNewS = [UITextField new];
        _passwordNewS.secureTextEntry = YES;
        _passwordNewS.background = [UIImage imageNamed:@"login_Register_Bord"];
        _passwordNewS.userInteractionEnabled = YES;
        _passwordNewS.textColor = [UIColor blackColor];
        _passwordNewS.font = [UIFont systemFontOfSize:14];
        _passwordNewS.placeholder = @"请确认新密码";
        [self.view addSubview:_passwordNewS];
        [_passwordNewS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewC.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewC.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 44));
        }];
    }
    return _passwordNew;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
