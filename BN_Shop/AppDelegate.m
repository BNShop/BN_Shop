//
//  AppDelegate.m
//  BN_Shop
//
//  Created by newman on 16/11/11.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

        NSDictionary *paraDic = @{
                                  @"phoneNum":@"18006015791",
                                  @"passwd":@"123456",
                                  @"deviceSystemType":@(2),
                                  @"deviceId":@"12354222009090890987"
                                  };
        
        NSString *url = [NSString stringWithFormat:@"%@/mime/login",BASEURL];
        
        [[BC_ToolRequest sharedManager] POST:url parameters:paraDic
                                     success:^(NSURLSessionDataTask *operation, id responseObject){

                                         
                                         NSDictionary *dict = (NSDictionary*)responseObject;
                                         
                                         NSLog(@"responseObject = %@",dict);
                                         if ([dict isKindOfClass:[NSDictionary class]]) {
                                             int code = [[dict objectForKey:@"code"] intValue];
                                             
                                             if (code == 0) {
                                                 NSDictionary *result = [dict objectForKey:@"result"];
                                                 if (result && [result isKindOfClass:[NSDictionary class]]) {
                                                     [BC_ToolRequest sharedManager].token = [result objectForKey:@"token"];
                                                 }
                                                 
                                             }
                                         }
                                         
                                     } failure:^(NSURLSessionDataTask *operation, NSError *error){
                                         
                                         NSLog(@"error = %@",error);

                                     }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
