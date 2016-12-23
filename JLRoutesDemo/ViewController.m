//
//  ViewController.m
//  JLRoutesDemo
//
//  Created by Weelh on 16/10/27.
//  Copyright © 2016年 Weelh. All rights reserved.
//

#import "ViewController.h"
#import <JLRoutes/JLRoutes.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)tapAction:(UIButton *)sender {
    
#pragma mark - 普通的路由注册（路由地址以及参数都一一相对应）
    /*
     NSString *color = @"176,224,230,1";
     NSString *customUrl = [NSString stringWithFormat:@"JLRoutesDemo://root/simple/SecondViewController/%@/AlexKop", color];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customUrl]];
     */
    
#pragma mark - 复杂的路由注册（路由地址对应，但是参数不对应）
    /*
    NSString *color = @"176,224,230,1";
    NSString *customUrl = [NSString stringWithFormat:@"JLRoutesDemo://root/complex/SecondViewController/%@/AlexKop?sex=boy&like=Loli", color];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customUrl]];
     */
    
#pragma mark - Schemes的匹配，自定义Scheme
    /*
    NSString *color = @"176,224,230,1";
    NSString *customUrl = [NSString stringWithFormat:@"CustomeScheme://root/simple/SecondViewController/%@/AlexKop?sex=boy&like=Loli", color];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customUrl]];
     */
    
    
#pragma mark - 这是一个不匹配的路由地址（root/complex并没有被注册到CustomeScheme中，它在globalScheme中注册）
    /*
    NSString *color = @"176,224,230,1";
    NSString *customUrl = [NSString stringWithFormat:@"CustomeScheme://root/complex/SecondViewController/%@/AlexKop?sex=boy&like=Loli", color];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customUrl]];
     */
    
#pragma mark - 通配符（路由地址的统配）
    /*
    NSString *customUrl = [NSString stringWithFormat:@"JLRoutesDemo://wildcard/notJoker/truth?viewController=SecondViewController&color=176,224,230,1&userName=AlexKop&sex=boy&like=Loli"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customUrl]];
    */
    
#pragma mark - 可选参数
    NSString *customUrl = [NSString stringWithFormat:@"JLRoutesDemo://optional/user/AlexKop"];
    NSString *customUrl2 = [NSString stringWithFormat:@"JLRoutesDemo://optional/location/China"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customUrl2]];
}


@end
