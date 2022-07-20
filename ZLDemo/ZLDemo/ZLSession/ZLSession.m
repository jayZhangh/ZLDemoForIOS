//
//  ZLSession.m
//  ZLSession
//
//  Created by ZhangLiang on 2022/7/17.
//

#import "ZLSession.h"

@implementation ZLSession

+ (void)GET:(NSString *)url params:(NSDictionary * __nullable)params completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock {
    // 参数
    NSMutableString *paramsStrM = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [paramsStrM appendFormat:@"%@=%@&", key, obj];
    }];
    
    if ([paramsStrM length] > 0) {
        [paramsStrM deleteCharactersInRange:NSMakeRange([paramsStrM length] - 1, 1)];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@?%@", url, paramsStrM] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            completionBlock(data, response, error);
        }
    }] resume];
}

+ (void)POST:(NSString *)url params:(NSDictionary * __nullable)params headers:(NSDictionary * __nullable)headers completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock {
    // 参数
    NSMutableString *paramsStrM = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [paramsStrM appendFormat:@"%@=%@&", key, obj];
    }];
    
    if ([paramsStrM length] > 0) {
        [paramsStrM deleteCharactersInRange:NSMakeRange([paramsStrM length] - 1, 1)];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramsStrM dataUsingEncoding:NSUTF8StringEncoding]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            completionBlock(data, response, error);
        }
    }] resume];
}

+ (void)POST:(NSString *)url params:(NSDictionary * __nullable)params headers:(NSDictionary * __nullable)headers imagesData:(NSArray *)imagesData completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data;boundary=boundary" forHTTPHeaderField:@"Content-Type"];
    NSMutableData *fromData = [[NSMutableData alloc] init];
    
    // 1.上传参数
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [fromData appendData:[[NSString stringWithFormat:@"--boundary\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n", key, obj] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 2.上传文件
    for (NSData *imageData in imagesData) {
        [fromData appendData:[@"--boundary\r\nContent-Disposition:form-data;name=\"images\";filename=\"image.png\"\r\nContent-Type:application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fromData appendData:imageData];
        [fromData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [fromData appendData:[@"--boundary--" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:fromData];
    [request setValue:[NSString stringWithFormat:@"%lu", [fromData length]] forHTTPHeaderField:@"Content-Length"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            completionBlock(data, response, error);
        }
    }] resume];
}

@end
