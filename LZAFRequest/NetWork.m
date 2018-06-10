//
//  LZHttpRequest.m
//  LZAFRequest
//
//  Created by 李震 on 16/7/25.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import "NetWork.h"
#import <objc/runtime.h>

#define RequestBaseUrl @"这里是域名"

@implementation NetWork

#pragma mark - 单例
+ (NetWork*)shareInstance
{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
    
#pragma mark - 开启手机网络的监听
+ (void)startNotificationNetworkStatus
{
    [NetWork shareInstance].currentNetworkStatus = NO;
    
    AFNetworkReachabilityManager *networkStatusManage = [AFNetworkReachabilityManager sharedManager];
    [networkStatusManage setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            NSLog(@"未识别的网络");
            [NetWork shareInstance].currentNetworkStatus = NO;
            [NetWork shareInstance].netStatus = NetworkStatusNoNet;
            break;
            case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"网络连接已断开");
            [NetWork shareInstance].currentNetworkStatus = NO;
            [NetWork shareInstance].netStatus = NetworkStatusNoNet;
            break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"当前网络为移动网络");
            [NetWork shareInstance].currentNetworkStatus = YES;
            [NetWork shareInstance].netStatus = NetworkStatusMobile;
            break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"当前网络为Wifi网络");
            [NetWork shareInstance].currentNetworkStatus = YES;
            [NetWork shareInstance].netStatus = NetworkStatusWifi;
            break;
            default:
            break;
        }
    }];
    [networkStatusManage startMonitoring];
}
    
#pragma mark - 返回当前网络是否可用
+ (BOOL)getCurrentNetworkStatus
{
    return [NetWork shareInstance].currentNetworkStatus;
}
    
    
#pragma mark - 返回当前的网络状态
+ (NetworkStatus)returnCurrentNetworkStatus
{
    return [NetWork shareInstance].netStatus;
}
    
#pragma mark - 取消全部请求
+ (void)cancelAllNetwork
{
    [[NetWork shareInstance] cancelRequest];
}
    
