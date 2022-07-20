//
//  ZLSession.h
//  ZLSession
//
//  Created by ZhangLiang on 2022/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLSession : NSObject

+ (void)GET:(NSString *)url params:(NSDictionary * __nullable)params completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

+ (void)POST:(NSString *)url params:(NSDictionary * __nullable)params headers:(NSDictionary * __nullable)headers completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

+ (void)POST:(NSString *)url params:(NSDictionary * __nullable)params headers:(NSDictionary * __nullable)headers imagesData:(NSArray *)imagesData completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
