//
//  LoginViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/26.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *viewA;
@property (nonatomic, strong) UIView *viewB;
@property (nonatomic, strong) UITextField * passwordNew;
@property (nonatomic, strong) UITextField * phoneField;
@property (nonatomic, strong) UIButton * btn;


@property (nonatomic, strong) UILabel * userProctal;
@property (nonatomic, strong) UIButton * userProctalBtn;
@property (nonatomic, strong) UIButton * userProctalImageBtn;


@property (nonatomic, strong) UIButton * findMMBtn;
@property (nonatomic, strong) UIButton * registerBtn;

@property (nonatomic, strong) UIButton * wxLoginBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = CColor(whiteColor);
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    
    
    
    
    self.viewA.hidden = NO;
    self.viewB.hidden = NO;
    self.phoneField.hidden = NO;
    self.passwordNew.hidden = NO;
    self.registerBtn.hidden = NO;
    self.findMMBtn.hidden = NO;
    self.btn.hidden = NO;
    self.userProctalImageBtn.hidden = NO;
    self.userProctal.hidden = NO;
    self.userProctalBtn.hidden = NO;
    self.wxLoginBtn.hidden = NO;
}


- (void)wxLogin:(UIButton *)btn {
    [self getAuthWithUserInfoFromWechat];
}

- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            // 将分享结果返回给js
            NSString *jsStr = [NSString stringWithFormat:@"wechatResult('%@','%@','%@','%@')",resp.openid,resp.name,resp.unionGender,resp.iconurl];
            NSLog(@"%@",jsStr);
            
            
            NSString *openStr = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Xinlogin/wxlogin/openid/%@",resp.openid];
            
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
                NSLog(@"%@",response);
                NSInteger codeInt = [response[@"code"]integerValue];
                if (codeInt == 200) {
                    NSInteger statusInt = [response[@"data"][@"status"]integerValue];
                    if (statusInt == 0) {
                        BDPhoneViewController * bdpVC = [BDPhoneViewController new];
                        bdpVC.openID = resp.openid;
                        bdpVC.name = resp.name;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:bdpVC animated:YES];
                    }else if (statusInt == 1) {
                        NSString * uid = [NSString stringWithFormat:@"%@",response[@"data"][@"id"]];
                        NSLog(@"uid = %@",uid);
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:uid forKey:@"uid"];
                        [defaults setBool:YES forKey:@"ISLOGIN"];
                        [defaults setObject:response[@"data"][@"phone"] forKey:@"phone"];
                        [defaults synchronize];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"addJpushTags" object:response[@"data"][@"phone"]];
                        [self loadUserData:uid];
                        [self.navigationController popViewControllerAnimated:YES];
                }
            }else {
                
            }
             
             } failure:^(NSError *error) {
                 
             } withUrl:openStr];
            
            
        }
    }];
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



- (void)registerAction:(UIButton *)btn  {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}


- (void)findMAction:(UIButton *)btn  {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[FindMMViewController new] animated:YES];
}


- (void)loginBtnAction {
    
    id btnImage = _userProctalImageBtn.imageView.image;
    if ([btnImage isEqual:[UIImage imageNamed:@"xuanze_def"]]) {
        UIAlertController * alertC = [YANDTools createAlertWithTitle:@"提示" message:@"请勾选用户协议" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            
        }];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else if ([btnImage isEqual:[UIImage imageNamed:@"xuanze_sel"]]) {
        [self dsdsadsdsa];
    }
    
}
- (void)showAlert:(NSString *)str {
    UIAlertController * alert = [YANDTools createAlertWithTitle:@"提示" message:str preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
    }];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)dsdsadsdsa {
    
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
            [self actionLogin];
        } else {
            [self showAlert:@"请输入正确手机号"];
            _phoneField.text = nil;
        }
    }
}



