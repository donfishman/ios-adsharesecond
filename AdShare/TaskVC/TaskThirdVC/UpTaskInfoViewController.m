//
//  UpTaskInfoViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/5/23.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "UpTaskInfoViewController.h"
#import "UIImageView+WebCache.h"

#define iphone4 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#define iphone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size))
#define iphone6 (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size))
#define iphone6plus (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size))
//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300
#define HeightVC [UIScreen mainScreen].bounds.size.height//获取设备高度
#define WidthVC [UIScreen mainScreen].bounds.size.width//获取设备宽度


@interface UpTaskInfoViewController ()<UITextViewDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    float _TimeNUMX;
    float _TimeNUMY;
    int _FontSIZE;
    float allViewHeight;
    int _imgCo;
}


//图片
@property (nonatomic,strong) UIImageView *photoImageView;
//文字介绍



@property (nonatomic,strong) NSMutableDictionary * upDic;
@property (nonatomic,strong) NSMutableArray * photoArr;

@property (nonatomic,strong) NSMutableArray * photoStrArr;

@property (strong, nonatomic) UITextView * textView;


@property (strong, nonatomic) UIView *viewA;
//@property (strong, nonatomic) UIView *viewB;
@property (strong, nonatomic) UIView *viewC;
@property (strong, nonatomic) UIView *collectBgView;

@property (strong, nonatomic) UILabel *taskLabel;
@property (strong, nonatomic) UILabel *imgCountLabel;


@property (strong, nonatomic) UILabel *hotLabel;

@property (strong, nonatomic) UIButton *buttonA;

@property (strong, nonatomic) UIButton *buttonB;

@property (strong, nonatomic) UILabel *tipsLabel;

@property (strong, nonatomic) UILabel *textViewBottomLabel;

@property (strong, nonatomic) NSString * crIDStr;
@property (strong, nonatomic) NSString * rIDStr;

@end

@implementation UpTaskInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交任务";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    leftButton.tintColor = KColor(102, 102, 102);
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:CColor(blackColor),NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    self.photoStrArr = [NSMutableArray array];
    self.viewA.hidden = NO;
//    self.viewB.hidden = NO;
    self.viewC.hidden = NO;
    self.collectBgView.hidden = NO;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    _TimeNUMX = [self BackTimeNUMX];
    _TimeNUMY = [self BackTimeNUMY];
    
    
    
    self.showInView = _collectBgView;
    
    /** 初始化collectionView */
    [self initPickerView];
    [self updateViewsFrame];
    [self initBottomView];
    self.maxCount = _imgCo;
    
}

/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
}


- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}




#pragma mark 点击出大图方法
- (void)ClickImage:(UIButton *)sender{
    
}

- (void)setCridStr:(NSString *)crid withRid:(NSString *)rid withimgCount:(NSString *)imgCount {
    self.crIDStr = [NSString stringWithFormat:@"%@",crid];
    self.rIDStr = [NSString stringWithFormat:@"%@",rid];
    _imgCo = imgCount.intValue;
    NSLog(@"%@++++%@",self.crIDStr,self.rIDStr);
}

