//
//  HWImagePickerSheet.m
//  PhotoSelector
//
//  Created by 洪雯 on 2017/1/12.
//  Copyright © 2017年 洪雯. All rights reserved.
//

#import "HWImagePickerSheet.h"
@interface HWImagePickerSheet ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation HWImagePickerSheet
-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
    }
    return self;
}

//显示选择照片提示Sheet
-(void)showImgPickerActionSheetInView:(UIViewController *)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!imaPic) {
            imaPic = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            imaPic.delegate = self;
            [viewController presentViewController:imaPic animated:YES completion:nil];
        }
        
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImgDataAndShowAllGroup];
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
#if TARGET_IPHONE_SIMULATOR  //模拟器
    [alertController addAction:actionAlbum];
#elif TARGET_OS_IPHONE      //真机
    
#endif
    viewController = controller;
    [viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 加载照片数据
- (void)loadImgDataAndShowAllGroup{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (self.arrSelected) {
                    svc.arrSeleted = self.arrSelected;
                    svc.mvc.arrSelected = self.arrSelected;
                }
                svc.maxCout = self.maxCount;
                [viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}


#pragma mark - 拍照获得数据
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    theImage  = [YANDTools imageToImage:theImage];
    NSLog(@"aaaaasss1111%@",theImage);
    //     判断，图片是否允许修改
//    if ([picker allowsEditing]){
//        //获取用户编辑之后的图像
//        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        theImage  = [YANDTools imageToImage:theImage];
//    } else {
//        // 照片的原数据参数
//        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        theImage  = [YANDTools imageToImage:theImage];
//    }
    if (theImage) {
        //保存图片到相册中
        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
        NSLog(@"aaaaasss2222%@",theImage);
        
        
        [imgLibTool.lib writeImageToSavedPhotosAlbum:theImage.CGImage orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"保存图片失败:%@",error.localizedDescription);

            } else {
                // 多给系统0.5秒的时间，让系统去更新相册数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //获取图片路径
                    [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        if (asset) {
                            [self.arrSelected addObject:asset];
                            [self finishSelectImg];
                            [picker dismissViewControllerAnimated:YES completion:nil];
                        }
                    } failureBlock:^(NSError *error) {
                        NSLog(@"aaaaasss4444%@",error);
                    }];
                });
            }
        }];
        
    }
        
        
//        [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
//            if (error) {
//                NSLog(@"aaaaasss3333%@",error);
//            } else {
//                //获取图片路径
//                [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                    if (asset) {
//                        [self.arrSelected addObject:asset];
//                        [self finishSelectImg];
//                        [picker dismissViewControllerAnimated:YES completion:nil];
//                    }
//                } failureBlock:^(NSError *error) {
//                    NSLog(@"aaaaasss4444%@",error);
//                }];
//            }
//        }];
//    }
    
  
}


#pragma mark - 完成选择后返回的图片Array(ALAsset*)
- (void)finishSelectImg{
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    for (ALAsset *set in _arrSelected) {
        CGImageRef cgImg = [set thumbnail];
        UIImage* image = [UIImage imageWithCGImage: cgImg];
        [thumbnailImgArr addObject:image];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
        [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
    }
}

@end
