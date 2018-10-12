//
//  WXMoneyViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/7/23.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "WXMoneyViewController.h"

@interface WXMoneyViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *label;//备注框提示

@property (nonatomic, strong) UILabel *lb_money;//提现金额label

@property (nonatomic, strong) UILabel *lb_tips;//备注label

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UITextField * textField;//提款金额

@property (strong, nonatomic) UITextView * textView;//备注框

@property (nonatomic, strong) UIButton * btn;//确定


@end

@implementation WXMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微信提现";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = TintColor;
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lb_money.hidden = NO;
    self.textField.hidden = NO;
    self.lineView.hidden = NO;
    self.lb_tips.hidden = NO;
    self.textView.hidden = NO;
    self.btn.hidden = NO;
    self.label.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)submitCash:(UIButton *)button {
 

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           UserDefaults(@"uid"),@"uid",
                           @"0",@"bid",
                           self.textField.text,@"price",
                           self.textView.text,@"remarks",
                           @"1",@"status",nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSInteger codeInt = [response[@"code"]integerValue];
        if (codeInt == 200) {
            [button setEnabled:NO];
            button.backgroundColor = KColor(153, 153, 153);
            NSString * str = [NSString stringWithFormat:@"%@",response[@"msg"]];
            UIAlertController * alert = [YANDTools createAlertWithTitle:@"提示" message:str preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                NSString * strAAA = UserDefaults(@"money");
                int a = strAAA.intValue;
                int b = self.textField.text.intValue;
                int sub = a - b;
                NSString * strSSS = [NSString stringWithFormat:@"%d",sub];
                [[NSUserDefaults standardUserDefaults] setObject:strSSS forKey:@"money"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        } else if (codeInt == 204) {
            UIAlertController * alert = [YANDTools createAlertWithTitle:@"" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [self getAuthWithUserInfoFromWechat];
            } cancleHandler:^(UIAlertAction *cancleAction) {
                
            }];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController * alert = [YANDTools createAlertWithTitle:@"" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [button setEnabled:YES];
        button.backgroundColor = NavColor;
        UIAlertController * alert = [YANDTools createAlertWithTitle:@"提现失败" message:@"您可以重新尝试" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/BankManage/submitCash" withParameters:dict];
}


- (void)getAuthWithUserInfoFromWechat {
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
            
            
            NSString *openStr = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Xinlogin/phonebang/openid/%@/phone/%@",resp.openid,UserDefaults(@"phone")];
            
            [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
                NSLog(@"%@",response);
                NSInteger codeInt = [response[@"code"]integerValue];
                if (codeInt == 200) {

                }
            } failure:^(NSError *error) {
                
            } withUrl:openStr];
            
            
        }
    }];
}





-(UILabel *)lb_money {
    if (!_lb_money) {
        self.lb_money = [UILabel new];
        _lb_money.text = @"提现金额";
        _lb_money.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _lb_money.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.view addSubview:_lb_money];
        [_lb_money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.view.mas_top).mas_offset(26);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
    }
    return _lb_money;
}

- (UILabel *)lb_tips {
    if (!_lb_tips) {
        self.lb_tips = [UILabel new];
        _lb_tips.frame = CGRectMake(15, 305, 28, 20);
        _lb_tips.text = @"备注";
        _lb_tips.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _lb_tips.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.view addSubview:_lb_tips];
        [_lb_tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(20);
            make.size.mas_offset(CGSizeMake(56, 20));
        }];
    }
    return _lb_tips;
}



- (UITextField *)textField {
    if (!_textField) {
        self.textField = [UITextField new];
        _textField.backgroundColor = CColor(whiteColor);
        _textField.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textField.userInteractionEnabled = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.placeholder = @"请输入提款金额";
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lb_money.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.lb_money.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
            make.height.mas_offset(30);
        }];
    }
    return _textField;
}

- (UILabel *)label {
    if (!_label) {
        self.label =
        _label = [UILabel new];
        _label.enabled = NO;
        _label.text = @"若有备注，请在此输入";
        _label.font =  [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor lightGrayColor];
        [self.textView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView.mas_top).mas_offset(6);
            make.left.mas_equalTo(self.textView.mas_left).mas_offset(6);
            make.size.mas_offset(CGSizeMake(200, 20));
        }];
    }
    return _label;
}


- (UITextView *)textView {
    if (!_textView) {
        self.textView = [UITextView new];
        // 设置文本对齐方式
        _textView.textAlignment = NSTextAlignmentLeft;
        // 设置自动纠错方式
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.layer.borderColor = KColor(251,112,69).CGColor;
        _textView.delegate = self;
        _textView.layer.borderColor = CColor(grayColor).CGColor;
        _textView.layer.borderWidth = 0.3;//边框宽度
        _textView.layer.cornerRadius = 0;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.font = [UIFont fontWithName:@"Arial" size:14];
        _textView.backgroundColor = CColor(clearColor);
        [self.view addSubview:self.textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lb_tips.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 119));
        }];
    }
    return _textView;
}

- (UIButton *)btn {
    if (!_btn) {
        self.btn = [UIButton new];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(submitCash:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
}

- (UIView *)lineView {
    if (!_lineView) {
        self.lineView = [UIView new];
        _lineView.backgroundColor = CColor(grayColor);
        [self.view addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lb_money.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 1));
        }];
    }
    return _lineView;
}


- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        self.label.hidden = NO;
    }else{
        textView.textColor = [UIColor blackColor];
        self.label.hidden = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
