//
//  SampleGameViewController.m
//  SportsAppTemplate
//
//  Created by Daniel Sexton on 2015-04-21.
//  Copyright (c) 2015 Just Be Friends Network. All rights reserved.
//

#import "SampleGameViewController.h"
#import "GameManager.h"
#import "MyScene.h"


@implementation SampleGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


-(IBAction)showMenu:(id)sender{
    [self.revealController showViewController:self.revealController.leftViewController];
}

@end
