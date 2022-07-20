//
//  UpdateViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/20.
//

#import "UpdateViewController.h"
#import "ZLSession.h"
#import "MBProgressHUD.h"

@interface UpdateViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> 

@property (weak, nonatomic) IBOutlet UITextField *userNameTxf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxf;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImv;

- (IBAction)portraitAction:(id)sender;
- (IBAction)completeAction:(id)sender;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", [self.user objectForKey:@"user_id"]];
    self.userNameTxf.text = [self.user objectForKey:@"user_name"];
    self.passwordTxf.text = [self.user objectForKey:@"user_password"];
}

- (IBAction)completeAction:(id)sender {
    [ZLSession POST:@"http://localhost:8080/ZLDemo/update" params:@{@"userId" : [self.user objectForKey:@"user_id"], @"userName" : self.userNameTxf.text, @"password" : self.passwordTxf.text} headers:nil completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if ([result isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadUserListNotification" object:nil];
                hud.label.text = @"修改成功!";
                
            } else {
                hud.label.text = @"修改失败!";
            }
            
            [hud hideAnimated:YES afterDelay:1.3];
        });
        
    }];
}

- (IBAction)portraitAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [self imagePickerControllerDidCancel:picker];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [ZLSession POST:@"http://localhost:8080/ZLDemo/portrait" params:@{@"userId" : [self.user objectForKey:@"user_id"]} headers:nil imagesData:@[UIImageJPEGRepresentation(image, 0.4)] completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if ([result isEqualToString:@"1"]) {
                hud.label.text = @"上传图片成功!";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadUserListNotification" object:nil];
                self.portraitImv.image = image;
                
            } else {
                hud.label.text = @"上传图片失败!";
                self.portraitImv.image = [UIImage imageNamed:@"app"];
            }
            
            [hud hideAnimated:YES afterDelay:1.3];
        });
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
