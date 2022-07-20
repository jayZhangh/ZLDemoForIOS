//
//  UserListViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/19.
//

#import "UserListViewController.h"
#import "UpdateViewController.h"
#import "ZLSession.h"
#import "SDWebImage.h"
#import "MBProgressHUD.h"

@interface UserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *userArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAction) name:@"ReloadUserListNotification" object:nil];
    
    [self reloadAction];
}

- (void)reloadAction {
    [ZLSession POST:@"http://localhost:8080/ZLDemo/userList" params:nil headers:nil completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.userArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@", self.userArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserListTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *user = [self.userArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [user objectForKey:@"user_name"];
    cell.detailTextLabel.text = [user objectForKey:@"user_password"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8080/ZLDemo/downloadImage2?file=%@", [user objectForKey:@"user_portrait"]]] placeholderImage:[UIImage imageNamed:@"app"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *user = [self.userArr objectAtIndex:indexPath.row];
        [ZLSession POST:@"http://localhost:8080/ZLDemo/delete" params:@{@"userId" : [user objectForKey:@"user_id"]} headers:nil completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                if ([result isEqualToString:@"1"]) {
                    hud.label.text = @"删除成功!";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadUserListNotification" object:nil];
                    
                } else {
                    hud.label.text = @"删除失败!";
                }
                
                [hud hideAnimated:YES afterDelay:1.3];
            });
        }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UpdateViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateIdentifier"];
    vc.user = [self.userArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
