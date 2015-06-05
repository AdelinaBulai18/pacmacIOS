//
//  HomeViewController.m
//  SportsAppTemplate
//
//  Created by Daniel Sexton on 2015-04-20.
//  Copyright (c) 2015 Just Be Friends Network. All rights reserved.
//

#import "HomeViewController.h"
#import "GameManager.h"

@interface HomeViewController ()
-(IBAction)showMenu:(id)sender;

@end


@implementation HomeViewController{
    GameManager* gameManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)showMenu:(id)sender{
    [self.revealController showViewController:self.revealController.leftViewController];
}

@end
