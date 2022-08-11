//
//  ReceiveChatViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/8/5.
//

#import "ReceiveChatViewController.h"
#import <HyphenateChat/EMClient.h>

@interface ReceiveChatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)receiveAction:(id)sender;

@end

@implementation ReceiveChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)receiveAction:(id)sender {
    NSString *text = ((EMTextMessageBody *)[[EMClient sharedClient].chatManager getConversationWithConvId:@"user2"].latestMessage.body).text;
    self.label.text = text;
}

@end
