//
//  SidebarViewController.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-09.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import "SidebarViewController.h"
#import "PKRevealController.h"
#import "UnityAppController.h"
#import "SessionManager.h"
//#import "NXOAuth2.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AppDelegate.h"

#import "ViewController.h"
#import "TurfRunnerViewController.h"


@interface SidebarViewController () {
    IBOutlet UILabel *appName;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *background;
    IBOutlet UIImageView *userAvatarMini;
    IBOutlet UIButton *switchUser;
    
    AppDelegate *app;
}

- (IBAction)showHome:(id)sender;
- (IBAction)showSample:(id)sender;
- (IBAction)showDeveloperGame:(id)sender;

@end

@implementation SidebarViewController{
    SessionManager *session;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    session = [SessionManager sharedManager];
    appName.text = session.username;
    
    if ([AppDelegate isRetina4InchDisplay]) {
        [background setImage:[UIImage imageNamed:@"SidebarBackgroundR4"]];
    }
    
    appName.text = kAppName;
    for (UILabel *lbl in self.view.subviews)
    {
        if ([lbl isMemberOfClass:[UILabel class]]) {
            [lbl setFont:kFontSidebarText];
            lbl.textColor = kColorSidebarText;
        }
    }
    for (id lbl in [[scrollView.subviews firstObject] subviews])
    {
        if ([lbl isMemberOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)lbl;
            [btn.titleLabel setFont:kFontSidebarButton];
            [btn setTitleColor:kColorSidebarButton forState:UIControlStateNormal];
        }
    }
    [self.view setBackgroundColor:kColorSidebarBackground];
    
    [switchUser.titleLabel setFont:kFontSidebarSwitchButton];
    [switchUser setTitleColor:kColorSidebarSwitchButton forState:UIControlStateNormal];
    
}



- (IBAction)showHome:(id)sender {
    [app showView:@"jbfFridge"];
}

- (IBAction)showSample:(id)sender {
    [app showView:@"jbfSample"];
}

- (IBAction)showDeveloperGame:(id)sender {
   // [app showView:@"jbfDeveloperGame"];
    ViewController *zamboni = [[ViewController alloc] init];
    [self presentViewController:zamboni animated:YES completion:^{
        //
    }];
}


-(IBAction)showFootballGame:(id)sender
{
    TurfRunnerViewController *football = [[TurfRunnerViewController alloc] init];
    [self presentViewController:football animated:YES completion:^{
        //
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
