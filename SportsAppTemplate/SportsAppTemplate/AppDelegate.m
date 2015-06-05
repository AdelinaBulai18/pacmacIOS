//
//  AppDelegate.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-06.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import "AppDelegate.h"
#import "SidebarViewController.h"
#import "PKRevealController.h"
#import "TMCache.h"

@interface AppDelegate () <PKRevealing> {
    int heartbeatCount;
    NSDictionary *badgeInfo;
}

@end

@implementation AppDelegate

@synthesize frontNavigationController = _frontNavigationController;
@synthesize activeUser = _activeUser;
@synthesize activeView;
@synthesize activeStoryboard;
@synthesize modalPresent;
@synthesize lastActiveView;
@synthesize lastActiveStoryboard;
@synthesize notificationsAllowed = _notificationsAllowed;

+ (void)initialize
{
    //configure iRate
}

+ (BOOL)isRetina4InchDisplay {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        return NO;
    return (CGSizeEqualToSize([[UIScreen mainScreen] currentMode].size, CGSizeMake(640, 1136)));
}

- (void)setActiveUser:(NSString *)activeUser
{
    //NSLog(@"Setting new active user");
    _activeUser = activeUser;
    [self.persistStore setObject:activeUser forKey:@"lastActiveUser"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchedUser" object:self userInfo:nil];
    if (![self.activeView isEqualToString:@"unity"]) {
        [self showView:self.activeView fromStoryboard:self.activeStoryboard];
    }
}

- (void)setActiveUserPassively:(NSString *)activeUser
{
    _activeUser = activeUser;
    [self.persistStore setObject:activeUser forKey:@"lastActiveUser"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchedUser" object:self userInfo:nil];
}

- (void)setNotificationsAllowed:(BOOL)notificationsAllowed
{
    //NSLog(@"Set notification settings to %i was %i", notificationsAllowed, _notificationsAllowed);
    if (_notificationsAllowed != notificationsAllowed) {
        // Change it before the notice goes out
        _notificationsAllowed = notificationsAllowed;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSettingsChanged" object:self userInfo:nil];
    }
}

- (void)showView:(NSString *)identifier
{
    [self showView:identifier fromStoryboard:@"Main"];
}

- (void)showView:(NSString *)identifier fromStoryboard:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    self.lastActiveView = self.activeView;
    self.lastActiveStoryboard = self.activeStoryboard;
    self.activeView = identifier;
    self.activeStoryboard = storyboardName;
    UIViewController *viewToShow = [storyboard instantiateViewControllerWithIdentifier:identifier];
    UIViewController *dismiss = (UIViewController *)[self.frontNavigationController.viewControllers lastObject];
    if (dismiss != nil) [self.frontNavigationController popViewControllerAnimated:NO];
    [self.frontNavigationController pushViewController:viewToShow animated:YES];
    [[self revealController] showViewController:self.revealController.frontViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigated" object:self userInfo:nil];
}

- (void)showUnity:(NSString *)identifier
{
    self.lastActiveView = self.activeView;
    self.lastActiveStoryboard = self.activeStoryboard;
    self.activeView = @"unity";
    
       //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    //[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigated" object:self userInfo:nil];
    
    //[self.window bringSubviewToFront:(UIView *)self.unityView];
    //[self unityPause:NO];
    
    NSString *avatarParts = @"[]";
    NSString *avatarMeta = @"{}";
    SessionManager *sharedSession = [SessionManager sharedManager];
    if (sharedSession.avatarParts != nil) avatarParts = sharedSession.avatarParts;
    if (sharedSession.avatarMeta != nil) avatarMeta = sharedSession.avatarMeta;
    
    //NSString *jsonString = [NSString stringWithFormat:@"{\"username\":\"%@\",\"meta\":%@,\"avatarParts\":%@}", self.activeUser, avatarMeta, avatarParts];
    //NSLog(@"JSON From Local: %@", jsonString);
    //const char *param = [jsonString cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    NSString *soundEnabled = @"false";
    NSString *musicEnabled = @"false";
    if (sharedSession.soundEnabled) soundEnabled = @"true";
    if (sharedSession.musicEnabled) musicEnabled = @"true";
    
    //NSString *jsonSound = [NSString stringWithFormat:@"{\"soundEnabled\":%@,\"musicEnabled\":%@}", soundEnabled, musicEnabled];
    //NSLog(@"Sound Prefs JSON: %@", jsonSound);
    
    //UnitySendMessage("_JBF", "setAudioPreferences", [jsonSound cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    //UnitySendMessage("Avatar Loader", "LoadSettings", param);
}

- (void)unityPauseDelayed:(id)sender
{
    //[self unityPause:YES];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[super application:application didFinishLaunchingWithOptions:launchOptions];
    
    heartbeatCount = 0;
    self.modalPresent = NO;

    self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.persistStore = [[TMCache alloc] initWithName:@"app"];
    
    
    // Grab our storyboard and pull the sidebar and welcome screen so we can set up our initial views
    SidebarViewController *left = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"jbfSidebar"];
    self.frontNavigationController = [[UINavigationController alloc] init];

    // Style the navbar
    if([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) { //iOS7
        [[UINavigationBar appearance] setBarTintColor: kNavBarTintColor];
    }
    [[UIBarButtonItem appearance] setTintColor: kNavBarButtonColor];
    self.frontNavigationController.navigationBar.tintColor = kNavBarButtonColor;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes: @{
                                                            NSFontAttributeName : kFontNavBarButton,
                                                            UITextAttributeFont : kFontNavBarButton,
                                                            UITextAttributeTextColor : kNavBarButtonColor,
                                                            NSForegroundColorAttributeName : kNavBarButtonColor
                                                            } forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSFontAttributeName : kFontNavBarText,
                                                            UITextAttributeFont : kFontNavBarText,
                                                            UITextAttributeTextColor : kNavBarTextColor,
                                                            NSForegroundColorAttributeName : kNavBarTextColor
                                                            }];
    
    // Set up the sliding sidebar
    self.revealController = [PKRevealController revealControllerWithFrontViewController:self.frontNavigationController
                                                                     leftViewController:left];
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    // Defaults for multi-user
    self.activeView = @"jbfFridge";
    self.activeStoryboard = @"Main";
    
    NSString *lastActiveUser = [self.persistStore objectForKey:@"lastActiveUser"];
    if (lastActiveUser) {
        // DEPRECATED: Create a Guest user as a placeholder
        //(void)[SessionManager getManagerForUser:@"Guest"];
        self.activeUser = lastActiveUser;
    } else {
        self.activeUser = @"Guest";
    }
    
    // Share session across app (for logged in users' info)
    SessionManager *sharedSession = [SessionManager sharedManager];
    
       
//    // Find any existing sessions and set them as active so the user doesn't need to log in every time.
//    for (NXOAuth2Account *account in [[NXOAuth2AccountStore sharedStore] accounts]) {
//        //NSLog(@"%@", account);
//        NSString *curUsername = (NSString *)account.userData;
//        for (NSString *user in [SessionManager getUserList]) {
//            SessionManager *session = [SessionManager getManagerForUser:user];
//            //NSLog(@"%@ -- %@", curUsername, session.username);
//            if (session.username != nil && curUsername != NULL && [session.username isEqualToString:curUsername]) {
//                session.account = account;
//            }
//        }
//    };
    
    
      // Boot up Unity
    //[super startUnity:application];
    
    // Immediately pause Unity
    //[super unityPause:YES];
    
    // Add our application on top of unity
    //[[super window] addSubview:self.revealController.view];
    
    // Non-unity window init
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.revealController.view];
    self.window.rootViewController = self.revealController;
    
    // Unhide the status bar and re-orient the screen to portrait mode (Unity takes over these at first)
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    
    
    // If we're a guest and there are actual accounts on the device we need to force users to choose an existing account or create a new one
    
    [self checkNotificationSettings];
    
    // HANDLE NOTIFICATIONS
    [[NSNotificationCenter defaultCenter] addObserverForName:@"badgeAchieved" object:nil queue:nil usingBlock:^(NSNotification *note) {
        //NSLog(@"%@", note.userInfo);
              badgeInfo = note.userInfo;
        /*self.toast = [[ToastViewController alloc] initAndPopupOnView:(UIViewController *)self.frontNavigationController
                                                               title:@"Badge earned!"
                                                         description:[note.userInfo valueForKey:@"description"]
                                                              action:@selector(showBadgeInfo)];*/
        //[self.toast setTarget:self];
    }];
    
    /* For debugging apparent unity lockups. Not needed in production.
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(heartbeat:)
                                   userInfo:nil
                                    repeats:YES];*/
    
    return YES;
}


