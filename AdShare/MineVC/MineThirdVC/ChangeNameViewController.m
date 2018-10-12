//
//  ChangeNameViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/24.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "ChangeNameViewController.h"
#define kMaxLength 20

@interface ChangeNameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *viewA;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * btn;

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改用户名";
    
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.viewA.hidden = NO;
    self.textField.hidden = NO;
    self.btn.hidden = NO;
   
    
}
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

- (UITextField *)textField {
    if (!_textField) {
        self.textField = [UITextField new];
//        _textField.secureTextEntry = NO;
        _textField.backgroundColor = CColor(whiteColor);
        _textField.background = [UIImage imageNamed:@"login_Register_Bord"];
        _textField.userInteractionEnabled = YES;
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.placeholder = @"请输入新用户名";
        [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        self.textField.delegate = self;

        [self.viewA addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewA.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.viewA.mas_centerY).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 20, 44));
        }];
    }
    return _textField;
}
- (UIButton *)btn {
    if (!_btn) {
        self.btn = [UIButton new];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        _btn.backgroundColor = NavColor;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 0;
        [_btn addTarget:self action:@selector(changBtnAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 48));
        }];
    }
    return _btn;
}

- (void)changBtnAction {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] forKey:@"uid"];
    [dict setObject:self.textField.text forKey:@"name"];
    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {

        NSString * codeStr = response[@"code"];
        NSInteger codeInt = codeStr.integerValue;
        if (codeInt == 200) {
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"修改成功" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                [[NSUserDefaults standardUserDefaults]setObject:self.textField.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               [self.navigationController popViewControllerAnimated:YES];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (codeInt == 201) {
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"用户名不能为空" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (codeInt == 202) {
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"用户名重复" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:response[@"msg"] preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        UIAlertController *alert =  [YANDTools createAlertWithTitle:@"提示" message:@"请求失败" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {

        }];
        [self presentViewController:alert animated:YES completion:nil];

    } withUrl:@"http://139.196.101.133:8087/index.php/ApiHome/Task/myname/" withParameters:dict];
        
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField endEditing:YES];
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    } else {
        return NO;
    }
}
- (void)textFieldChanged:(UITextField *)textField {
    
    
    NSString *toBeString = textField.text;
    
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式

    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}
/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 *  获得 kMaxLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > kMaxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//注意：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