-(void)actionLogin {
    if (_passwordNew.text.length >=6) {
        [self.btn setEnabled:NO];
    NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Login/signin/phone/%@/pwd/%@",_phoneField.text,_passwordNew.text];
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        NSLog(@"%@",response);
        NSInteger codeI = [response[@"code"] integerValue];
        if (codeI == 200) {
            NSString * uid = [NSString stringWithFormat:@"%@",response[@"content"]];
            NSLog(@"uid = %@",uid);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:uid forKey:@"uid"];
            [defaults setBool:YES forKey:@"ISLOGIN"];
            [defaults setObject:self.phoneField.text forKey:@"phone"];
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addJpushTags" object:self.phoneField.text];
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self loadUserData:uid];
            [self dsadsadsadsad];
            //                dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            //                });
            //            });
        }
        else {
            UIAlertController * alert = [YANDTools createAlertWithTitle:@"登录失败" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [self.btn setEnabled:YES];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    } withUrl:str];
    }else {
        UIAlertController *alert = [YANDTools createAlertWithTitle:@"提示" message:@"密码长度必须6位以上" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            [self.btn setEnabled:YES];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)dsadsadsadsad {
    NSString *urlqqq = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/UserAccount/myCommission/uid/%@",UserDefaults(@"uid")];
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        NSString * feeData = response[@"balance"];
        if ([feeData isEqual:[NSNull null]]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"money"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:feeData forKey:@"money"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
        
    } withUrl:urlqqq];
}


- (void)loadUserData:(NSString *)UID {
    
    NSString *str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Task/mysafe"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:UID, @"uid", nil];
    
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSString * imageUrl = response[@"content"][@"head_img"];
        NSString * phone = response[@"content"][@"phone"];
        NSString * username = response[@"content"][@"name"];
        if ([username isEqual:[NSNull null]]) {
            username = @"佚名";
        }
        [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:@"imageUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    } failure:^(NSError *error) {
        
    } withUrl:str withParameters:dict];
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFiled代理方法
- (BOOL)textFieldShouldBeginEditing:( UITextField *)textField {
    /*
     CGFloat offset = self.view.bounds.size.height - (textField.frame.origin.y + textField.frame.size.height + 217 + 60);
     NSLog(@"%f",offset);
     if (offset <=0) {
     [UIView animateWithDuration:0.3 animations:^{
     CGRect frame = self.view.frame;
     frame.origin.y = offset;
     self.view.frame = frame;
     }];
     }
     */
    return YES;
}

//停止编辑页面回到原位置
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
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
        [self.viewA addSubview:_phoneField];
        [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewA.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 40, 44));
        }];
    }
    return _phoneField;
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
            make.centerX.mas_equalTo(self.viewB.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 40, 44));
        }];
    }
    return _passwordNew;
}

- (UIButton *)btn {
    if (!_btn) {
        self.btn = [UIButton new];
        [_btn setTitle:@"登录" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.registerBtn.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
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



-(UIButton *)registerBtn {
    if (!_registerBtn) {
        self.registerBtn = [UIButton new];
        [_registerBtn setTitle:@" 注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _registerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_registerBtn setTitleColor:KColor(153, 153, 153) forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:_registerBtn];
        [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.viewB.mas_left).mas_equalTo(0);
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_offset(20);
            make.size.mas_offset(CGSizeMake(40, 20));
        }];
    }
    return _registerBtn;
}



-(UIButton *)findMMBtn {
    if (!_findMMBtn) {
        self.findMMBtn = [UIButton new];
        [_findMMBtn setTitle:@"忘记密码  " forState:UIControlStateNormal];
        _findMMBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _findMMBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_findMMBtn setTitleColor:KColor(153, 153, 153) forState:UIControlStateNormal];
        [_findMMBtn addTarget:self action:@selector(findMAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_findMMBtn];
        [_findMMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.viewB.mas_right).mas_equalTo(0);
            make.centerY.mas_equalTo(self.registerBtn.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
    }
    return _findMMBtn;
}

-(UIButton *)wxLoginBtn {
    if (!_wxLoginBtn) {
        self.wxLoginBtn = [UIButton new];
        [_wxLoginBtn setImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
        [_wxLoginBtn addTarget:self action:@selector(wxLogin:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_wxLoginBtn];
        [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userProctalBtn.mas_bottom).mas_equalTo(75);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(72, 72));
        }];
    }
    return _wxLoginBtn;
}

@end
