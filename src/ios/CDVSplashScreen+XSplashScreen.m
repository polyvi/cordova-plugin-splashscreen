/*
 This file was modified from or inspired by Apache Cordova.

 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements. See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership. The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License. You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied. See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  CDVSplashScreen+XSplashScreen.m
//

#import <xFace/XUtils.h>
#import <xFace/XConstants.h>
#import <xFace/XVersionLabelFactory.h>

#import "CDVSplashScreen.h"

extern NSString* const kLaunchNotification;

@interface CDVSplashScreen ()

- (void)setVisible:(BOOL)visible;

- (void)updateImage;

@end

@implementation CDVSplashScreen (XSplashScreen)

- (void)pluginInitialize
{
    //只有default app才需要显示引擎默认splash
    if ([XUtils isDefaultAppWebView:self.webView]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"pageDidLoad") name:CDVPageDidLoadNotification object:self.webView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLaunchNotification:) name:kLaunchNotification object:nil];
        [self setVisible:YES];
    }
}

- (void) handleLaunchNotification:(NSNotification*)notification
{
    [self setVisible:YES];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    [self updateImage];
    [self addVersionLabel];
}

- (void)addVersionLabel
{
    UILabel *versionLabel = [XVersionLabelFactory createWithFrame:_imageView.frame];
    if(versionLabel)
    {
        for (UIView *subview in [_imageView subviews])
        {
            if ([subview isKindOfClass:[UILabel class]])
            {
                [subview removeFromSuperview];
                break;
            }
        }

        NSAssert(![[_imageView subviews] count], @"Expect no subviews before the version label is added!");
        [_imageView addSubview:versionLabel];
    }
}

- (NSString *)getImageName
{
    NSString *imageName = [XUtils getPreferenceForKey:CUSTOM_LAUNCH_IMAGE_FILE];
    if (!imageName.length) {
        imageName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchImageFile"];
    }

    return imageName;
}

@end
