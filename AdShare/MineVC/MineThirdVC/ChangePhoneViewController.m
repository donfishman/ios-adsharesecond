//
//  ChangePhoneViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()

@property (nonatomic, strong) UIView *viewA;
@property (nonatomic, strong) UIView *viewB;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UIButton * codeBtn;
@property (nonatomic, strong) UILabel * oldPhoneNum;
@property (nonatomic, strong) NSString * yzmSyt;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改手机号";

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popUserInfoAction) name:@"popUserInfo" object:nil];
    self.viewA.hidden = NO;
    self.viewB.hidden = NO;
    self.oldPhoneNum.hidden = NO;
    self.codeBtn.hidden = NO;
    self.textField.hidden = NO;
    self.btn.hidden = NO;
    
}

- (void)popUserInfoAction {
    [self.navigationController popViewControllerAnimated:NO];
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

-(UILabel *)oldPhoneNum {
    if (!_oldPhoneNum) {
        self.oldPhoneNum = [UILabel new];
        _oldPhoneNum.backgroundColor = CColor(whiteColor);
        _oldPhoneNum.text = UserDefaults(@"phone");
        [self.viewA addSubview:self.oldPhoneNum];
        [_oldPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewA.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 44));
        }];
    }
    return _oldPhoneNum;
}

- (UITextField *)textField {
    if (!_textField) {
        self.textField = [UITextField new];
        _textField.backgroundColor = CColor(whiteColor);
        _textField.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textField.userInteractionEnabled = YES;
        _textField.textColor = [UIColor blackColor];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.placeholder = @"请输入验证码";
        [self.viewB addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.viewB.mas_left).mas_offset(10);
            make.centerY.mas_equalTo(self.viewB.mas_centerY).mas_offset(0);
            make.height.mas_offset(44);
            make.right.mas_equalTo(self.codeBtn.mas_left).mas_offset(-10);
        }];
    }
    return _textField;
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        self.codeBtn = [UIButton new];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_codeBtn setTitleColor:NavColor forState:UIControlStateNormal];
        [_codeBtn setTitleColor:CColor(grayColor) forState:UIControlStateSelected];
        [_codeBtn addTarget:self action:@selector(codeBtnAAction) forControlEvents:UIControlEventTouchDown];
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
        [_btn setTitle:@"下一步" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(netxBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewB.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
}

- (void)codeBtnAAction {
    NSString * phone = UserDefaults(@"phone");
    NSString * str = [NSString stringWithFormat:@"http://139.196.101.133:8087/index.php/ApiHome/Login/code/phone/%@",phone];
    [AFNetworkTool getNetworkDataSuccess:^(NSDictionary *response) {
        self.yzmSyt = [NSString stringWithFormat:@"%@",response[@"content"]];
        NSLog(@"当前手机验证码%@",self.yzmSyt);
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
//                    NSLog(@"____%@",strTime);
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


- (void)netxBtnAction {
    NSLog(@"%@",self.textField.text);
    if ([self.textField.text isEqualToString:self.yzmSyt]) {
        [self.navigationController pushViewController:[ChangePhoneNewViewController new] animated:YES];
    }else {
        UIAlertController *alert = [YANDTools createAlertWithTitle:@"提示" message:@"验证码输入不正确，请重新获取。" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
