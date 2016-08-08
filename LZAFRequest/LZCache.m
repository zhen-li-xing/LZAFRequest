//
//  LZCache.m
//  LZAFRequest
//
//  Created by 李震 on 16/8/8.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import "LZCache.h"
#import "NSString+Hashing.h"
static LZCache * cache = nil;

@implementation LZCache

+ (LZCache *)shareInstance{
    
    @synchronized(self){//给这个类上锁
        if (cache == nil) {
            cache = [[LZCache alloc] init];
        }
    }
    return cache;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    
    @synchronized(self){
        if (cache == nil) {
            cache = [super allocWithZone:zone];
        }
    }
    return cache;
}

- (id)init{
    if (self = [super init]) {
        myTime = 60;
    }
    
    return self;
}

//存数据   根据接口不同,保存文件,保存 NSData
- (void)saveWithData:(NSData *)data andNameString:(NSString *)urlString{
    //设置缓存路径
    NSString * path = [NSString stringWithFormat:@"%@/Documents/Cache/",NSHomeDirectory()];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    //根据路径创建文件
    BOOL isSuc = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isSuc) {
        NSLog(@"创建成功");
    }else{
        NSLog(@"创建失败");
    }
    
    //根据接口来加密,保存文件,区分文件
    //MD5:不可逆的
    //使用 md5进行加密,可以得到一个16进制的字符串,位数是32位
    //作用:将原文进行加密,得到固定字符串
    
    
    //更新成 MD5的字符串
    urlString = [urlString MD5Hash];
    
    //得到每个界面的缓存文件,根据接口
    NSString * filePath = [NSString stringWithFormat:@"%@%@",path,urlString];
    //立刻 将缓存数据写入硬盘
    BOOL isWrite = [data writeToFile:filePath atomically:YES];
    
    if (isWrite) {
        NSLog(@"写入缓存成功");
        
    }else{
        NSLog(@"写入缓存失败");
    }
    
    
    
}


//读取缓存
- (NSData *)getDataWithNameString:(NSString *)urlString Withtime:(NSInteger)cacheTimer{
    
    //根据接口取路径
    // 获取到 MD5字符串
    urlString = [urlString MD5Hash];
    
    NSString * path = [NSString stringWithFormat:@"%@/Documents/Cache/%@",NSHomeDirectory(),urlString];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    //判断路径下文件是否存在
    if (![manager fileExistsAtPath:path]) {
        return nil;
    }
    
    //比较缓存最后写入,和当前时间的差值
    NSTimeInterval timeIntervsl = [[NSDate date] timeIntervalSinceDate:[self getLastWriteFileDate:path]];
    
    if (timeIntervsl > cacheTimer) {
        return nil;
    }
    
    //如果符合要求,就读取路径下面的缓存文件
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    
    return data;
}
//获取缓存文件的最后写入时间
- (NSDate *)getLastWriteFileDate:(NSString *)path{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    //获取制定路径下面文件的 各种属性
    NSDictionary * dic = [manager attributesOfItemAtPath:path error:nil];
    
    
    return dic[NSFileModificationDate];
}

@end