// Debugging function
- (void)heartbeat:(id)sender
{
    heartbeatCount++;
    NSLog(@"Heartbeat JBF: %i", heartbeatCount);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)revealController:(PKRevealController *)revealController didChangeToState:(PKRevealControllerState)state
{
    //NSLog(@"%@ (%d)", NSStringFromSelector(_cmd), (int)state);
}

- (void)revealController:(PKRevealController *)revealController willChangeToState:(PKRevealControllerState)next
{
    //PKRevealControllerState current = revealController.state;
    //BOOL showBar = (current == PKRevealControllerShowsFrontViewController);
    //[[UIApplication sharedApplication] setStatusBarHidden:showBar withAnimation:UIStatusBarAnimationSlide];
    //NSLog(@"%@ (%d -> %d)", NSStringFromSelector(_cmd), (int)current, (int)next);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // unity
    //[super applicationDidReceiveMemoryWarning:application];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // unity
    //[super applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // unity
    //[super applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // unity
    //[super applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // unity
    // [super applicationDidBecomeActive:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    /*UnityAppController *unityController = (UnityAppController*) [[UIApplication sharedApplication] delegate];
    if (![[unityController.window.subviews lastObject] isEqual:unityController.unityView]) {
        [unityController unityPause:YES];
    }*/

    [self checkNotificationSettings];
    SessionManager *sharedSession = [SessionManager sharedManager];
    
    /* Clearing stuff here is dangerous, sometimes it doesn't auto-refresh when coming back
    // Reset roster cache so we pull the latest ASAP
    sharedSession.cachedRoster = nil;
    */
    
    // Reset badge caches so we grab the latest achievements asap
    sharedSession.cachedBadges = nil;
    sharedSession.cachedHouseholdBadges = nil;
    
}

