//
//  HomeViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/16.
//

#import "HomeViewController.h"
#import "ViewController.h"
#import "SessionViewController.h"

#define kViewController @"ViewConotroller"
#define kNSURLSession @"NSURLSession"
#define kAVPlayer @"AVPlayer"
#define kLogin @"Login"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *homeArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeArr = @[kViewController, kNSURLSession, kAVPlayer, kLogin];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.homeArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellIdentiier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HomeCellIdentiier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.homeArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellTitle = [self.homeArr objectAtIndex:indexPath.row];
    NSString *vcIdentifier = nil;
    
    if ([cellTitle isEqualToString:kViewController]) {
        vcIdentifier = @"VCIdentifier";
    }else if ([cellTitle isEqualToString:kNSURLSession]) {
        vcIdentifier = @"SessionIdentifier";
    } else if ([cellTitle isEqualToString:kAVPlayer]) {
        vcIdentifier = @"PlayerIdentifier";
    } else if ([cellTitle isEqualToString:kLogin]) {
        vcIdentifier = @"LoginIdentifier";
    }
    
    if ([vcIdentifier length] > 0) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:vcIdentifier];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
