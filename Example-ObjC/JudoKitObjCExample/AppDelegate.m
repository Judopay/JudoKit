//
//  AppDelegate.m
//  JudoKitObjCExample
//
//  Created by Hamon Riazy on 18/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

#import "AppDelegate.h"
@import JudoKit;

#pragma warning "set your own token and secret to see testing results"
static NSString * const token   = @"<#YOUR TOKEN#>";
static NSString * const secret  = @"<#YOUR SECRET#>";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // initialize the SDK by setting it up with a token and a secret
    [JudoKit setToken:token andSecret:secret];
    
    // setting the SDK to Sandbox Mode - once this is set, the SDK wil stay in Sandbox mode until the process is killed
    [JudoKit sandboxed:YES];
    
    return YES;
}

@end
