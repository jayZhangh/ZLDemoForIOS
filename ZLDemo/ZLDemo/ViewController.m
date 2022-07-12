//
//  ViewController.m
//  ZLDemo
//
//  Created by ZhangLiang on 2022/7/9.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
