//
//  BangCardViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/25.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BangCardViewController.h"

@interface BangCardViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelA;
@property (nonatomic, strong) UILabel *labelB;
@property (nonatomic, strong) UILabel *labelC;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *addCardBtn;
@property (nonatomic, strong) UITextField * textField;
@property (strong, nonatomic) UITextView * textView;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UIView *buttonView;


@property (nonatomic, strong) UILabel *asdLabel;


@property (nonatomic, strong) UILabel *addLabelA;
@property (nonatomic, strong) UILabel *addLabelB;
@property (nonatomic, strong) UILabel *addLabelC;
@property (nonatomic, strong) UIButton *addButton;




@end

@implementation BangCardViewController



- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        self.label.hidden = NO;
    }else{
        textView.textColor = [UIColor blackColor];
        self.label.hidden = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = self.view.frame;
//        frame.origin.y = 0.0;
//        self.view.frame = frame;
//    }];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    CGFloat offset = KScreenHeight - (textView.frame.origin.y + textView.frame.size.height);
//    NSLog(@"%f",offset);
//    if (offset <=0) {
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect frame = self.view.frame;
//            frame.origin.y = offset;
//            self.view.frame = frame;
//        }];
//    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBangCard];
    [self refreshBankCard];
    self.navigationItem.title = @"银行卡提现";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = TintColor;
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)refreshBankCard {
    self.addLabelA.text = UserDefaults(@"FeeName");
    self.addLabelB.text = UserDefaults(@"kh_bank");
    self.addLabelC.text = UserDefaults(@"bank_card");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBankCard) name:@"refreshBankCard" object:nil];
    [self refreshBankCard];
    self.labelA.hidden = NO;
    self.addCardBtn.hidden = NO;
    self.labelB.hidden = NO;
    self.textField.hidden = NO;
    self.lineView.hidden = NO;
    self.labelC.hidden = NO;
    self.textView.hidden = NO;
    self.btn.hidden = NO;
    self.label.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshBankCard" object:nil];
}

- (void)submitCashAAAA {
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           UserDefaults(@"uid"),@"uid",
                           UserDefaults(@"BankCardID"),@"bid",
                           self.textField.text,@"price",
                           self.textView.text,@"remarks",
                           @"0",@"status",nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
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
    } failure:^(NSError *error) {
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/BankManage/submitCash" withParameters:dict];
}

- (void)showBangCard {
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:UserDefaults(@"uid"),@"uid", nil];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
        NSDictionary * dict = response[@"data"];
        if (dict.count > 0) {
            [[NSUserDefaults standardUserDefaults]setObject:response[@"data"][@"bank_card"] forKey:@"bank_card"];
            [[NSUserDefaults standardUserDefaults]setObject:response[@"data"][@"kh_bank"] forKey:@"kh_bank"];
            [[NSUserDefaults standardUserDefaults]setObject:response[@"data"][@"name"] forKey:@"FeeName"];
            [[NSUserDefaults standardUserDefaults]setObject:response[@"data"][@"id"] forKey:@"BankCardID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            self.buttonView.hidden = NO;
            self.addLabelA.hidden = NO;
            self.addLabelB.hidden = NO;
            self.addLabelC.hidden = NO;
            self.addButton.hidden = NO;
            self.asdLabel.hidden = YES;
        } else {
            self.buttonView.hidden = YES;
            self.addLabelA.hidden = YES;
            self.addLabelB.hidden = YES;
            self.addLabelC.hidden = YES;
            self.addButton.hidden = YES;
            self.asdLabel.hidden = NO;
        }
    } failure:^(NSError *error) {
        
    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/BankManage/cashShow" withParameters:dict];
    
}





- (void)bankCardListAction {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[CardListViewController new] animated:YES];
}



- (UIView *)buttonView {
    if (!_buttonView) {
        self.buttonView = [UIView new];
        [self.view addSubview:_buttonView];
        [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.labelA.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 80));
        }];
    }
    return _buttonView;
}

- (UILabel *)addLabelA {
    if (!_addLabelA) {
        
        self.addLabelA = [UILabel new];
//        _addLabelA.text = UserDefaults(@"FeeName");
        _addLabelA.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.buttonView addSubview:_addLabelA];
        [_addLabelA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buttonView.mas_top).mas_offset(15);
            make.left.mas_equalTo(self.buttonView.mas_left).mas_offset(16);
            make.size.mas_offset(CGSizeMake(60, 25));
        }];
    }
    return _addLabelA;
}

