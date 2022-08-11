//
//  ChatViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/8/5.
//

#import "ChatViewController.h"
#import <HyphenateChat/EMClient.h>
#import <HyphenateChat/EMMessage.h>

@interface ChatViewController ()
- (IBAction)sendAction:(id)sender;
- (IBAction)createAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)receiveAction:(id)sender;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)receiveAction:(id)sender {
    NSLog(@"%@", ((EMTextMessageBody *)[[EMClient sharedClient].chatManager getConversationWithConvId:@"user2"].latestMessage.body).text);
}

- (IBAction)loginAction:(id)sender {
    [[EMClient sharedClient] loginWithUsername:@"user1" password:@"123" completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"%@ - %@", aUsername, aError);
        }];
}

- (IBAction)createAction:(id)sender {
    [[EMClient sharedClient] registerWithUsername:@"user1" password:@"123" completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"%@ - %@", aUsername, aError);
        }];
}

- (IBAction)sendAction:(id)sender {
    EMTextMessageBody *messageBody = [[EMTextMessageBody alloc] initWithText:@"你好，My Name is Zhang."];
    EMMessage *sendMessage = [[EMMessage alloc] initWithConversationID:@"user2" from:@"user1" to:@"user2" body:messageBody ext:@{}];
    [[EMClient sharedClient].chatManager sendMessage:sendMessage progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"%d - %@", message.status, error);
        }];
}

- (void)dealloc {
}

@end
