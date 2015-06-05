//
//  AppDelegate.h
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-06.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "TMCache.h"

@interface AppDelegate : NSObject  <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *frontNavigationController;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;


@property (nonatomic, strong) NSString *activeUser;
@property (nonatomic, strong) NSString *activeView;
@property (nonatomic, strong) NSString *activeStoryboard;
@property (nonatomic, strong) NSString *lastActiveView;
@property (nonatomic, strong) NSString *lastActiveStoryboard;
@property (nonatomic) BOOL notificationsAllowed;

@property (nonatomic) BOOL modalPresent;
@property (nonatomic, strong) TMCache *persistStore;

- (void)setActiveUserPassively:(NSString *)activeUser;
- (void)showView:(NSString *)identifier;
- (void)showView:(NSString *)identifier fromStoryboard:(NSString *)storyboardName;
- (void)showUnity:(NSString *)identifier;
- (void)unityPauseDelayed:(id)sender;
+ (BOOL)isRetina4InchDisplay;

@end

