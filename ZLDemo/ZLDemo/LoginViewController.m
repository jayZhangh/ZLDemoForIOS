//
//  LoginViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/19.
//

#import "LoginViewController.h"
#import "ZLSession.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTxf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxf;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Login";
}

- (IBAction)registerAction:(id)sender {
    [ZLSession POST:@"http://localhost:8080/ZLDemo/register" params:@{@"userName" : self.userNameTxf.text, @"password" : self.pwdTxf.text} headers:nil completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if ([result isEqualToString:@"1"]) {
                hud.label.text = @"注册成功!";
                
            } else {
                hud.label.text = @"注册失败!";
            }
            
            [hud hideAnimated:YES afterDelay:1.3];
        });
    }];
}

- (IBAction)loginAction:(id)sender {
    [ZLSession POST:@"http://localhost:8080/ZLDemo/login" params:@{@"userName" : self.userNameTxf.text, @"password" : self.pwdTxf.text} headers:nil completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            if ([result isEqualToString:@"1"]) {
                hud.label.text = @"登录成功!";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserListIdentifier"] animated:YES];
                });
                
            } else {
                hud.label.text = @"登录失败!";
            }
            
            [hud hideAnimated:YES afterDelay:1.3];
        });
    }];
}

@end
