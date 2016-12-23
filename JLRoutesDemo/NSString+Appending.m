//
//  NSString+Appending.m
//  JLRoutesDemo
//
//  Created by Weelh on 2016/12/21.
//  Copyright © 2016年 Weelh. All rights reserved.
//

#import "NSString+Appending.h"

@implementation NSString (Appending)

/*! 拼接多个字符串 */
- (NSString *)appending:(NSString *)str,... {
    va_list arguements;
    va_start(arguements, str);
    NSString *resultString = self;
    
    //循环中循环的是...的参数，不包含第一个参数str,所以第一个要手动提交或者叫赋值
    NSString *arg = str;
    resultString = [resultString stringByAppendingString:str];
    
    while ((arg = va_arg(arguements, NSString *))) {
        resultString = [resultString stringByAppendingString:arg];
    }
    va_end(arguements);
    return resultString;
}

@end
