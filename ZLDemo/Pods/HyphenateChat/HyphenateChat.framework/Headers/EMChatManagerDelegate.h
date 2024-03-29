/*!
 *  \~chinese
 *  @header EMChatManagerDelegate.h
 *  @abstract 聊天相关代理协议类
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatManagerDelegate.h
 *  @abstract This protocol defines chat related callbacks
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "EMRecallMessageInfo.h"

@class EMMessage;
@class EMError;

/*!
 *  \~chinese
 *  聊天相关代理协议类
 *
 *  \~english
 *  Chat related callbacks
 */
@protocol EMChatManagerDelegate <NSObject>

@optional

#pragma mark - Conversation

/*!
 *  \~chinese
 *  会话列表发生变化代理
 *
 *  @param aConversationList  会话列表<EMConversation>
 *
 *  \~english
 *  Delegate method will be invoked when the conversation list has changed
 *
 *  @param aConversationList  Conversation  NSArray<EMConversation>
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList;

#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息代理
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving new messages
 *
 *  @param aMessages  Receivecd message NSArray<EMMessage>
 */
- (void)messagesDidReceive:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到Cmd消息代理
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving command messages
 *
 *  @param aCmdMessages  Command message NSArray<EMMessage>
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages;

/*!
 *  \~chinese
 *  收到已读回执代理
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving read acknowledgement in message list
 *
 *  @param aMessages  Acknowledged message NSArray<EMMessage>
 */
- (void)messagesDidRead:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到群消息已读回执代理
 *
 *  @param aMessages  已读消息列表<EMGroupMessageAck>
 *
 *  \~english
 *  Invoked when receiving read acknowledgement in message list
 *
 *  @param aMessages  Acknowledged message NSArray<EMGroupMessageAck>
 */
- (void)groupMessageDidRead:(EMMessage *)aMessage
                  groupAcks:(NSArray *)aGroupAcks;

/*!
 *  \~chinese
 *  所有群已读消息发生变化代理
 *
 *  \~english
 *  All group read messages count have changed
 *
 */
- (void)groupMessageAckHasChanged;

/**
 * \~chinese
 * 收到会话已读回调代理
 *
 * @param from  CHANNEL_ACK 发送方
 * @param to      CHANNEL_ACK 接收方
 *
 *  发送会话已读是我方多设备：
 *     则from参数值是“我方登录”id，to参数值是“会话方”会话id，此会话“会话方”发送的消息会全部置为已读isRead为YES
 *  发送会话已读是会话方：
 *     则from参数值是“会话方”会话id，to参数值是“我方登录”id，此会话“我方”发送的消息的isReadAck会全部置为YES
 *  注：此会话既会话方id所代表的会话
 *
 * \~english
 * received conversation read ack
 * @param from  the username who send channel_ack
 * @param to      the username who receive channel_ack
 *
 *  send conversaion read is our multiple devices:
 *       the value of the "FROM" parameter is current login ID, and the value of the "to" parameter is the conversaion ID. All the messages sent by the conversaion are set to read： "isRead" is set to YES.
 *  send conversaion read is The other party:
 *       the value of the "FROM" parameter is the conversaion ID, and the value of the "to" parameter is current login ID. The "isReaAck" of messages sent by login id in this session will all be set to YES.
 *  Note: This convsersaion is the convsersaion represented by the convsersaion id.
 *
 *
 */
- (void)onConversationRead:(NSString *)from to:(NSString *)to;

/*!
 *  \~chinese
 *  收到消息送达回执代理
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving delivered acknowledgement in message list
 *
 *  @param aMessages  Acknowledged message NSArray<EMMessage>
 */
- (void)messagesDidDeliver:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到消息撤回代理
 *
 *  @param aMessages  撤回消息信息列表<EMRecallMessageInfo>
 *
 *  \~english
 *  Delegate method will be invoked when receiving recall for message info list
 *
 *  @param aRecallMessagesInfo  Recall message info NSArray<EMRecallMessageInfo>
 */
- (void)messagesInfoDidRecall:(NSArray<EMRecallMessageInfo *> *)aRecallMessagesInfo;

/*!
 *  \~chinese
 *  消息状态发生变化代理
 *
 *  需要给发送消息的callback参数传入nil，此回调才会生效
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 *  \~english
 *  Invoked when message status has changed
 *
 *  @param aMessage  Message whose status has changed
 *  @param aError    Error info
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError;

/*!
 *  \~chinese
 *  消息附件状态发生改变代理
 *
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 *  \~english
 *  Invoked when message attachment status has changed
 *
 *  @param aMessage  Message attachment status has changed
 *  @param aError    Error
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError;


#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  收到消息撤回代理
 *
 *  @param aMessages  撤回消息列表<EMMessage>
 *
 *  \~english
 * Delegate method will be invoked when receiving recall for message list
 *
 *  @param aMessages  Recall message NSArray<EMMessage>
 */
- (void)messagesDidRecall:(NSArray *)aMessages __deprecated_msg("Use -messagesInfoDidRecall: instead");

/*!
 *  \~chinese
 *  会话列表发生变化代理
 *
 *  @param aConversationList  会话列表<EMConversation>
 *
 *  \~english
 *  The conversation list has changed
 *
 *  @param aConversationList  Conversation NSArray<EMConversation>
 */
- (void)didUpdateConversationList:(NSArray *)aConversationList __deprecated_msg("Use -conversationListDidUpdate: instead");

/*!
 *  \~chinese
 *  收到消息代理
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Received messages
 *
 *  @param aMessages  Message NSArray<EMMessage>
 */
- (void)didReceiveMessages:(NSArray *)aMessages __deprecated_msg("Use -messagesDidReceive: instead");

/*!
 *  \~chinese
 *  收到Cmd消息代理
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Received cmd messages
 *
 *  @param aCmdMessages  Cmd message NSArray<EMMessage>
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages __deprecated_msg("Use -cmdMessagesDidReceive: instead");

/*!
 *  \~chinese
 *  收到已读回执代理
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 *  \~english
 *  Received read acks
 *
 *  @param aMessages  Read acked message NSArray<EMMessage>
 */
- (void)didReceiveHasReadAcks:(NSArray *)aMessages __deprecated_msg("Use -messagesDidRead: instead");

/*!
 *  \~chinese
 *  收到消息送达回执代理
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 *  \~english
 *  Received deliver acks
 *
 *  @param aMessages  Deliver acked message NSArray<EMMessage>
 */
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages __deprecated_msg("Use -messagesDidDeliver: instead");

/*!
 *  \~chinese
 *  消息状态发生变化代理
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 *  \~english
 *  Message status has changed
 *
 *  @param aMessage  Message whose status changed
 *  @param aError    Error info
 */
- (void)didMessageStatusChanged:(EMMessage *)aMessage
                          error:(EMError *)aError __deprecated_msg("Use -messageStatusDidChange:error: instead");

/*!
 *  \~chinese
 *  消息附件状态发生改变代理
 *  
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 *  \~english
 *  Attachment status has changed
 *
 *  @param aMessage  Message whose attachment status changed
 *  @param aError    Error
 */
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)aMessage
                                     error:(EMError *)aError __deprecated_msg("Use -messageAttachmentStatusDidChange:error: instead");
@end
