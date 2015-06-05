//
//  CTAPostStoryViewController.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-07-17.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import "CTAPostStoryViewController.h"
#import "AppDelegate.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "Constants.h"

@interface CTAPostStoryViewController () {
    IBOutlet UIImageView *backgroundView;
}

- (IBAction)showRegister:(id)sender;
- (IBAction)haveAccount:(id)sender;

@end

@implementation CTAPostStoryViewController

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
    for (id lbl in self.view.subviews)
    {
        if ([lbl isMemberOfClass:[UIButton class]]) {
            UIButton *curObj = (UIButton *)lbl;
            [curObj.titleLabel setFont:kFontCTAButton];
            if (curObj.tag == 0) {
                [curObj setTitleColor:kColorCTAButton forState:UIControlStateNormal];
            }
        } else if ([lbl isMemberOfClass:[UILabel class]]) {
            UILabel *curObj = (UILabel *)lbl;
            if (curObj.tag == 1) {
                [curObj setFont:kFontCTATitleLabel];
                curObj.textColor = kColorCTATitleLabel;
            } else {
                [curObj setFont:kFontCTALabel];
                curObj.textColor = kColorCTALabel;
            }
        }
    }
    [self.view setBackgroundColor:kColorCTABackground];
    
    UIImage *backImage = [[UIImage imageNamed:@"CTAPostStoryBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(123, 140, 200, 140)];
    [backgroundView setImage:backImage];
    
    CGRect backFrame = self.view.frame;
    backFrame.origin.y += 64;
    backFrame.size.height -= 64;
    
    backgroundView.frame = backFrame;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Call to Action: Post Story"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRegister:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showView:@"jbfRegister"];
}

- (IBAction)haveAccount:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showView:@"jbfLogin"];
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
