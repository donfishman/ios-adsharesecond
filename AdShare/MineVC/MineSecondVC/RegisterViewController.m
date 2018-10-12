//
//  RegisterViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/26.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *viewA;
@property (nonatomic, strong) UIView *viewB;
@property (nonatomic, strong) UITextField * codeTxtField;
@property (nonatomic, strong) UITextField * phoneField;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UIButton * codeBtn;

@property (nonatomic, strong) UIView *viewC;
@property (nonatomic, strong) UITextField  *passwordNew;
@property (nonatomic, strong) UILabel * userProctal;
@property (nonatomic, strong) UIButton * userProctalBtn;
@property (nonatomic, strong) UIButton * userProctalImageBtn;
@property (nonatomic, strong) NSString * yzmStt;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;



    self.viewA.hidden = NO;
    self.viewB.hidden = NO;
    self.phoneField.hidden = NO;
    self.codeBtn.hidden = NO;
    self.codeTxtField.hidden = NO;
    self.viewC.hidden = NO;
    self.passwordNew.hidden = NO;
    self.btn.hidden = NO;
    self.userProctalImageBtn.hidden = NO;
    self.userProctal.hidden = NO;
    self.userProctalBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)dealloc {
    
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
            make.top.mas_equalTo(self.view.mas_top).mas_offset(42);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.viewA.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 1));
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
            make.top.mas_equalTo(self.viewA.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.viewB.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 1));
        }];
    }
    return _viewB;
}


- (UITextField *)phoneField {
    if (!_phoneField) {
        self.phoneField = [UITextField new];
        _phoneField.backgroundColor = CColor(clearColor);
        _phoneField.background = [UIImage imageNamed:@"login_Register_Bord"];
        _phoneField.userInteractionEnabled = YES;
        _phoneField.textColor = [UIColor blackColor];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.font = [UIFont systemFontOfSize:15.0];
        _phoneField.placeholder = @"请输入手机号";
        _phoneField.delegate = self;
        [self.viewA addSubview:_phoneField];
        [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewA.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 40, 44));
        }];
    }
    return _phoneField;
}


- (UITextField *)codeTxtField {
    if (!_codeTxtField) {
        self.codeTxtField = [UITextField new];
        _codeTxtField.backgroundColor = CColor(clearColor);
        _codeTxtField.background = [UIImage imageNamed:@"login_Register_Bord"];
        _codeTxtField.userInteractionEnabled = YES;
        _codeTxtField.textColor = [UIColor blackColor];
        _codeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTxtField.font = [UIFont systemFontOfSize:15.0];
        _codeTxtField.placeholder = @"请输入验证码";
        _codeTxtField.delegate = self;
        [self.viewB addSubview:_codeTxtField];
        [_codeTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.viewB.mas_left).mas_offset(5);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.codeBtn.mas_left).mas_offset(-10);
        }];
    }
    return _codeTxtField;
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        self.codeBtn = [UIButton new];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_codeBtn setTitleColor:NavColor forState:UIControlStateNormal];
        _codeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_codeBtn addTarget:self action:@selector(codeBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.viewB addSubview:_codeBtn];
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.viewB.mas_right).mas_offset(-10);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(100, 44));
        }];
    }
    return _codeBtn;
}
- (UIButton *)btn {
    if (!_btn) {
        self.btn = [UIButton new];
        [_btn setTitle:@"注册" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
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
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth, 50));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_bottom).mas_equalTo(-1);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 1));
        }];
    }
    return _viewC;
}


- (UITextField *)passwordNew {
    if (!_passwordNew) {
        self.passwordNew = [UITextField new];
        _passwordNew.secureTextEntry = YES;
        _passwordNew.background = [UIImage imageNamed:@"login_Register_Bord"];
        _passwordNew.userInteractionEnabled = YES;
        _passwordNew.textColor = [UIColor blackColor];
        _passwordNew.font = [UIFont systemFontOfSize:14];
        _passwordNew.placeholder = @"请输入密码";
        _passwordNew.delegate = self;
        [self.view addSubview:_passwordNew];
        [_passwordNew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewC.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewC.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 40, 44));
        }];
    }
    return _passwordNew;
}

- (UIButton *)userProctalImageBtn {
    if (!_userProctalImageBtn) {
        self.userProctalImageBtn = [UIButton new];
        [_userProctalImageBtn setImage:[UIImage imageNamed:@"xuanze_def"] forState:UIControlStateNormal];
        [_userProctalImageBtn addTarget:self action:@selector(userProctalImageBtnAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_userProctalImageBtn];
        [_userProctalImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.btn.mas_bottom).mas_equalTo(16);
            make.left.mas_equalTo(self.btn.mas_left).mas_equalTo(5);
            make.size.mas_offset(CGSizeMake(16, 16));
        }];
    }
    return _userProctalImageBtn;
}


-(UILabel *)userProctal {
    if (!_userProctal) {
        self.userProctal = [UILabel new];
        _userProctal.text = @"我已阅读并同意";
        _userProctal.font = [UIFont systemFontOfSize:13.0];
        [self.view addSubview:_userProctal];
        [_userProctal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userProctalImageBtn.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(self.userProctalImageBtn.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(95, 44));
        }];
    }
    return _userProctal;
}

