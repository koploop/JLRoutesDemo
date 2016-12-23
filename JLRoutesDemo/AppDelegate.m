//
//  AppDelegate.m
//  JLRoutesDemo
//
//  Created by Weelh on 16/10/27.
//  Copyright © 2016年 Weelh. All rights reserved.
//

#import "AppDelegate.h"
#import <JLRoutes.h>
#import "AppDelegate+Routes.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册路由表
    [self registerRoutes_001];
    [self registerRoutes_002];
    [self registerRoutes_003];
    [self registerRoutes_004];
    [self registerRoutes_005];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"从哪个app跳转而来 Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
    NSLog(@"URL scheme:%@", [url scheme]);
    
#pragma mark - GlobalRoutes（默认的Scheme）
    if ([[url scheme] isEqualToString:@"JLRoutesDemo"]) {

        return [[JLRoutes globalRoutes] routeURL:url];
    }
    
#pragma mark - CustomeRoute
    if ([[url scheme] isEqualToString:@"CustomeScheme"]) {
        
        return [[JLRoutes routesForScheme:@"CustomeScheme"] routeURL:url];
    }
    
    return NO;
}




/*
 //iOS9+
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
 NSLog(@"从哪个app跳转而来 Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
 NSLog(@"URL scheme:%@", [url scheme]);
 return YES;
 }
 
 //iOS9-
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 NSLog(@"从哪个app跳转而来 Bundle ID: %@", sourceApplication);
 NSLog(@"URL scheme:%@", [url scheme]);
 return YES;
 }
 */

@end
