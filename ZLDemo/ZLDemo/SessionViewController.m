//
//  SessionViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/16.
//

#import "SessionViewController.h"
#import "SDWebImage.h"
#import "AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface SessionViewController () <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NSURLSession";
    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"%ld", status);
//    }];
//    [manager startMonitoring];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self POST:@"http://localhost:8080/ZLDemo/uploadImage2" params:@{@"name1":@"张三",@"name2":@"李四"} filesData:@[UIImageJPEGRepresentation([UIImage imageNamed:@"app"], 1), UIImageJPEGRepresentation([UIImage imageNamed:@"IMG_20220603_153040"], 1)] completionBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"OK");
//    }];
    
    [self afnPost];
}

- (void)afnPost {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://localhost:8080/ZLDemo/login" parameters:@{@"name1":@"李四",@"name2":@"张三",@"name3":@"张三waq"} headers:@{@"userName":@"aaa"} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
}

- (void)POST:(NSString *)url params:(NSDictionary *)params filesData:(NSArray *)filesData completionBlock:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data;boundary=boundary" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *fromData = [[NSMutableData alloc] init];
    
    // 上传参数
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [fromData appendData:[[NSString stringWithFormat:@"--boundary\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n", key, obj] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 上传文件
    for (NSData *fileData in filesData) {
        [fromData appendData:[@"--boundary\r\nContent-Disposition:form-data;name=\"images\";filename=\"image.png\"\r\nContent-Type:application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fromData appendData:fileData];
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


- (void)httpGetData {
    NSString *str = @"http://localhost:8080/ZLDemo/uploadImage";
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置Header参数
    [request setValue:@"testHeader" forHTTPHeaderField:@"testHeader"];
    
    //设置Body值方法二，这种方法比较原始，不常用，不过可以用来上传参数和文件
//    NSString *BOUNDARY = @"0xKhTmLbOuNdArY";
    NSString *BOUNDARY = @"boundary";
    [request setValue:[@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    
    //多参数上送
    NSString *param1 = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",BOUNDARY,@"name1",@"李四",nil];
    [body appendData:[param1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *param2 = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",BOUNDARY,@"name2",@"张三",nil];
    [body appendData:[param2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    //多文件上传
    UIImage *image1 = [UIImage imageNamed:@"IMG_20220603_153040"];
    NSData *data1 = UIImageJPEGRepresentation(image1, 1.0);
    NSString *file1 = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,@"logoFile",@"image.png",nil];
    [body appendData:[file1 dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data1];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *image2 = [UIImage imageNamed:@"app"];
    NSData *data2 = UIImageJPEGRepresentation(image2, 1.0);
    NSString *file2 = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,@"imageFile",@"image.png",nil];
    [body appendData:[file2 dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data2];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //body结束分割线
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"OK");
            }] resume];
}

- (void)setImageView {
//    [self.imv setImageWithURL:[NSURL URLWithString:@"https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"] placeholderImage:[UIImage imageNamed:@"app"]];
    
    [self.imv sd_setImageWithURL:[NSURL URLWithString:@"https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"] placeholderImage:[UIImage imageNamed:@"app"]];
}

- (void)activityIndicatorView {
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    view.color = [UIColor redColor];
    view.hidesWhenStopped = YES;
    view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
//    view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    [self.view addSubview:view];
    [view startAnimating];
}

- (void)AFNUpload {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://localhost:8080/ZLDemo/uploadImage2" parameters:@{@"name1":@"李四",@"name2":@"张三"} headers:@{@"userName":@"张三李四王五aaa"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation([UIImage imageNamed:@"IMG_20220603_153040"], 1) name:@"file" fileName:@"fileName.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

- (void)getImage {
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/ZLDemo/downloadImage?file=app.png"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) wekself = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data scale:1];
            wekself.imv.image = image;
        });
        
    }];
    [dataTask resume];
}

- (void)downloadImage {
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/ZLDemo/downloadImage?file=IMG_20220603_153040.jpg"];
    NSURLSession *downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDownloadTask *downloadTask = [downloadSession downloadTaskWithURL:url];
    [downloadTask resume];
}

- (void)postImage {
    NSString *urlStr = @"http://localhost:8080/ZLDemo/downloadImage";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:60];
    // 默认是get请求
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    request.HTTPBody = [@"file=IMG_20220603_153040.jpg" dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = [@"file=app.png" dataUsingEncoding:NSUTF8StringEncoding];
    
    // 使用全局session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *img = [UIImage imageWithData:data scale:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imv.image = img;
        });
    }];
    [dataTask resume];
}

- (void)uploadImage {
    // 1.创建url  采用Apache本地服务器
    NSString *urlString = @"http://localhost:8080/ZLDemo/uploadImage";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"boundary"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSData* data = [self getHttpBodyWithFilePath:@"/Users/jayZhang/Desktop/img/IMG_20220603_153040.jpg" formName:@"file" reName:@"newName.jpg"];

    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
    }] resume];
}