- (UILabel *)addLabelB {
    if (!_addLabelB) {
        self.addLabelB = [UILabel new];
//        _addLabelB.text = UserDefaults(@"kh_bank");
        _addLabelB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self.buttonView addSubview:_addLabelB];
        [_addLabelB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addLabelA.mas_bottom).mas_offset(13);
            make.left.mas_equalTo(self.buttonView.mas_left).mas_offset(15);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
    }
    return _addLabelB;
}

- (UILabel *)addLabelC {
    if (!_addLabelC) {
        self.addLabelC = [UILabel new];
//        _addLabelC.text = UserDefaults(@"bank_card");
        _addLabelC.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self.buttonView addSubview:_addLabelC];
        [_addLabelC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.addLabelB.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.addLabelB.mas_right).mas_offset(24);
            make.size.mas_offset(CGSizeMake(125, 20));
        }];
    }
    return _addLabelC;
}

- (UIButton *)addButton {
    if (!_addButton) {
        self.addButton = [UIButton new];
        _addButton.backgroundColor = CColor(clearColor);
        _addButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_addButton setTitleColor:NavColor forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
        [_addButton setTitle:@"修改" forState:UIControlStateNormal];
        // 重点位置开始
        _addButton.imageEdgeInsets = UIEdgeInsetsMake(0, _addButton.titleLabel.frame.size.width + 36, 0, -_addButton.titleLabel.frame.size.width - 2.5);
        _addButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_addButton.currentImage.size.width, 0, _addButton.currentImage.size.width);
        // 重点位置结束
        [_addButton addTarget:self action:@selector(bankCardListAction) forControlEvents:UIControlEventTouchDown];
        [self.buttonView addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.buttonView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.buttonView.mas_right).mas_offset(-1);
            make.size.mas_offset(CGSizeMake(60, 30));
        }];
    }
    return _addButton;
}





-(UILabel *)labelA {
    if (!_labelA) {
        self.labelA = [UILabel new];
        _labelA.text = @"收款账号";
        _labelA.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelA.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.view addSubview:_labelA];
        [_labelA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.view.mas_top).mas_offset(15);
            make.size.mas_offset(CGSizeMake(56, 20));
        }];
    }
    return _labelA;
}

-(UILabel *)labelB {
    if (!_labelB) {
        self.labelB = [UILabel new];
        _labelB.text = @"提现金额";
        _labelB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelB.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.view addSubview:_labelB];
        [_labelB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.addCardBtn.mas_bottom).mas_offset(26);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
    }
    return _labelB;
}

- (UILabel *)labelC {
    if (!_labelC) {
        self.labelC = [UILabel new];
        _labelC.frame = CGRectMake(15, 305, 28, 20);
        _labelC.text = @"备注";
        _labelC.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _labelC.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.view addSubview:_labelC];
        [_labelC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(20);
            make.size.mas_offset(CGSizeMake(56, 20));
        }];
    }
    return _labelC;
}

- (UIButton *)addCardBtn {
    if (!_addCardBtn) {
        self.addCardBtn = [UIButton new];
        _addCardBtn.layer.masksToBounds = YES;
        _addCardBtn.layer.cornerRadius = 0;
        _addCardBtn.layer.borderWidth = 0.3;//边框宽度
        _addCardBtn.layer.borderColor = CColor(grayColor).CGColor;
        _addCardBtn.backgroundColor = CColor(clearColor);
        [_addCardBtn addTarget:self action:@selector(bankCardListAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_addCardBtn];
        [_addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.labelA.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 80));
        }];
    }
    return _addCardBtn;
}
- (UILabel *)asdLabel {
    if (!_asdLabel) {
        self.asdLabel = [UILabel new];
        _asdLabel.text = @"+ 添加银行卡";
        _asdLabel.tintColor = NavColor;
        _asdLabel.textColor = NavColor;
        _asdLabel.tag = 169;
        _asdLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.view addSubview:_asdLabel];
        [_asdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.addCardBtn.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.addCardBtn.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(100, 20));
        }];
    }
    return _asdLabel;
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
            make.left.mas_equalTo(self.labelB.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.labelB.mas_centerY).mas_offset(0);
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
            make.top.mas_equalTo(self.labelC.mas_bottom).mas_offset(15);
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
        [_btn addTarget:self action:@selector(submitCashAAAA) forControlEvents:UIControlEventTouchDown];
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
            make.top.mas_equalTo(self.labelB.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 1));
        }];
    }
    return _lineView;
}


- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
