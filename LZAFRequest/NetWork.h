//
//  LZHttpRequest.h
//  LZAFRequest
//
//  Created by 李震 on 16/7/25.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LZCache.h"

typedef NS_ENUM(NSInteger,NetworkStatus) {
    NetworkStatusNoNet = 0, //无网络
    NetworkStatusMobile,    //移动网络
    NetworkStatusWifi   //wifi网络
};

typedef NS_ENUM(NSInteger,NetworkMethod) {
    NetworkMethodPost = 0, //POST 请求
    NetworkMethodGet,      //GET 请求
};

@interface NetWork : NSObject

/** 当前网络是否可用：YES可用，NO不可用 */
@property (nonatomic, assign) BOOL currentNetworkStatus;

/** 当前网络环境 */
@property (nonatomic, assign) NetworkStatus netStatus;

/** 添加参数,设置登录失效后重新登录只弹出一次 */
@property (nonatomic,assign)NSInteger onceResponse;
    
    
/**
 *  开启手机网络的监听
 */
+ (void)startNotificationNetworkStatus;
    
/**
 *  返回当前网络是否可用
 */
+ (BOOL)getCurrentNetworkStatus;
    
/**
 *  返回当前的网络状态
 */
+ (NetworkStatus)returnCurrentNetworkStatus;
    
/**
 *  取消全部请求
 */
+ (void)cancelAllNetwork;
    
    
/**
 *  无附件的post请求，BaseUrl为默认地址
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)postRequestWithApi:(NSString*)api param:(id)param result:(void (^)(id data))resultData;
    
    
/**
 *  带有附件的post请求，BaseUrl为默认地址
 @param api 请求api地址
 @param param   请求参数
 @param files 请求上传的附件
 @param resultData  请求返回的数据
 */
+ (void)postRequestWithApi:(NSString*)api param:(id)param files:(id)files result:(void (^)(id data))resultData;
    
    
/**
 *  无附件的post请求，BaseUrl自定义
 @param baseUrl 请求服务器地址
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)postRequestBaseUrl:(NSString*)baseUrl api:(NSString *)api param:(id)param result:(void (^)(id))resultData;
    
    
/**
 *  带有附件的post请求，BaseUrl自定义
 @param baseUrl 请求服务器地址
 @param api 请求api地址
 @param param   请求参数
 @param files 请求上传的附件
 @param resultData  请求返回的数据
 */
+ (void)postRequestBaseUrl:(NSString*)baseUrl api:(NSString*)api param:(id)param files:(id)files result:(void (^)(id data))resultData;
    
    
/**
 *  无附件的get请求，BaseUrl为默认地址
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)getRequestWithApi:(NSString*)api param:(id)param result:(void (^)(id data))resultData;
    
    
/**
 *  无附件的get请求，BaseUrl自定义
 @param baseUrl 请求服务器地址
 @param api 请求api地址
 @param param   请求参数
 @param resultData  请求返回的数据
 */
+ (void)getRequestBaseUrl:(NSString*)baseUrl api:(NSString *)api param:(id)param result:(void (^)(id))resultData;






@end