#pragma mark 确定评价的方法
- (void)ClickSureBtn:(UIButton *)sender{
    self.photoArr = [[NSMutableArray alloc] initWithArray:[self getBigImageArray]];
    if (self.photoArr.count >9){
        NSLog(@"最多上传8张照片!");
    }else if (self.photoArr.count == _imgCo){
        [sender setEnabled:NO];
        sender.backgroundColor = KColor(153, 153, 153);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (UIImage * image in self.photoArr) {
                NSString * str  = [YANDTools zipNSDataWithImage:image];
                [self.photoStrArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%lu",self.photoStrArr.count);
                NSString * labelStr = @"";
                id btnABGColor = self.buttonA.backgroundColor;
                id btnBBGColor = self.buttonB.backgroundColor;
                id btnBGCOlor = KColor(243, 245, 248);
                if ([btnABGColor isEqual:CColor(clearColor)] && [btnBBGColor isEqual:CColor(clearColor)] ) {
                    labelStr = @"";
                } else if ([btnABGColor isEqual:CColor(clearColor)] && [btnBBGColor isEqual:btnBGCOlor] ) {
                    labelStr = @"2";
                } else if ([btnABGColor isEqual:btnBGCOlor] && [btnBBGColor isEqual:CColor(clearColor)] ) {
                    labelStr = @"1";
                } else if ([btnABGColor isEqual:btnBGCOlor] && [btnBBGColor isEqual:btnBGCOlor] ) {
                    labelStr = @"1,2";
                }
                NSString *allStr = @"";
                for (int i = 0; i <self.photoStrArr.count; i ++) {
                    NSString * str = [NSString stringWithFormat:@"%@,",self.photoStrArr[i]];
                    allStr = [allStr stringByAppendingString:str];
                }
                allStr = [allStr substringToIndex:([allStr length]-1)];// 去掉最后一个","
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       self.crIDStr,@"id",
                                       UserDefaults(@"uid"),@"uid",
                                       self.rIDStr,@"rid",
                                       @"1",@"label",
                                       self.textView.text,@"remarks",
                                       allStr,@"photo",nil];
                NSLog(@"id = %@",dict[@"id"]);
                NSString * url = @"http://139.196.101.133:8087/index.php/ApiHome/Task/addtask";
                
                    [AFNetworkTool postNetworkDataSuccess:^(NSDictionary *response) {
                        NSString * code = response[@"code"];
                        NSLog(@"%@",response);
                        if (code.integerValue == 200 ) {
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadSuccess" object:nil];
                        }else {
                            UIAlertController * alert = [YANDTools createAlertWithTitle:@"上传失败" message:@"请重新上传" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
                            }];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    } failure:^(NSError *error) {
                        [sender setEnabled:YES];
                        sender.backgroundColor = NavColor;
                    } withUrl:url withParameters:dict];
            });
        });
        
        
    } else {
        UIAlertController * alert = [YANDTools createAlertWithTitle:@"提示" message:@"请上传相应数量图片" preferred:1 confirmHandler:^(UIAlertAction *confirmAction) {
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark ------提交
- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    return jsonString;
}
#pragma mark 返回不同型号的机器的倍数值
- (float)BackTimeNUMX {
    float numX = 0.0;
    if (iphone4) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone5) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone6) {
        return 1.0;
    }
    if (iphone6plus) {
        numX = 414 / 375.0;
        return numX;
    }
    return numX;
}
- (float)BackTimeNUMY {
    float numY = 0.0;
    if (iphone4) {
        numY = 480 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone5) {
        numY = 568 / 667.0;
        _FontSIZE = -2;
        return numY;
    }
    if (iphone6) {
        _FontSIZE = 0;
        return 1.0;
    }
    if (iphone6plus) {
        numY = 736 / 667.0;
        _FontSIZE = 2;
        return numY;
    }
    return numY;
}




- (void)initBottomView {
    UIButton *actionBtn = [[UIButton alloc]init];
    actionBtn.backgroundColor = NavColor;
    actionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [actionBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(ClickSureBtn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:actionBtn];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.width.mas_offset(KSW);
        make.height.mas_offset(49);
    }];
}


-(UIView *)viewA {
    if (!_viewA) {
        self.viewA = [UIView new];
        _viewA.backgroundColor = CColor(whiteColor);
        [self.view addSubview:_viewA];
        [_viewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(0);
            make.width.mas_offset(KSW);
            make.height.mas_offset(190);
        }];
        self.taskLabel = [UILabel new];
        _taskLabel.text = @"任务图片";
        _taskLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _taskLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewA addSubview:_taskLabel];
        [_taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_top).mas_offset(16);
            make.left.mas_equalTo(self.viewA.mas_left).mas_offset(15);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
        
        self.imgCountLabel = [UILabel new];
        _imgCountLabel.text = @"（该任务需要上传0张图片）";
        _imgCountLabel.text = [NSString stringWithFormat:@"（该任务需要上传%d张图片）",_imgCo];
        _imgCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self.viewA addSubview:_imgCountLabel];
        [_imgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_top).mas_offset(16);
            make.left.mas_equalTo(self.taskLabel.mas_right).mas_offset(0);
            make.right.mas_equalTo(self.viewA.mas_right).mas_offset(-20);
            make.height.mas_offset(20);
        }];
        
        self.collectBgView = [UIView new];
        _collectBgView.backgroundColor = CColor(whiteColor);
        [self.viewA addSubview:_collectBgView];
        [_collectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.taskLabel.mas_bottom).mas_offset(0);
            make.width.mas_offset(KSW);
            make.height.mas_offset(200);
        }];
    }
    return _viewA;
}



