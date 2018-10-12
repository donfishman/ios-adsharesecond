//
//  UserInfoViewController.m
//  AdShare
//
//  Created by ZLWL on 2018/4/26.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property(strong,nonatomic) NSArray *listData;
@property(strong,nonatomic) NSDictionary *tableViewData;
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) UITableViewCell *tableViewCell;
@property(strong,nonatomic) UIImageView *imageView1;
@property(strong,nonatomic) UIImageView *imageView2;


@property (strong, nonatomic) UIImageView *headImage;

//@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation UserInfoViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
 
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改资料";
    self.view.backgroundColor = CColor(whiteColor);
    self.navigationController.navigationBar.barTintColor = CColor(whiteColor);
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction:)];
    liftButton.tintColor = TintColor;
    self.navigationItem.leftBarButtonItem = liftButton;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight + 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 设置表头
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopTextTableViewCellID"];
    [self.view addSubview:self.tableView];
    NSArray *loginArray = [NSArray arrayWithObjects:@"头像", @"用户名", @"手机号",@"密码修改", nil];
    self.listData = loginArray;
}

- (void)viewWillLayoutSubviews {

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    声明静态字符串型对象，用来标记重用单元格
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    ShopTextTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"ShopTextTableViewCellID"];
    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ShopImageTableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"shopImageCell"];
    cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    if (!cell1) {
        cell1 = [[ShopTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopTextTableViewCellID"];
    }
    if (!cell2) {
        cell2 = [[ShopImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopImageCell"];
    }
    
    if (indexPath.row == 0) {
        cell2.textLabel.text = @"头像";
        cell2.accessoryType = UITableViewCellAccessoryNone;
        NSString *imageUrl = UserDefaults(@"imageUrl");
        [cell2.shopImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        
        cell2.shopImage.layer.masksToBounds = YES;
        NSLog(@"%2f",cell2.shopImage.bounds.size.height);
        NSInteger intaa = cell2.shopImage.bounds.size.height;
        cell2.shopImage.layer.cornerRadius = intaa * 0.5;
        return cell2;
    }
    else if (indexPath.row == 1) {
        cell1.textLabel.text = @"用户名";
        cell1.rightLabel.text = UserDefaults(@"username");
        return cell1;
        
    }
    else if (indexPath.row == 2) {
        cell1.textLabel.text = @"手机号";
        cell1.rightLabel.text = UserDefaults(@"phone");
        return cell1;
    }
    else if (indexPath.row == 3) {
        cell1.textLabel.text = @"密码修改";
        cell1.rightLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
        return cell1;
        
    }
    else if (indexPath.row == 4) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, KScreenWidth - 30, 48)];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        btn.backgroundColor = NavColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 0;
        [btn addTarget:self action:@selector(takeOutAction) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:btn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
}





-(void)takeOutAction {
    [[NSUserDefaults standardUserDefaults] setObject:@"http://139.196.101.133:8087/public/head/1.png" forKey:@"imageUrl"];
    //http://139.196.101.133:8085/public/images/headicon.png
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:@"未登录" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISLOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addJpushTags" object:@"99999999999"];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
        
    }];
    
    
}

- (void)backBtnAction: (id)send {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row == 0) {
        [self showAlertUploadImage];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[ChangeNameViewController new] animated:YES];
    } else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[ChangePhoneViewController new] animated:YES];
    } else if (indexPath.row == 3)  {
        [self.navigationController pushViewController:[ChangeMMViewController new] animated:YES];
    } else if (indexPath.row == 4) {
        [self takeOutAction];
    }
}



///****************************************

/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"123" message:@"456" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        }];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *picture = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }];
        [alertVC addAction:cancle];
        [alertVC addAction:camera];
        [alertVC addAction:picture];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
//        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    
//    self.actionSheet.tag = 1000;
//    [self.actionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (actionSheet.tag == 1000) {
//        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        // 判断是否支持相机
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            switch (buttonIndex) {
//                case 0:
//                    //来源:相机
//                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    break;
//                case 1:
//                    //来源:相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    break;
//                case 2:
//                    return;
//            }
//        }
//        else {
//            if (buttonIndex == 2) {
//                return;
//            } else {
//                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            }
//        }
//        // 跳转到相机或相册页面
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.sourceType = sourceType;
//        [self presentViewController:imagePickerController animated:YES completion:^{
//        }];
//    }
//}

- (void)showAlertUploadImage {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }];
    [alertVC addAction:cancle];
    [alertVC addAction:camera];
    [alertVC addAction:picture];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSIndexPath *indexPath =  [NSIndexPath indexPathForItem:0 inSection:0];
        ShopImageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.shopImage.image = image;
        
        NSString * str = [NSString stringWithFormat:@"uid=%@&content=%@",UserDefaults(@"uid"),[YANDTools AAAZipNSDataWithImage:image]];
        [self uploadUserDataWithDataStr:str];
    }];
}

- (void)uploadUserDataWithDataStr:(NSString *)dataStr {
        // 耗时的操作
        //1，创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //2,根据会话创建task
        NSURL *url = [NSURL URLWithString:@"http://139.196.101.133:8087/index.php/ApiHome/Task/uploadHeadimg"];
        //3,创建可变的请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //4,请求方法改为post
        request.HTTPMethod = @"POST";
        //5,设置请求体
        request.HTTPBody = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        //6根据会话创建一个task（发送请求）

        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString * image = [NSString stringWithFormat:@"%@",dic[@"content"]];
            [[NSUserDefaults standardUserDefaults] setObject:image forKey:@"imageUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [dataTask resume];
}

#pragma mark - 取消选取图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置cell高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        return 93.5;
    }
    if (indexPath.row == 4)
    {
        return 88;
    }
    return 62;
}

#pragma mark - cell数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

