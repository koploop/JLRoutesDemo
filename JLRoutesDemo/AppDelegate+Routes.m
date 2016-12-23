//
//  AppDelegate+Routes.m
//  JLRoutesDemo
//
//  Created by Weelh on 2016/12/21.
//  Copyright © 2016年 Weelh. All rights reserved.
//

#import "AppDelegate+Routes.h"
#import <JLRoutes/JLRoutes.h>
#import "SecondViewController.h"
#import "NSString+Appending.h"

@implementation AppDelegate (Routes)

#pragma mark - 普通的路由注册（路由地址以及参数都一一相对应）
- (void)registerRoutes_001 {
    [[JLRoutes globalRoutes] addRoute:@"/root/simple/:viewController/:bg_color/:userName" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        /*
        description of parameters:
        {
            JLRoutePattern = "/root/:viewController/:bg_color/:userName";
            JLRouteScheme = JLRoutesGlobalRoutesScheme;
            JLRouteURL = "JLRoutesDemo://root/SecondViewController/176,224,230,1/AlexKop";
            "bg_color" = "176,224,230,1";
            userName = AlexKop;
            viewController = SecondViewController;
         }
         */
        if (!parameters || !parameters[@"viewController"]) {
            return NO;
        }
        NSString *controllerKey = parameters[@"viewController"];
        NSString *bg_colorKey = parameters[@"bg_color"];
        NSString *userName = parameters[@"userName"];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecondViewController *secondViewController = [board instantiateViewControllerWithIdentifier:controllerKey];
        secondViewController.descriptionText = userName;
        UIColor *color = [self colorFromRGBAString:bg_colorKey];
        secondViewController.view.backgroundColor = color;
        [self.window.rootViewController presentViewController:secondViewController animated:YES completion:nil];
        return YES;
        
    }];
}

#pragma mark - 复杂的路由注册（路由地址对应，但是参数不对应）
- (void)registerRoutes_002 {
    [[JLRoutes globalRoutes] addRoute:@"/root/complex/:viewController/:bg_color/:userName" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        /*
         description of parameters:
         {
            JLRoutePattern = "/root/:viewController/:bg_color/:userName";
            JLRouteScheme = JLRoutesGlobalRoutesScheme;
            JLRouteURL = "JLRoutesDemo://root/SecondViewController/176,224,230,1/AlexKop?sex=boy&like=loli";
            "bg_color" = "176,224,230,1";
            like = loli;
            sex = boy;
            userName = AlexKop;
            viewController = SecondViewController;
         }
         */
        NSString *controllerKey = parameters[@"viewController"];
        NSString *bg_colorKey = parameters[@"bg_color"];
        NSString *userName = parameters[@"userName"];
        NSString *sex = parameters[@"sex"];
        NSString *like = parameters[@"like"];
        NSString *text = [userName appending:@" is a ",sex, @" who like ", like, nil];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecondViewController *secondViewController = [board instantiateViewControllerWithIdentifier:controllerKey];
        secondViewController.descriptionText = text;
        UIColor *color = [self colorFromRGBAString:bg_colorKey];
        secondViewController.view.backgroundColor = color;
        [self.window.rootViewController presentViewController:secondViewController animated:YES completion:nil];
        return YES;
        
    }];
}

#pragma mark - Schemes的匹配，自定义Scheme
- (void)registerRoutes_003 {
    [[JLRoutes routesForScheme:@"CustomeScheme"] addRoute:@"/root/simple/:viewController/:bg_color/:userName" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        NSString *controllerKey = parameters[@"viewController"];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecondViewController *secondViewController = [board instantiateViewControllerWithIdentifier:controllerKey];
        secondViewController.descriptionText = @"CustomeScheme";
        [self.window.rootViewController presentViewController:secondViewController animated:YES completion:nil];
        return YES;
    }];
    
    //这是一个不匹配的路由地址（root/complex并没有被注册到CustomeScheme中，它在globalScheme中注册）
    //当路由器发现CustomeScheme中没有root/complex路径但是global中有，下面这个参数可以告诉调度器去往GlobalScheme中匹配这个路径
    [JLRoutes routesForScheme:@"CustomeScheme"].shouldFallbackToGlobalRoutes = YES;
}

#pragma mark - Wildcard routes, 通配符匹配路由地址
- (void)registerRoutes_004 {
    //会匹配所有开头为wildcard的URL地址
    [[JLRoutes globalRoutes] addRoute:@"/wildcard/*" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        /*
        Printing description of parameters:
        {
            JLRoutePattern = "/wildcard/*";
            JLRouteScheme = JLRoutesGlobalRoutesScheme;
            JLRouteURL = "JLRoutesDemo://wildcard/notJoker/truth?viewController=SecondViewController&color=176,224,230,1&userName=AlexKop&sex=boy&like=Loli";
            JLRouteWildcardComponents =     (
                                             notJoker,
                                             truth
                                             );
            color = "176,224,230,1";
            like = Loli;
            sex = boy;
            userName = AlexKop;
            viewController = SecondViewController;
        }
        */
        NSArray *pathComponents = parameters[JLRouteWildcardComponentsKey];
        //如果第二个节点存在并且不是joker，则触发事件
        if ([pathComponents count] > 0 && ![pathComponents[0] isEqualToString:@"joker"]) {
            
            NSString *controllerKey = parameters[@"viewController"];
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SecondViewController *secondViewController = [board instantiateViewControllerWithIdentifier:controllerKey];
            secondViewController.descriptionText = @"Wildcard";
            [self.window.rootViewController presentViewController:secondViewController animated:YES completion:nil];
            return YES;
        }
        return NO;
    }];
}

#pragma mark - 可选参数(括号中为可选的注册参数，Router将会注册所有可能出现的排列形式)
- (void)registerRoutes_005 {
    [[JLRoutes globalRoutes] addRoute:@"/optional(/user/:name)(/location/:country)" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        /*
         下面的四种排列方式都将被注册
         - /optional/user/:name/location/:country
         - /optional/user/:name
         - /optional/location/:country
         - /optional
         */
        NSString *patter = parameters[JLRoutePatternKey];
        if ([patter rangeOfString:@"user"].location != NSNotFound && [patter rangeOfString:@"location"].location == NSNotFound) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SecondViewController *secondViewController = [board instantiateViewControllerWithIdentifier:@"SecondViewController"];
            secondViewController.descriptionText = [@"用户名:" appending:parameters[@"name"]];
            [self.window.rootViewController presentViewController:secondViewController animated:YES completion:nil];
            return YES;
        }
        if ([patter rangeOfString:@"user"].location == NSNotFound && [patter rangeOfString:@"location"].location != NSNotFound) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SecondViewController *secondViewController = [board instantiateViewControllerWithIdentifier:@"SecondViewController"];
            secondViewController.descriptionText = [@"地址:" appending:parameters[@"country"], nil];
            [self.window.rootViewController presentViewController:secondViewController animated:YES completion:nil];
            return YES;
        }
        return NO;
        
    }];
}


/*! 将RGBAString转为Color */
- (UIColor *)colorFromRGBAString:(NSString *)string {
    NSArray *rgbArr = [string componentsSeparatedByString:@","];
    return [UIColor colorWithRed:[rgbArr[0] integerValue]/255.0 green:[rgbArr[1] integerValue]/255.0 blue:[rgbArr[2] integerValue]/255.0 alpha:[rgbArr[3] floatValue]];
}

@end