- (void)checkNotificationSettings
{
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone) {
        NSLog(@"Notifications have been disabled");
        self.notificationsAllowed = NO;
    } else {
        self.notificationsAllowed = YES;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // unity
    //[super applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // unity
    //[super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    //NSLog(@"My token is: %@", deviceToken);
    SessionManager *sharedSession = [SessionManager sharedManager];
    sharedSession.deviceTokenString = [self stringWithDeviceToken:deviceToken];

}

// Creates a string with the hex value of the device token
- (NSString*)stringWithDeviceToken:(NSData*)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // unity
    //[super application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"Failed to get token, error: %@", error);
    self.notificationsAllowed = NO;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // unity
    //[super application:application didReceiveRemoteNotification:userInfo];
    //NSLog(@"Remote notice: %@ Type: %@", userInfo, badgeInfo[@"type"]);
    
    NSString *pushType = [userInfo[@"type"] lowercaseString];
    
    // New Badges
    if ([pushType isEqualToString:@"newbadge"]) {
    }
    // A scheduled game is starting
    else if ([pushType isEqualToString:@"gamestart"]) {
        [self showView:@"jbfSchedule"];
    }
    
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    // unity
    //[super application:application didReceiveLocalNotification:notification];
    NSLog(@"Local notice: %@", notification);
}



@end
