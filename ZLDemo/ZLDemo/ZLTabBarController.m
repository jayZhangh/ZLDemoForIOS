//
//  ZLTabBarController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/28.
//

#import "ZLTabBarController.h"
#import "HomeViewController.h"
#import "MyViewController.h"

#define MainStoryboardWithVCName(identifier) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier]

@interface ZLTabBarController ()

@end

@implementation ZLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HomeViewController *homeVc = MainStoryboardWithVCName(@"HomeIdentifier");
    MyViewController *myVc = MainStoryboardWithVCName(@"MyIdentifier");
    
    [self addChildViewController:homeVc title:@"Home" image:@"home_normal" selectedImage:@"home_selected"];
    [self addChildViewController:myVc title:@"My" image:@"my_normal" selectedImage:@"my_selected"];
    [self addChildViewController:[[UIViewController alloc] init] title:@"Demo" image:@"my_normal" selectedImage:@"my_selected"];
    [self addChildViewController:[[UIViewController alloc] init] title:@"Demo" image:@"my_normal" selectedImage:@"my_selected"];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    childController.title = title;
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; ;
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:childController];
    [super addChildViewController:navVC];
}

@end
