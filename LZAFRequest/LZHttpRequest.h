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

typedef NS_ENUM(NSInteger,LZRequestStylle) {
    //get请求
    LZRequestStylleGET = 0,
    //post请求
    LZRequestStyllePOST,
};

@interface LZHttpRequest : NSObject

/**
 *  请求网络数据
 *
 *  @param requestURL   URL
 *  @param requestStyle 请求类型
 *  @param parmas       参数
 *  @param files        请求文件(图片)
 *  @param success      请求成功的block
 *  @param fail         请求失败的block
 *  @param cacheTimer   缓存时间-以秒算
 */
+ (void)requestURL:(NSString *)requestURL
        httpMethod:(LZRequestStylle)requestStyle
            params:(NSDictionary *)parmas
              file:(NSDictionary *)files
           success:(void (^)(id data))success
              fail:(void (^)(NSError *error))fail
        cacheTimer:(NSInteger)cacheTimer;




@end