-(UIButton *)userProctalBtn {
    if (!_userProctalBtn) {
        self.userProctalBtn = [UIButton new];
        [_userProctalBtn setTitle:@"《用户注册协议》" forState:UIControlStateNormal];
        _userProctalBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _userProctalBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_userProctalBtn setTitleColor:NavColor forState:UIControlStateNormal];
        [self.view addSubview:_userProctalBtn];
        [_userProctalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userProctal.mas_right).mas_equalTo(0);
            make.centerY.mas_equalTo(self.userProctalImageBtn.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(120, 44));
        }];
    }
    return _userProctalBtn;
}



- (void)userProctalImageBtnAction:(UIButton *)btn {
    id btnImage = _userProctalImageBtn.imageView.image;
    if ([btnImage isEqual:[UIImage imageNamed:@"xuanze_def"]]) {
        [_userProctalImageBtn setImage:[UIImage imageNamed:@"xuanze_sel"] forState:UIControlStateNormal];
    }
    else if ([btnImage isEqual:[UIImage imageNamed:@"xuanze_sel"]]) {
        [_userProctalImageBtn setImage:[UIImage imageNamed:@"xuanze_def"] forState:UIControlStateNormal];
    }
}


- (void)queenBtnAction {
    if ([self.codeTxtField.text isEqualToString:self.yzmStt]) {
        [self registerBtnAction];
    }else {
        UIAlertController *alert = [YANDTools createAlertWithTitle:@"提示" message:@"验证码输入不正确，请重新获取。" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)codeBtnAction {
  
    if ([[_phoneField text] isEqualToString:@""])
    {
        [self showAlert:@"手机号不能为空"];
    }
    else if (_phoneField.text.length != 11)
    {
        [self showAlert:@"手机号长度为11位"];
        _phoneField.text = nil;
    }
    else
    {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8])|(198))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(166)|(17[0,1,5,6])|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9])|(199))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:_phoneField.text];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:_phoneField.text];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:_phoneField.text];
        if (isMatch1 || isMatch2 || isMatch3)
        {
            [self dsadsadsa];
        } else {
            [self showAlert:@"请输入正确手机号"];
            _phoneField.text = nil;
        }
    }
}
    
- (void) dsadsadsa{
        NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Login/code/phone/%@",self.phoneField.text];
        [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
            NSLog(@"%@",response);
            self.yzmStt = [NSString stringWithFormat:@"%@",response[@"content"]];
            
        } failure:^(NSError *error) {
            
        } withUrl:str];
        
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    //设置不可点击
                    self.codeBtn.userInteractionEnabled = YES;
                    [self.codeBtn setTitleColor:NavColor forState:UIControlStateNormal];
                });
            }else{
                //int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSLog(@"____%@",strTime);
                    [self.codeBtn setTitle:[NSString stringWithFormat:@"%@s后可重新发送",strTime] forState:UIControlStateNormal];
                    //设置可点击
                    self.codeBtn.userInteractionEnabled = NO;
                    [self.codeBtn setTitleColor:CColor(grayColor) forState:UIControlStateNormal];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
    
- (void)showAlert:(NSString *)str {
    UIAlertController * alert = [YANDTools createAlertWithTitle:@"提示" message:str preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
    
- (void)registerBtnAction {
    
    id btnImage = _userProctalImageBtn.imageView.image;
    if ([btnImage isEqual:[UIImage imageNamed:@"xuanze_def"]]) {
        UIAlertController * alertC = [YANDTools createAlertWithTitle:@"提示" message:@"请勾选用户协议" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            
        }];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else if ([btnImage isEqual:[UIImage imageNamed:@"xuanze_sel"]]) {
        [self yanzhenmamama];
    }
}
- (void)yanzhenmamama {
    if ([self.codeTxtField.text isEqualToString:self.yzmStt]) {
        [self actionRegist];
    }else {
        UIAlertController *alert = [YANDTools createAlertWithTitle:@"提示" message:@"验证码输入不正确，请重新获取。" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
    
    
    
- (void)actionRegist {
    
    
    
    if (_passwordNew.text.length >= 6) {
        NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Login/signup/phone/%@/pwd/%@",_phoneField.text,_passwordNew.text];
        [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
            NSLog(@"%@",response);
            NSInteger codeI = [response[@"code"]integerValue];
            if (codeI == 200) {
                UIAlertController * alertC = [YANDTools createAlertWithTitle:@"提示" message:@"注册成功" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self presentViewController:alertC animated:YES completion:nil];
            }else {
                UIAlertController * alertC = [YANDTools createAlertWithTitle:@"提示" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                }];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
        } withUrl:str];
    }else {
        UIAlertController *alert = [YANDTools createAlertWithTitle:@"提示" message:@"密码长度必须6位以上" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }

    
}



- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFiled代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textfieldDone:(id)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.codeTxtField endEditing:YES];
    [self.phoneField endEditing:YES];
    [self.passwordNew endEditing:YES];

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
