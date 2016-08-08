//
//  LZHttpRequest.m
//  LZAFRequest
//
//  Created by 李震 on 16/7/25.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import "LZHttpRequest.h"

@implementation LZHttpRequest

+ (void)requestURL:(NSString *)requestURL
        httpMethod:(LZRequestStylle)requestStyle
            params:(NSDictionary *)parmas
              file:(NSDictionary *)files
           success:(void (^)(id data))success
              fail:(void (^)(NSError *error))fail
        cacheTimer:(NSInteger)cacheTimer{
    
    //判断是否存在缓存,根据接口
    //获取单例
    LZCache * cache = [LZCache shareInstance];
    //传入接口判断缓存
    NSData * data = [cache getDataWithNameString:requestURL Withtime:cacheTimer];
    if (data) {
        success(data);
    }else{
        //1.构造操作对象管理者
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        //2.设置解析格式，默认json
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        //设置相应内容类型
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/html", @"text/javascript", @"text/json", @"application/x-www-form-urlencoded; charset=utf-8", nil];
        
        ///存储格式为二进制
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //get请求
        if (requestStyle == 0) {
            [manager GET:requestURL
              parameters:parmas
                progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                }
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (success)
                     {
                         //先将接口数据保存到缓存中
                        [[LZCache shareInstance] saveWithData:responseObject andNameString:requestURL];
                         
                         success(responseObject);
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (fail != nil) {
                         fail(error);
                     }
                 }];
        }else if (requestStyle == 1){
            //post请求 不带文件
            if (files == nil) {
                
                [manager POST:requestURL
                   parameters:parmas
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if (success) {
                              //先将接口数据保存到缓存中
                              [[LZCache shareInstance] saveWithData:responseObject andNameString:requestURL];
                              
                              success(responseObject);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if (fail) {
                              fail(error);
                          }
                      }];
                
                
            } else {//post请求 带文件
                
                [manager POST:requestURL
                   parameters:parmas
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *array = [files allKeys];
        
        int i = 0;
        
        for (id key in array) {
            
            //获取上传的所有图片
            NSData *Imagearr = files[key];
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            
            NSTimeInterval a=[dat timeIntervalSince1970]*1000;
            //转为字符型
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            
            NSString *filename = [NSString stringWithFormat:@"%@.png",timeString];
            
            [formData appendPartWithFileData:Imagearr
                                        name:key
                                    fileName:filename
                                    mimeType:@"image/png"];
            
            i++;
        }
        
    }                progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            //先将接口数据保存到缓存中
            [[LZCache shareInstance] saveWithData:responseObject andNameString:requestURL];
            
            success(responseObject);
        }
        
    }                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
        
    }];
                
                
            }

        }
        
        
        
    }
    
    
    
    
    
    
}


@end
