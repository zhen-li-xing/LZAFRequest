//
//  LZCache.h
//  LZAFRequest
//
//  Created by 李震 on 16/8/8.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZCache : NSObject

{
    NSTimeInterval myTime;
}

//创建单例
+ (LZCache *)shareInstance;

//读取缓存
- (NSData *)getDataWithNameString:(NSString *)urlString Withtime:(NSInteger)cacheTimer;


//存数据   根据接口不同,保存文件,保存 NSData
- (void)saveWithData:(NSData *)data andNameString:(NSString *)urlString;

@end