#pragma mark - 队列管理容器
- (NSMutableDictionary *)taskQueue
{
    NSMutableDictionary * taskDic = objc_getAssociatedObject(self, @selector(addTask:));
    if (!taskDic) {
        taskDic = @{}.mutableCopy;
        objc_setAssociatedObject(self, @selector(addTask:), taskDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskDic;
}
    
#pragma mark - 添加队列
- (void)addTask:(NSURLSessionDataTask *)task
{
    NSMutableDictionary * taskQueue = [self taskQueue];
    [taskQueue setObject:task forKey:@(task.taskIdentifier)];
}
    
#pragma mark - 删除队列
- (void)removeTask:(NSURLSessionDataTask *)task
{
    if ([self isRequesting]) {
        NSMutableDictionary * taskQueue = [self taskQueue];
        [taskQueue removeObjectForKey:@(task.taskIdentifier)];
    }
}
    
#pragma mark - 判断有没有执行中的队列
- (BOOL)isRequesting
{
    NSMutableDictionary * taskDic = objc_getAssociatedObject(self, @selector(addTask:));
    if (taskDic.allValues.count > 0) {
        return YES;
    }
    return NO;
}
    
#pragma mark - 取消请求
- (void)cancelRequest
{
    if ([self isRequesting]) {
        NSMutableDictionary * taskQueue = [self taskQueue];
        [taskQueue enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (((NSURLSessionDataTask *)obj).state != NSURLSessionTaskStateCompleted ) {
                [((NSURLSessionDataTask *)obj) cancel];
            }
        }];
        
    }
}
    
#pragma mark - 无附件的post请求，BaseUrl为默认地址
/**
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)postRequestWithApi:(NSString *)api param:(id)param result:(void (^)(id))resultData
{
    NSMutableDictionary * para = [[NSMutableDictionary alloc] initWithDictionary:param];
    [[NetWork shareInstance] eRequestBaseUrl:RequestBaseUrl api:api method:NetworkMethodPost param:para files:nil result:resultData];
}
    
#pragma mark - 带有附件的post请求，BaseUrl为默认地址
/**
 @param api 请求api地址
 @param param   请求参数
 @param files 请求上传的附件
 @param resultData  请求返回的数据
 */
+ (void)postRequestWithApi:(NSString *)api param:(id)param files:(id)files result:(void (^)(id))resultData
{
    NSMutableDictionary * para = [[NSMutableDictionary alloc] initWithDictionary:param];
    [[NetWork shareInstance] eRequestBaseUrl:RequestBaseUrl api:api method:NetworkMethodPost param:para files:files result:resultData];
}
    
#pragma mark - 无附件的post请求，BaseUrl自定义
    /**
     @param baseUrl 请求服务器地址
     @param api 请求api地址
     @param param   请求参数
     @param resultData  请求返回的数据
     */
+ (void)postRequestBaseUrl:(NSString*)baseUrl api:(NSString *)api param:(id)param result:(void (^)(id))resultData
{
    [[NetWork shareInstance] eRequestBaseUrl:baseUrl api:api method:NetworkMethodPost param:param files:nil result:resultData];
}
    
#pragma mark - 带有附件的post请求，BaseUrl自定义
/**
 @param baseUrl 请求服务器地址
 @param api 请求api地址
 @param param   请求参数
 @param files 请求上传的附件
 @param resultData  请求返回的数据
 */
+ (void)postRequestBaseUrl:(NSString*)baseUrl api:(NSString*)api param:(id)param files:(id)files result:(void (^)(id data))resultData
{
    [[NetWork shareInstance] eRequestBaseUrl:baseUrl api:api method:NetworkMethodPost param:param files:files result:resultData];
}
    
#pragma mark - 无附件的get请求，BaseUrl为默认地址
/**
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)getRequestWithApi:(NSString*)api param:(id)param result:(void (^)(id data))resultData
{
    [[NetWork shareInstance] eRequestBaseUrl:RequestBaseUrl api:api method:NetworkMethodGet param:param files:nil result:resultData];
}
    
#pragma mark - 无附件的get请求，BaseUrl自定义
/**
 @param baseUrl 请求服务器地址
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)getRequestBaseUrl:(NSString*)baseUrl api:(NSString *)api param:(id)param result:(void (^)(id))resultData
{
    [[NetWork shareInstance] eRequestBaseUrl:baseUrl api:api method:NetworkMethodGet param:param files:nil result:resultData];
}
    
    
#pragma mark -  网络请求
/**
 @param baseUrl 请求服务器地址
 @param api 请求api地址
 @param method 请求方式 ( POST/GET )
 @param param   请求参数
 @param files 请求上传的附件
 @param resultData  请求返回的数据
 */
- (void)eRequestBaseUrl:(NSString*)baseUrl api:(NSString *)api method:(NetworkMethod)method param:(id)param files:(id)files result:(void (^)(id))resultData
{
    AFHTTPSessionManager *manager  = [self requestHeaderWithApi:api];
    NSLog(@"[请求参数] ===> [%@]",param);
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSLog(@"[请求地址] ===> [%@]",requestUrl);
    if (!files) {
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    switch (method) {
        case NetworkMethodGet:
        [self eGetRequestManager:manager url:requestUrl params:param result:resultData];
        break;
        case NetworkMethodPost:
        [self ePostRequestManager:manager url:requestUrl params:param files:files result:resultData];
        break;
        default:
        NSLog(@"[未知的请求方式，请检查请求设置]");
        break;
    }
}
    
#pragma mark - POST请求
- (void)ePostRequestManager:(AFHTTPSessionManager*)manager url:(NSString*)url params:(id)param files:(id)files result:(void (^)(id))resultData
{
    NSURLSessionDataTask *requestTask;
    __weak __typeof(&*self)weakSelf = self;
    
    if (files) {//有附带文件的请求  这里是传图片
        requestTask = [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if ([files isKindOfClass:[NSDictionary class]]) {
                NSArray *array = [files allKeys];
                NSMutableArray * arrayKey = [[NSMutableArray alloc] initWithArray:array];
                NSInteger count = array.count;
                for (int i = 0; i < count; i++) {
                    for (int j = 0; j < count - i - 1; j++) {
                        NSString * strr = arrayKey[j];
                        NSString * nextStrr = arrayKey[j + 1];
                        if ([strr compare:nextStrr options:NSForcedOrderingSearch] == 1) {
                            [arrayKey exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                        }
                    }
                }
                
                int i = 0;
                for (id key in arrayKey) {
                    
                    //获取上传的所有图片
                    NSData *Imagearr = files[key];
                    
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    
                    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
                    //转为字符型
                    NSString *timeString = [NSString stringWithFormat:@"%f", a];
                    
                    NSString *filename = [NSString stringWithFormat:@"%@.jpeg",timeString];
                    
                    [formData appendPartWithFileData:Imagearr
                                                name:key
                                            fileName:filename
                                            mimeType:@"image/jpeg"];
                    
                    i++;
                }
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"请求ing......");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"[请求成功] ===> [%@]",responseObject);
            
            [self removeTask:task];
            
            NSDictionary *dic = [NSDictionary dictionary];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                dic = [NSDictionary dictionaryWithDictionary:responseObject];
            } else if ([responseObject isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }
            
            resultData(dic);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"[请求失败] ===> [%@]",error.userInfo);
            [weakSelf removeTask:task];
            if (resultData){
                NSDictionary *errDict = @{@"status":@"12332",@"msg":@"请求失败了..."};
                resultData(errDict);
            }
        }];
    } else {
        
        requestTask = [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"请求ing......");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"[请求成功] ===> [%@]",responseObject);
            [weakSelf removeTask:task];
            
            NSDictionary *dic = [NSDictionary dictionary];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                dic = [NSDictionary dictionaryWithDictionary:responseObject];
            } else if ([responseObject isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            }
            
            resultData(dic);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"[请求失败] ===> [%@]",error);
            [self removeTask:task];
            if (resultData){
                NSDictionary *errDict = @{@"status":@"12332",@"msg":@"请求失败了..."};
                resultData(errDict);
            }
        }];
    }
    [self addTask:requestTask];
}
    
#pragma mark - GET请求
- (void)eGetRequestManager:(AFHTTPSessionManager*)manager url:(NSString*)url params:(id)param result:(void (^)(id))resultData
{
    NSURLSessionDataTask *requestTask = [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"请求ing......");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeTask:task];
        if (resultData) {
            resultData(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"[请求失败] ===> [%@]",error.userInfo);
        [self removeTask:task];
        if (resultData) {
            NSDictionary *errDict = @{@"status":@"12332",@"msg":@"请求失败了..."};
            resultData(errDict);
        }
    }];
    [self addTask:requestTask];
}
    
    
#pragma mark - 设置请求header
- (AFHTTPSessionManager *)requestHeaderWithApi:(NSString *)api
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:RequestBaseUrl]];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //设置请求超时
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json",@"text/plain",@"text/html", @"text/javascript", @"text/json", @"application/x-www-form-urlencoded; charset=utf-8",@"multipart/form-data", nil];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    //传json的话
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //请求头里要加的一些东西
//        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
    return manager;
}
    
#pragma mark - 设置证书
- (AFSecurityPolicy*)customSecurityPolicy
{
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"证书名" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData,nil];
    return securityPolicy;
}


@end