- (void)uploadMIME2 {
    // 创建url
    NSString *urlString = @"http://localhost:8080/ZLDemo/uploadImage";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"multipart/form-data; boundary=boundary" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *data = [NSMutableData data];
    
    // 1.参数上送
    NSString *param1 = @"--boundary\r\nContent-Disposition: form-data;name=\"name1\"\r\n\r\n李四\r\n";
    [data appendData:[param1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *param2 = @"--boundary\r\nContent-Disposition:form-data;name=\"name2\"\r\n\r\n张亮\r\n";
    [data appendData:[param2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2.多文件上传
    NSString *file1 = @"--boundary\r\nContent-Disposition:form-data;name=\"logoFile\";filename=\"image.png\"\r\nContent-Type:application/octet-stream\r\n\r\n";
    [data appendData:[file1 dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:UIImageJPEGRepresentation([UIImage imageNamed:@"app"], 1)];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *file2 = @"--boundary\r\nContent-Disposition:form-data;name=\"logoFile\";filename=\"image.png\"\r\nContent-Type:application/octet-stream\r\n\r\n";
    [data appendData:[file2 dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:UIImageJPEGRepresentation([UIImage imageNamed:@"IMG_20220603_153040"], 1)];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // footer
    [data appendData:[@"--boundary--" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%lu", [data length]] forHTTPHeaderField:@"Content-Length"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"success");
        } else {
            NSLog(@"error");
        }
    }] resume];
}

- (void)uploadMIME {
    // 1.创建url  采用Apache本地服务器
    NSString *urlString = @"http://localhost:8080/ZLDemo/uploadImage2";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"boundary"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // 3.拼接表单，大小受MAX_FILE_SIZE限制(2MB)  FilePath:要上传的本地文件路径  formName:表单控件名称，应于服务器一致
    NSData* data = [self getHttpBodyWithFilePath:@"/Users/jayZhang/Desktop/img/IMG_20220603_153040.jpg" formName:@"file" reName:@"newName.jpg"];

    request.HTTPBody = data;
    // 根据需要是否提供，非必须,如果不提供，session会自动计算
    [request setValue:[NSString stringWithFormat:@"%lu",data.length] forHTTPHeaderField:@"Content-Length"];
 
    // 4.1 使用dataTask
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }

    }] resume];
}

/// filePath:要上传的文件路径   formName：表单控件名称  reName：上传后文件名
- (NSData *)getHttpBodyWithFilePath:(NSString *)filePath formName:(NSString *)formName reName:(NSString *)reName
{
    NSMutableData *data = [NSMutableData data];
    NSURLResponse *response = [self getLocalFileResponse:filePath];
    // 文件类型：MIMEType  文件的大小：expectedContentLength  文件名字：suggestedFilename
    NSString *fileType = response.MIMEType;
 
    // 如果没有传入上传后文件名称,采用本地文件名!
    if (reName == nil) {
        reName = response.suggestedFilename;
    }
 
    // 表单拼接
    NSMutableString *headerStrM =[NSMutableString string];
    [headerStrM appendFormat:@"--%@\r\n",@"boundary"];
    // name：表单控件名称  filename：上传文件名
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",formName,reName];
    [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n",fileType];
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
 
    // 文件内容
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
 
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n",@"boundary"];
    [data appendData:[footerStrM  dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"dataStr=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    return data;
}
 
/// 获取响应，主要是文件类型和文件名
- (NSURLResponse *)getLocalFileResponse:(NSString *)urlString
{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    // 本地文件请求
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
    __block NSURLResponse *localResponse = nil;
    // 使用信号量实现NSURLSession同步请求
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        localResponse = response;
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return  localResponse;
}

#pragma mark - NSURLSessionDownloadDelegate
/**
 下载完成后调用，默认是tmp目录下，下载完成后会自动删除，所以需要自己手动移动到Documents
 session : 当前下载的会话
 downloadTask : 当前下载的任务
 location : 默认临时文件的存储路径
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"下载完成\n下载文件的路径: %@", location);
    NSData *data = [[NSData alloc] initWithContentsOfURL:location];
    NSLog(@"%@", [UIImage imageWithData:data]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imv.image = [UIImage imageWithData:data];
    });
    
//    NSString *pathStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    // 下载的文件必须改个名字才能转存到documents目录
//    pathStr = [pathStr stringByAppendingString:@"/downloadFile.jpg"];
//    NSLog(@"documents目录: %@", pathStr);
//    NSError *error;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:pathStr]) {
//        [fileManager removeItemAtPath:pathStr error:nil];
//    }
//
//    BOOL isSuccess = [fileManager moveItemAtPath:location.path toPath:pathStr error:&error];
//    if (!isSuccess) {
//        NSLog(@"错误信息: %@\n失败原因: %@\n恢复建议: %@", error.userInfo, error.localizedFailureReason, error.localizedRecoverySuggestion);
//    }
    
//    NSArray *files = [fileManager contentsOfDirectoryAtPath:pathStr error:nil];
//    NSArray *files = [fileManager subpathsAtPath:pathStr];
//    NSArray *files = [fileManager subpathsOfDirectoryAtPath:pathStr error:nil];
//    for (int i = 0; i < [files count]; i++) {
//        NSString *file = [files objectAtIndex:i];
//        NSLog(@"%@", file);
//    }
}

/**
 下载过程中调用
 bytesWritten 单次下载大小
 totalBytesWritten 当前一共下载的大小
 totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"下载进度: %f", totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
}

/**
 下载恢复时调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"didResumeAtOffset");
}

#pragma mark - NSURLSessionTaskDelegate
/**
 不管成功失败，都会调用，只是失败的时候error有值
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWithError");
}

@end