//-(UIView *)viewB {
//    if (!_viewB) {
//        self.viewB = [UIView new];
//        _viewB.backgroundColor = CColor(whiteColor);
//        [self.view addSubview:_viewB];
//        [_viewB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.viewA.mas_bottom).mas_offset(0);
//            make.width.mas_offset(KSW);
//            make.height.mas_offset(100);
//        }];
//        self.hotLabel = [UILabel new];
//        _hotLabel.frame = CGRectMake(15, 226, 56, 20);
//        _hotLabel.text = @"推荐选择";
//        _hotLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//        _hotLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
//        [self.viewB addSubview:_hotLabel];
//        [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.viewB.mas_top).mas_offset(16);
//            make.left.mas_equalTo(self.viewB.mas_left).mas_offset(15);
//            make.size.mas_offset(CGSizeMake(60, 20));
//        }];
//        self.buttonA = [UIButton new];
//        [_buttonA.layer setMasksToBounds:YES];
//        [_buttonA.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
//        [_buttonA.layer setBorderWidth:1.0]; //边框宽度
//        [_buttonA.layer setBorderColor:KColor(223, 223, 223).CGColor];//边框颜色
//        [_buttonA setTitle:@"APP很棒哦~" forState:UIControlStateNormal];//button title
//        [_buttonA setTitleColor:KColor(102, 102, 102) forState:UIControlStateNormal];//title color
//        _buttonA.titleLabel.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
//        _buttonA.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        [_buttonA addTarget:self action:@selector(buttonDonwRecover:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
//        _buttonA.backgroundColor = [UIColor clearColor];
//        [self.viewB addSubview:_buttonA];
//
//        self.buttonB = [UIButton new];
//        [_buttonB.layer setMasksToBounds:YES];
//        [_buttonB.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
//        [_buttonB.layer setBorderWidth:1.0]; //边框宽度
//        [_buttonB.layer setBorderColor:KColor(223, 223, 223).CGColor];//边框颜色
//        [_buttonB setTitle:@"APP很不错呦~" forState:UIControlStateNormal];//button title
//        [_buttonB setTitleColor:KColor(102, 102, 102) forState:UIControlStateNormal];//title color
//        _buttonB.titleLabel.textColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1];
//        _buttonB.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        [_buttonB addTarget:self action:@selector(buttonDonwRecover:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
//        _buttonB.backgroundColor = [UIColor clearColor];
//        [self.viewB addSubview:_buttonB];
//
//        CGFloat margin = 15;
//        CGFloat height = 32;
//        [_buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.viewB).offset(margin);
//            make.top.equalTo(self.hotLabel).offset(margin*2);
//            make.right.equalTo(self.buttonB.mas_left).offset(-margin);
//            make.height.offset(height);
//            make.height.equalTo(self.buttonB);
//            make.width.equalTo(self.buttonB);
//            make.top.equalTo(self.buttonB);
//        }];
//        [_buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.viewB).offset(-margin);
//        }];
//    }
//    return _viewB;
//}

- (UIView *)viewC {
    if (!_viewC) {
        self.viewC = [UIView new];
        _viewC.backgroundColor = CColor(whiteColor);
        [self.view addSubview:_viewC];
        
        [_viewC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewA.mas_bottom).mas_offset(0);
            make.width.mas_offset(KSW);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        }];
        
        self.tipsLabel = [UILabel new];
        //        _tipsLabel.frame = CGRectMake(15, 323, 56, 20);
        _tipsLabel.text = @"备注信息";
        _tipsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _tipsLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.viewC addSubview:_tipsLabel];
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewC.mas_top).mas_offset(16);
            make.left.mas_equalTo(self.viewC.mas_left).mas_offset(15);
            make.size.mas_offset(CGSizeMake(60, 20));
        }];
        
        self.textView = [UITextView new];
        // 设置文本对齐方式
        _textView.textAlignment = NSTextAlignmentLeft;
        // 设置自动纠错方式
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.delegate = self;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.font = [UIFont fontWithName:@"Arial" size:14];
        _textView.backgroundColor = CColor(clearColor);
        _textView.layer.borderColor = KColor(222, 222, 222).CGColor;
        _textView.layer.borderWidth = 0.5;//边框宽度
        [self.viewC addSubview:self.textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_offset(5);
            make.centerX.mas_equalTo(self.viewC.mas_centerX).mas_offset(0);
            make.size.mas_offset(CGSizeMake(KScreenWidth - 30, 144));
        }];
        self.textViewBottomLabel = [UILabel new];
        _textViewBottomLabel.enabled = NO;
        _textViewBottomLabel.text = @"请输入备注信息";
        _textViewBottomLabel.font =  [UIFont systemFontOfSize:15];
        _textViewBottomLabel.textColor = [UIColor lightGrayColor];
        [self.viewC addSubview:_textViewBottomLabel];
        [_textViewBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView.mas_top).mas_offset(6);
            make.left.mas_equalTo(self.textView.mas_left).mas_offset(6);
            make.size.mas_offset(CGSizeMake(200, 20));
        }];
        
        
        
        
    }
    return _viewC;
}

- (void)buttonDonwRecover:(id)sender {
    UIButton *btn = (UIButton *)sender;
    id btnBGColor = btn.backgroundColor;
    if ([btnBGColor isEqual:CColor(clearColor)]) {
        btn.backgroundColor = KColor(243, 245, 248);
    }
    else {
        btn.backgroundColor = CColor(clearColor);
    }
}


- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
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
        self.textViewBottomLabel.hidden = NO;
    }else{
        textView.textColor = [UIColor blackColor];
        self.textViewBottomLabel.hidden = YES;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
