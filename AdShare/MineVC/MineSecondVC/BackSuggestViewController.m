//
//  BackSuggestViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/27.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "BackSuggestViewController.h"

@interface BackSuggestViewController ()<UITextViewDelegate>

@property (strong, nonatomic) UITextView * textView;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UILabel *label;
@end

@implementation BackSuggestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    self.textView.hidden = NO;
    self.btn.hidden = NO;
    self.label.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = CColor(whiteColor);
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction:)];
    leftButton.tintColor = TintColor;
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)backBtnAction: (id)send {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UILabel *)label {
    if (!_label) {
        self.label = [UILabel new];
        _label.enabled = NO;
        _label.text = @"请输入宝贵意见~";
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
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.font = [UIFont fontWithName:@"Arial" size:14];
        _textView.backgroundColor = CColor(clearColor);
        [self.view addSubview:self.textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(5);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 10, 236));
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
        [_btn addTarget:self action:@selector(sendDataGCD) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        self.label.hidden = NO;
    }else{
        textView.textColor = [UIColor blackColor];
        self.label.hidden = YES;
    }
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
    [self.textView resignFirstResponder];
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

- (void)sendDataGCD {
    NSString *text = self.textView.text;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:UserDefaults(@"uid"),@"uid", text,@"content", nil];
        
        [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * textStr = [response objectForKey:@"msg"];
                    [self alertViewWith:textStr];
                });
            });
        } failure:^(NSError *error) {
        } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Task/view" withParameters:dict];
    });
}

- (void)alertViewWith:(NSString *)messageStr {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
