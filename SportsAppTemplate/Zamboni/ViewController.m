  //
//  ViewController.m
//  ZamboniRun
//
//  Created by Laurentiu on 25/05/15.
//  Copyright (c) 2015 Laurentiu. All rights reserved.
//
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

#import "SidebarViewController.h"
#import "PKRevealController.h"
#import "UnityAppController.h"
#import "SessionManager.h"
#import "SampleGameViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    //GAME SCREEN
    AVAudioPlayer *audioPlayer;
    NSArray *mapArray;
    NSArray *firstZombiePath;
    NSArray *secondZombiePath;
    NSArray *thirdZombiePath;
    UIImageView *mazeImage ;
    NSString *currentMovinDirection;
    NSString *futureMovinDirection;
    UIImageView *player;
    UIImageView *zombieZomboni1;
    UIImageView *zombieZomboni2;
    UIImageView *zombieZomboni3;
    UIButton *startGameButton;
    int playerXPos;
    int playerYPos;
    bool isMoving;
    int pointsCounter;
    int gearParts;
    int counterZombie1;
    int counterZombie2;
    int counterZombie3;
    BOOL gameOn;
    int topBarHeight;
    
    //FirstScreen
    UIImageView *bkImage;
    UIButton *playButton;
    UIButton *howToButton;
    
    
    //GAME ENDED SCREEN
    UIImageView *backgroundImage;
    UIImageView *scoreBackgroundImage;
    UILabel *currentScoreLabel;
    UILabel *bestScoreLabel;
    UIButton *tryAgainButton;
    UIImageView *shareImage;
    
    //HOW TO screen
    UIImageView *howToImage;
    UIButton *dismissHowToScreen;
    UIImageView *howToScreenBackground;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        topBarHeight = 62;
    else
        topBarHeight = 120;
    
    // Do any additional setup after loading the view from its nib.
    //Set the navigation controller bar to transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    //GAME SCREEN
    // Do any additional setup after loading the view from its nib.
    isMoving = NO;
    playerXPos = 3;
    playerYPos = 18;
    gearParts = 0;
    pointsCounter = 0;
    counterZombie1 = -1;
    counterZombie2 = -1;
    counterZombie3 = -1;
    gameOn = YES;
    
    //add view holder
    UIView *holder = [[UIView alloc]initWithFrame:CGRectMake(0.f, topBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    [self.view addSubview:holder];
    
    
    
    //add maze runner
    mazeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, holder.frame.size.width, holder.frame.size.height)];
    mazeImage.contentMode = UIViewContentModeScaleToFill;
    mazeImage.image = [UIImage imageNamed:@"Maze-runner.png"];
    mazeImage.layer.borderWidth = 2;
    mazeImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [holder addSubview:mazeImage];
    
    
    //Create walkable tiles array
    mapArray = [NSArray new];
    mapArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MapArray" ofType:@"plist"]];
    NSLog(@"mapArray = %@", mapArray);
    
    
    int puckTag = 5000;
    int gearTag = 100;
    
    //for each ellement in array check if has image
    for (int counterLine = 0; counterLine < mapArray.count; counterLine++) {
        NSArray *lineArray = [NSArray new];
        lineArray = [mapArray objectAtIndex:counterLine];
        for (int counterCollumn = 0; counterCollumn < lineArray.count; counterCollumn++) {
            
            NSDictionary *collumnDictionary = [NSDictionary new];
            collumnDictionary = [lineArray objectAtIndex:counterCollumn];
            
            //add pucks
            bool puckOnIt = [[collumnDictionary objectForKey:@"puckOnIt"] boolValue];
            if(puckOnIt == YES){
                
                //drow puck on the right possition by giving position in arrays, image name of the gear, and unique tag
                UIImageView *puckImage = [UIImageView new];
                puckImage.image = [UIImage imageNamed:@"puck@2x.png"];
                float width = mazeImage.frame.size.width / lineArray.count;
                float height = mazeImage.frame.size.height / mapArray.count;
                NSLog(@"maze image: %f", mazeImage.frame.size.height);
                float xPos = counterCollumn * width + width/4;
                float yPos = counterLine * height + height/4;
                puckImage.frame = CGRectMake(xPos, yPos, width/2, height/2);////////
                puckImage.tag = puckTag;
                puckImage.contentMode = UIViewContentModeScaleAspectFit;
                [mazeImage addSubview:puckImage];
            }
            
            //add gear
            NSString *gearString = [NSString new];
            gearString = [collumnDictionary objectForKey:@"gearOnIt"];
            if(![gearString  isEqual: @"NO"]){
                
                //drow gear on the right possition by giving position in arrays, image name of the gear, and unique tag
                UIImageView *gearImage = [UIImageView new];
                gearImage.image = [UIImage imageNamed:gearString];
                float width = mazeImage.frame.size.width / lineArray.count;
                float height = mazeImage.frame.size.height / mapArray.count;
                float xPos = counterCollumn * width;
                float yPos = counterLine * height;
                gearImage.frame = CGRectMake(xPos, yPos, width, height);
                gearImage.tag = gearTag;
                gearImage.contentMode = UIViewContentModeScaleAspectFit;
                [mazeImage addSubview:gearImage];
            }
            puckTag = puckTag + 1;
            gearTag = gearTag + 1;
            
        }
        
    }
    
    
    //add swipe animation
    UISwipeGestureRecognizer* right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    UISwipeGestureRecognizer* left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer* up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:up];
    
    UISwipeGestureRecognizer* down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:down];
    
    //add player initial image and save position
    player = [[UIImageView alloc] initWithFrame:CGRectMake( (mazeImage.frame.size.width / 11) * playerXPos, (mazeImage.frame.size.height / mapArray.count) * (playerYPos -1), mazeImage.frame.size.width / 11, (mazeImage.frame.size.height / mapArray.count) * 2.f)];
    player.image = [UIImage imageNamed:@"player@2x.png"];
    player.contentMode = UIViewContentModeScaleAspectFit;
    [mazeImage addSubview:player];
    
    //add zombieZomboni 1
    zombieZomboni1 = [[UIImageView alloc] initWithFrame:CGRectMake((mazeImage.frame.size.width/ 11) * 3, (mazeImage.frame.size.height/ 19) * 5, mazeImage.frame.size.width / 11, mazeImage.frame.size.height / 19)];
    zombieZomboni1.image = [UIImage imageNamed:@"zamboni@2x.png"];
    zombieZomboni1.contentMode = UIViewContentModeScaleAspectFit;
    [mazeImage addSubview:zombieZomboni1];
    
    //create firt zombie object array path
    firstZombiePath = [NSArray new];
    firstZombiePath = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZombiZamboni1Path" ofType:@"plist"]];
    
    
    
    
    //add zombieZomboni 2
    zombieZomboni2 = [[UIImageView alloc] initWithFrame:CGRectMake((mazeImage.frame.size.width/ 11) * 3, (mazeImage.frame.size.height/ 19), mazeImage.frame.size.width / 11, mazeImage.frame.size.height / 19)];
    zombieZomboni2.image = [UIImage imageNamed:@"zamboni@2x.png"];
    zombieZomboni2.contentMode = UIViewContentModeScaleAspectFit;
    [mazeImage addSubview:zombieZomboni2];
    
    //create second zombie object array path
    secondZombiePath = [NSArray new];
    secondZombiePath = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZombiZamboni2Path" ofType:@"plist"]];
    
    
    
    //add zombieZomboni 3
    zombieZomboni3 = [[UIImageView alloc] initWithFrame:CGRectMake((mazeImage.frame.size.width/ 11) * 3, (mazeImage.frame.size.height/ 19) * 3, mazeImage.frame.size.width / 11, mazeImage.frame.size.height / 19)];
    zombieZomboni3.image = [UIImage imageNamed:@"zamboni@2x.png"];
    zombieZomboni3.contentMode = UIViewContentModeScaleAspectFit;
    [mazeImage addSubview:zombieZomboni3];
    
    //create third zombie object array path
    thirdZombiePath = [NSArray new];
    thirdZombiePath = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZombiZamboni3Path" ofType:@"plist"]];
    
    
    
    //add play screen
    ///add play game button
    startGameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    [startGameButton addTarget:self action:@selector(startGameButtonFunstion) forControlEvents:UIControlEventTouchUpInside];
    [startGameButton setHidden:NO];
    [self.view addSubview: startGameButton];
    
    //add button backgroun image
    UIImageView *playGameButtonBackgrounImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, topBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    playGameButtonBackgrounImage.image = [UIImage imageNamed:@"Maze-runner.png"];
    playGameButtonBackgrounImage.contentMode = UIViewContentModeScaleAspectFill;
    [startGameButton addSubview:playGameButtonBackgrounImage];
    
    //add button backgroun player
    UIImageView *playGameButtonBackgrounPLayerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, topBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    playGameButtonBackgrounPLayerImage.image = [UIImage imageNamed:@"collect@2x.png"];
    playGameButtonBackgrounPLayerImage.contentMode = UIViewContentModeScaleAspectFit;
    [startGameButton addSubview:playGameButtonBackgrounPLayerImage];
    
    //FIRST SCREEN
    // Do any additional setup after loading the view from its nib.
    bkImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, topBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    bkImage.image = [UIImage imageNamed:@"welcome_bg.png"];
    [self.view addSubview:bkImage];
    
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.1f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.35f, ([UIScreen mainScreen].bounds.size.height - topBarHeight)* 0.1f)];
    [playButton setBackgroundImage:[UIImage imageNamed:@"play@2x.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    howToButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.6f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.35f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.1f)];
    [howToButton setBackgroundImage:[UIImage imageNamed:@"how@2x.png"] forState:UIControlStateNormal];
    [howToButton addTarget:self action:@selector(displayHowToScreenButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:howToButton];
    
    
    //GAME ENDED SCREEN
    //add background image
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, topBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    backgroundImage.contentMode = UIViewContentModeScaleToFill;
    backgroundImage.image = [UIImage imageNamed:@"bg.png"];
    [backgroundImage setHidden:YES];
    [self.view addSubview:backgroundImage];
    
    //add score image
    scoreBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.1f * [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.2f, [UIScreen mainScreen].bounds.size.width * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.8f * 0.364f)];
    scoreBackgroundImage.contentMode = UIViewContentModeScaleToFill;
    scoreBackgroundImage.image = [UIImage imageNamed:@"score@2x.png"];
    [scoreBackgroundImage setHidden:YES];
    [self.view addSubview:scoreBackgroundImage];
    
    //add score label
    currentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.1f * [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.22f, [UIScreen mainScreen].bounds.size.width * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.8f * 0.182f)];
//    currentScoreLabel.text = [NSString stringWithFormat:@"this turn: %@ pucks!", self.score];
    currentScoreLabel.textColor = [UIColor darkGrayColor];
    currentScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:25];
    currentScoreLabel.transform = CGAffineTransformMakeRotation(  ( -2 * M_PI ) / 180 );
    currentScoreLabel.textAlignment = NSTextAlignmentCenter;
    [currentScoreLabel setHidden:YES];
    [self.view addSubview:currentScoreLabel];
    
    //add best score label
    bestScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.1f * [UIScreen mainScreen].bounds.size.width, scoreBackgroundImage.frame.origin.y + scoreBackgroundImage.frame.size.height/2.f, [UIScreen mainScreen].bounds.size.width * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.8f * 0.182f)];
//    bestScoreLabel.text = [NSString stringWithFormat:@"your best: %@ pucks!", self.score];
    bestScoreLabel.textColor = [UIColor darkGrayColor];
    bestScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:25];
    bestScoreLabel.transform = CGAffineTransformMakeRotation(  ( -2 * M_PI ) / 180 );
    bestScoreLabel.textAlignment = NSTextAlignmentCenter;
    [bestScoreLabel setHidden:YES];
    [self.view addSubview:bestScoreLabel];
    
    //add try again button
    tryAgainButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.1f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.42f, [UIScreen mainScreen].bounds.size.width * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.8f * 0.348)];
    [tryAgainButton setBackgroundImage:[UIImage imageNamed:@"try_again@2x.png"] forState:UIControlStateNormal];
    [tryAgainButton addTarget:self action:@selector(tryAgainButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [tryAgainButton setHidden:YES];
    [self.view addSubview:tryAgainButton];
    
    //add share image
    shareImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.1f, ([UIScreen mainScreen].bounds.size.height - topBarHeight)* 0.62f, [UIScreen mainScreen].bounds.size.width * 0.8f, [UIScreen mainScreen].bounds.size.width * 0.8f * 0.624)];
    shareImage.image = [UIImage imageNamed:@"share@2x.png"];
    [shareImage setHidden:YES];
    [self.view addSubview:shareImage];
    
    //HOW TO screen
    howToScreenBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - topBarHeight)];
    howToScreenBackground.image = [UIImage imageNamed:@"bg.png"];
    [howToScreenBackground setHidden:YES];
    howToScreenBackground.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:howToScreenBackground];
    
    howToImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.1f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.1f, [UIScreen mainScreen].bounds.size.width * 0.8f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.8f)];
    howToImage.image = [UIImage imageNamed:@"howto@2x.png"];
    [howToImage setHidden:YES];
    howToImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:howToImage];
    
    dismissHowToScreen = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.75f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.1f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.1f, ([UIScreen mainScreen].bounds.size.height - topBarHeight) * 0.1f)];
    dismissHowToScreen.backgroundColor =[UIColor greenColor];
    [dismissHowToScreen setHidden:YES];
    [dismissHowToScreen addTarget:self action:@selector(dismissHowToScreenButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissHowToScreen];
    
    
    UIView *btnView = [[UIView alloc] init];
    [btnView setFrame:CGRectMake(0, 0, self.view.frame.size.width, topBarHeight)];
    [btnView setBackgroundColor:[UIColor colorWithRed:220/255.0 green:51/255.0 blue:63/255.0 alpha:1.0]];
    
    UILabel *lbName = [[UILabel alloc] init];
    [lbName setFrame:CGRectMake(0, topBarHeight * 0.5, self.view.frame.size.width, topBarHeight/3)];
    [lbName setTextColor:[UIColor whiteColor]];
    [lbName setText:@"Pacman Hockey"];
    lbName.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:lbName];
    
    UIButton *btnBack = [[UIButton alloc] init];
    [btnBack setFrame:CGRectMake(topBarHeight/4 , topBarHeight * 0.4, topBarHeight * 0.37, topBarHeight * 0.37)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"1 (1).png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackPress:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btnBack];
    
    [self.view addSubview:btnView];
    
}


-(void)btnBackPress:(id)sender
{
    NSLog(@"back press");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)displayHowToScreenButtonFunction{

    [howToScreenBackground setHidden:NO];
    [howToImage setHidden:NO];
    [dismissHowToScreen setHidden:NO];
    [playButton setHidden:YES];
    [howToButton setHidden:YES];
    [bkImage setHidden:YES];

}

- (void)dismissHowToScreenButtonFunction{

    [howToScreenBackground setHidden:YES];
    [howToImage setHidden:YES];
    [dismissHowToScreen setHidden:YES];
    [playButton setHidden:NO];
    [howToButton setHidden:NO];
    [bkImage setHidden:NO];

}

- (void)startGame{

   //hide all necessary UI ellements
    [bkImage setHidden:YES];
    [playButton setHidden:YES];
    [howToButton setHidden:YES];
    
}

- (void)tryAgainButtonFunction{

    isMoving = NO;
    playerXPos = 3;
    playerYPos = 18;
    gearParts = 0;
    pointsCounter = 0;
    counterZombie1 = -1;
    counterZombie2 = -1;
    counterZombie3 = -1;
    gameOn = YES;
    currentMovinDirection = nil;
    futureMovinDirection = nil;
    
    //make all gear part and pucks visible again
    //for each ellement in array check if has image
    int puckTag = 5000;
    int gearTag = 100;
    for (int counterLine = 0; counterLine < mapArray.count; counterLine++) {
        NSArray *lineArray = [NSArray new];
        lineArray = [mapArray objectAtIndex:counterLine];
        for (int counterCollumn = 0; counterCollumn < lineArray.count; counterCollumn++) {
            
            NSDictionary *collumnDictionary = [NSDictionary new];
            collumnDictionary = [lineArray objectAtIndex:counterCollumn];
            
            //add pucks
            bool puckOnIt = [[collumnDictionary objectForKey:@"puckOnIt"] boolValue];
            if(puckOnIt == YES){
                
                UIImageView *puckImageViewReconstructor = (UIImageView *)[self.view viewWithTag:puckTag];
                [puckImageViewReconstructor setHidden:NO];
                
            }
            
            //add gear
            NSString *gearString = [NSString new];
            gearString = [collumnDictionary objectForKey:@"gearOnIt"];
            if(![gearString  isEqual: @"NO"]){
                
                //drow puck on the right possition by giving position in arrays, image name of the gear, and unique tag
                UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:gearTag];
                [gearImageViewRecconstructor setHidden:NO];
                
            }
            puckTag = puckTag + 1;
            gearTag = gearTag + 1;
            
        }
        
    }
    
    
    
    
    //set the frames to initaial possition
    [player setFrame:CGRectMake( (mazeImage.frame.size.width / 11) * playerXPos, (mazeImage.frame.size.height / mapArray.count) * (playerYPos -1), mazeImage.frame.size.width / 11, (mazeImage.frame.size.height / mapArray.count) * 2.f)];
    [zombieZomboni1 setFrame:CGRectMake((mazeImage.frame.size.width/ 11) * 3, (mazeImage.frame.size.height/ 19) * 5, mazeImage.frame.size.width / 11, mazeImage.frame.size.height / 19)];
    [zombieZomboni2 setFrame:CGRectMake((mazeImage.frame.size.width/ 11) * 3, (mazeImage.frame.size.height/ 19), mazeImage.frame.size.width / 11, mazeImage.frame.size.height / 19)];
    [zombieZomboni3 setFrame:CGRectMake((mazeImage.frame.size.width/ 11) * 3, (mazeImage.frame.size.height/ 19) * 3, mazeImage.frame.size.width / 11, mazeImage.frame.size.height / 19)];
    
    [startGameButton setHidden:NO];
    
    
    [self hideEndGameScreen];
    
    playerXPos = 3;
    playerYPos = 18;
}

- (void)displayEndGameScreen{

    gameOn = NO;
    [currentScoreLabel setHidden:NO];
    [bestScoreLabel setHidden:NO];
    [tryAgainButton setHidden:NO];
    [shareImage setHidden:NO];
    [backgroundImage setHidden:NO];
    [scoreBackgroundImage setHidden:NO];
    [currentScoreLabel setText:[NSString stringWithFormat:@"this turn: %d pucks!", pointsCounter]];
    //best score
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *bestScore = [defaults objectForKey:@"bestScoreViewController"];
    if(bestScore != nil)
    {
        int score = [bestScore intValue];
        int current = pointsCounter;
        if(current > score)
        {
            //set currentscore as best
            NSString *currentString = [NSString stringWithFormat:@"%d", current];
            [defaults setObject:currentString forKey:@"bestScoreViewController"];
        }
    }
    else
    {
        NSString *currentString = [NSString stringWithFormat:@"%d", pointsCounter];
        [defaults setObject:currentString forKey:@"bestScoreViewController"];
    }
    NSString *best = [defaults objectForKey:@"bestScoreViewController"];
    [bestScoreLabel setText:[NSString stringWithFormat:@"your best: %@ pucks!", best]];
    
    //[bestScoreLabel setText:[NSString stringWithFormat:@"your best: %d pucks!", gearParts]];
    
}

- (void)hideEndGameScreen{
    
    [currentScoreLabel setHidden:YES];
    [bestScoreLabel setHidden:YES];
    [tryAgainButton setHidden:YES];
    [shareImage setHidden:YES];
    [backgroundImage setHidden:YES];
    [scoreBackgroundImage setHidden:YES];
    
}

- (void)startGameButtonFunstion{
    
    [startGameButton setHidden:YES];
    
    //animate first zombie
    [self animateZombiewView:zombieZomboni1 forPath:firstZombiePath andZombieCounter:counterZombie1];
    
    //animate second zombie
    [self animateZombiewView:zombieZomboni2 forPath:secondZombiePath andZombieCounter:counterZombie2];
    
    //animate third zombie
    [self animateZombiewView:zombieZomboni3 forPath:thirdZombiePath andZombieCounter:counterZombie3];
    
    [self playSound:@"008769299-hockey-organ" andVolume:1.f andNumberOfTimes:-1 andAudioFormat:@"wav"];
    
    playerXPos = 3;
    playerYPos = 18;
}

- (void)playSound: (NSString *)name andVolume:(float)volume andNumberOfTimes:(int)repeat andAudioFormat:(NSString *)format{
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:format];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    audioPlayer.numberOfLoops = repeat;
    audioPlayer.volume = volume;
    [audioPlayer play];
    
}


- (void)animateZombiewView:(UIImageView *)zombie forPath:(NSArray *)pathArray andZombieCounter:(int)zombieCounter{
    
    if (gameOn == YES) {
        
        if(zombieCounter == pathArray.count|| zombieCounter == pathArray.count - 1){
            
            zombieCounter = 0;
        }else{
            
            zombieCounter = zombieCounter + 1;
        }
        
        
        //get each sub array and see witch animation must be done, north, sud, est, west, or if special wormhole casses
        if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"south"] &&
            [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"NO"]) {
            NSLog(@"zombie south animation");
            [self southZombieMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }
        else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"west"] &&
                 [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"NO"]){
            
            [self westZombieMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"north"] &&
                  [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"NO"]){
            
            [self northZombieMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"east"] &&
                  [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"NO"]){
            
            [self eastZombieMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"south"] &&
                  [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"YES"]) {
            
            [self southZombieWormholeMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }
        else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"west"] &&
                 [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"YES"]){
            
            [self westZombieWormholeMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"north"] &&
                  [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"YES"]){
            
            [self northZombieWormholeMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }else if ([(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:2] isEqualToString:@"east"] &&
                  [(NSString *)[[pathArray objectAtIndex:zombieCounter] objectAtIndex:3] isEqualToString: @"YES"]){
            
            [self eastZombieWormholeMovement:zombie onPath:pathArray andCounter:zombieCounter];
            
        }
        
        //at each animation end update zombie position and compare with player position
    }
    
}
- (void)southZombieMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //south animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x, zombie.frame.origin.y + zombie.frame.size.height, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         if(CGRectIntersectsRect(player.frame, zombie.frame))
                         {
                             [self playSound:@"0047_ice_skate_slide" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"mp3"];
                             [self displayEndGameScreen];
                         }
                         else
                             [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                         
                     }];
}
- (void)northZombieMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //north animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x, zombie.frame.origin.y - zombie.frame.size.height, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         if(CGRectIntersectsRect(player.frame, zombie.frame))
                         {
                             [self playSound:@"0047_ice_skate_slide" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"mp3"];
                             [self displayEndGameScreen];
                         }
                         else
                             [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                     }];
}
- (void)westZombieMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //south animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x - zombie.frame.size.width, zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         if(CGRectIntersectsRect(player.frame, zombie.frame))
                         {
                             [self playSound:@"0047_ice_skate_slide" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"mp3"];
                             [self displayEndGameScreen];
                         }
                         else
                             [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                     }];
}
- (void)eastZombieMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //south animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x + zombie.frame.size.width, zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         if(CGRectIntersectsRect(player.frame, zombie.frame))
                         {
                             [self playSound:@"0047_ice_skate_slide" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"mp3"];
                             [self displayEndGameScreen];
                         }
                         else
                             [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                     }];
}
- (void)southZombieWormholeMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //south animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x, zombie.frame.origin.y + zombie.frame.size.height, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         //set new position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x, -zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                         [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                     }];
}
- (void)northZombieWormholeMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //north zombie wormhole animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x, zombie.frame.origin.y - zombie.frame.size.height, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         //set new position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x, ([UIScreen mainScreen].bounds.size.height - topBarHeight), zombie.frame.size.width, zombie.frame.size.height)];
                         
                         [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                     }];
}
- (void)westZombieWormholeMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //west wormhole zombie animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x - zombie.frame.size.width, zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         //set new position
                         [zombie setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                         [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                         
                     }];
}
- (void)eastZombieWormholeMovement:(UIImageView *)zombie onPath:(NSArray *)zombiePath andCounter:(int)counterZombie{
    //east zombie wormhole animation
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //animate from current position
                         [zombie setFrame:CGRectMake(zombie.frame.origin.x + zombie.frame.size.width, zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         //set new position
                         [zombie setFrame:CGRectMake(-zombie.frame.size.width, zombie.frame.origin.y, zombie.frame.size.width, zombie.frame.size.height)];
                         
                         [self animateZombiewView:zombie forPath:zombiePath andZombieCounter:counterZombie];
                         
                     }];
}


- (void)swipeLeft{
    NSLog(@"move to left/west");
    //save moving possition in global variable
    futureMovinDirection = @"west";
    
    //get current moving possition
    if (currentMovinDirection == nil) {
        currentMovinDirection = futureMovinDirection;
    }

    if (isMoving == NO) {
        //get current possition and calculete the neighboard array possition using moving dirrection
        int neighbordX = playerXPos - 1;
        int neighbordY = playerYPos;
        if (neighbordX == -1) {
            neighbordX = 0;
        }
        
        //if next tile is walkable
        if (![(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"west"] isEqualToString:@"123"]) {
            
                NSLog(@"animate");
                if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                    
                    
                    //animate to east function
                    [self animateWest];
                    //when finish update current possition
                    
                    //if current possition has puck, hide the puck, and increment the value
                    
                }
                else{
                    currentMovinDirection = nil;
                    isMoving = NO;
                }
            
        }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"west"] isEqualToString:@"123"]){

                [self wormHoleWestAnimation];

        }else{
            currentMovinDirection = nil;
            isMoving = NO;
        }
    }
    
    
    
}
- (void)animateEast{
    
    if(CGRectIntersectsRect(player.frame, zombieZomboni1.frame) || CGRectIntersectsRect(player.frame, zombieZomboni2.frame) || CGRectIntersectsRect(player.frame, zombieZomboni3.frame))
        [self displayEndGameScreen];

    
    if (gameOn == YES) {

        [UIView animateWithDuration:0.19f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             isMoving = YES;
                             [player setFrame: CGRectMake(player.frame.origin.x + mazeImage.frame.size.width / 11, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                             
                             playerXPos = playerXPos + 1;
                             NSLog(@"PLayer Position becomes: %d and %d", playerXPos, playerYPos);
                             
                             UIImageView *puckImageViewReconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos * 11) + playerXPos + 5000];
                             if (puckImageViewReconstructor.hidden == NO) {
                                 pointsCounter = pointsCounter + 1;
                                 [puckImageViewReconstructor setHidden:YES];
                             }
                             //we previouslly created a unique view by using a tag, then check the container view for existence
                             if (![(NSString *)[[[mapArray objectAtIndex:playerYPos] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                                 UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos + 100];
                                 if (gearImageViewRecconstructor.hidden == NO) {
                                     gearParts = gearParts + 1;
                                     [gearImageViewRecconstructor setHidden:YES];
                                     if (gearParts == 8) {
                                         
                                         //play winning sound and display ending screen
                                         [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                         [self displayEndGameScreen];
                                     }
                                 }
                             }
                             
                         }
                         completion:^(BOOL finished){
                             
                             //if future direction != currrent direction move
                             //check if neighboard in future direction allows movement
                             //if yes update current dirrrection with future direction and animate in that dirrection
                             //if no, continue in the current direction of movement if possible
                             
                             
                             if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                                 
                                 if ([futureMovinDirection isEqualToString:@"north"]) {
                                     int neighbordY = playerYPos - 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateNorth];
                                             currentMovinDirection = @"north";
                                         }else{
                                             int neighbordX = playerXPos + 1;
                                             int neighbordY = playerYPos;
                                             if (neighbordX >= 0 && neighbordX < 11) {
                                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                     [self animateEast];
                                                 }else{
                                                     currentMovinDirection = nil;
                                                     isMoving = NO;
                                                 }
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }
                                     }else{
                                         int neighbordX = playerXPos + 1;
                                         int neighbordY = playerYPos;
                                         if (neighbordX >= 0 && neighbordX < 11) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateEast];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                     
                                 }
                                 else if ([futureMovinDirection isEqualToString:@"west"]){
                                     int neighbordX = playerXPos - 1;
                                     if (neighbordX >= 0 && neighbordX < 11) {
                                         if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateWest];
                                             currentMovinDirection = @"west";
                                         }else{
                                             int neighbordX = playerXPos + 1;
                                             int neighbordY = playerYPos;
                                             if (neighbordX >= 0 && neighbordX < 11) {
                                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                     [self animateEast];
                                                 }else{
                                                     currentMovinDirection = nil;
                                                     isMoving = NO;
                                                 }
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }
                                     }else{
                                         int neighbordX = playerXPos + 1;
                                         int neighbordY = playerYPos;
                                         if (neighbordX >= 0 && neighbordX < 11) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateEast];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                     
                                 }else if ([futureMovinDirection isEqualToString:@"south"]){
                                     int neighbordY = playerYPos + 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateSouth];
                                             currentMovinDirection = @"south";
                                         }else{
                                             int neighbordX = playerXPos + 1;
                                             int neighbordY = playerYPos;
                                             if (neighbordX >= 0 && neighbordX < 11) {
                                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                     [self animateEast];
                                                 }else{
                                                     currentMovinDirection = nil;
                                                     isMoving = NO;
                                                 }
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }
                                     }else{
                                         int neighbordX = playerXPos + 1;
                                         int neighbordY = playerYPos;
                                         if (neighbordX >= 0 && neighbordX < 11) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateEast];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                     
                                 }
                                 
                             }else{
                                 int neighbordX = playerXPos + 1;
                                 int neighbordY = playerYPos;
                                 if (neighbordX >= 0 && neighbordX < 11) {
                                     if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateEast];
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX - 1] valueForKey:@"specialNeighboards"] valueForKey:@"east"] isEqualToString:@"123"]){
                                     [self wormHoleEastAnimation];
                                 }else{
                                     currentMovinDirection = nil;
                                     isMoving = NO;
                                 }
                             }
                             
                         }];
    }
};
- (void)wormHoleEastAnimation{
    
    if (
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni1.frame.origin.y && player.frame.origin.x == zombieZomboni1.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni2.frame.origin.y && player.frame.origin.x == zombieZomboni2.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni3.frame.origin.y && player.frame.origin.x == zombieZomboni3.frame.origin.x)
        
        ) {
        
        [self displayEndGameScreen];
        
    }
    
    if (gameOn == YES) {
        [UIView animateWithDuration:0.19f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             isMoving = YES;
                             [player setFrame: CGRectMake(player.frame.origin.x + mazeImage.frame.size.width / 11, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished){
                             //set frame to new possition that is outside the map from bottom to top
                             float futureXPos =  - mazeImage.frame.size.width / 11;
                             [player setFrame: CGRectMake(futureXPos, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                             //second animation from new possition to new tile situated at the top but Y=0 and old X
                             [UIView animateWithDuration:0.125f
                                                   delay:0.f
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  
                                                  [player setFrame: CGRectMake(0, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                                                  //resave new X and Y
                                                  playerXPos = 0;
                                                  
                                                  //check for pucks and add them if not added
                                                  UIImageView *puckImageViewReconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos * 11) + playerXPos + 5000];
                                                  if (puckImageViewReconstructor.hidden == NO) {
                                                      pointsCounter = pointsCounter + 1;
                                                      [puckImageViewReconstructor setHidden:YES];
                                                  }
                                                  //we previouslly created a unique view by using a tag, then check the container view for existence
                                                  if (![(NSString *)[[[mapArray objectAtIndex:playerYPos] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                                                      UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos + 100];
                                                      if (gearImageViewRecconstructor.hidden == NO) {
                                                          gearParts = gearParts + 1;
                                                          [gearImageViewRecconstructor setHidden:YES];
                                                          if (gearParts == 8) {
                                                              
                                                              //play winning sound and display ending screen
                                                              [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                                              [self displayEndGameScreen];
                                                          }
                                                      }
                                                  }
                                              }
                                              completion:^(BOOL finished){
                                                  //depending the animation direction call one of the animations functions
                                                  if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                                                      
                                                      if ([futureMovinDirection isEqualToString:@"north"]) {
                                                          int neighbordY = playerYPos - 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateNorth];
                                                                  currentMovinDirection = @"north";
                                                              }else{
                                                                  int neighbordX = playerXPos + 1;
                                                                  int neighbordY = playerYPos;
                                                                  if (neighbordX >= 0 && neighbordX < 11) {
                                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                          [self animateEast];
                                                                      }else{
                                                                          currentMovinDirection = nil;
                                                                          isMoving = NO;
                                                                      }
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }
                                                          }else{
                                                              int neighbordX = playerXPos + 1;
                                                              int neighbordY = playerYPos;
                                                              if (neighbordX >= 0 && neighbordX < 11) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateEast];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                          
                                                      }
                                                      else if ([futureMovinDirection isEqualToString:@"west"]){
                                                          int neighbordX = playerXPos - 1;
                                                          if (neighbordX >= 0 && neighbordX < 11) {
                                                              if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateWest];
                                                                  currentMovinDirection = @"west";
                                                              }else{
                                                                  int neighbordX = playerXPos + 1;
                                                                  int neighbordY = playerYPos;
                                                                  if (neighbordX >= 0 && neighbordX < 11) {
                                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                          [self animateEast];
                                                                      }else{
                                                                          currentMovinDirection = nil;
                                                                          isMoving = NO;
                                                                      }
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }
                                                          }else{
                                                              int neighbordX = playerXPos + 1;
                                                              int neighbordY = playerYPos;
                                                              if (neighbordX >= 0 && neighbordX < 11) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateEast];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                          
                                                      }else if ([futureMovinDirection isEqualToString:@"south"]){
                                                          int neighbordY = playerYPos + 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateSouth];
                                                                  currentMovinDirection = @"south";
                                                              }else{
                                                                  int neighbordX = playerXPos + 1;
                                                                  int neighbordY = playerYPos;
                                                                  if (neighbordX >= 0 && neighbordX < 11) {
                                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                          [self animateEast];
                                                                      }else{
                                                                          currentMovinDirection = nil;
                                                                          isMoving = NO;
                                                                      }
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }
                                                          }else{
                                                              int neighbordX = playerXPos + 1;
                                                              int neighbordY = playerYPos;
                                                              if (neighbordX >= 0 && neighbordX < 11) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateEast];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                          
                                                      }
                                                      
                                                  }else{
                                                      int neighbordX = playerXPos + 1;
                                                      int neighbordY = playerYPos;
                                                      if (neighbordX >= 0 && neighbordX < 11) {
                                                          if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateEast];
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }else{
                                                          currentMovinDirection = nil;
                                                          isMoving = NO;
                                                      }
                                                  }
                                              }];
                             
                         }];
    }
}

- (void)swipeRight{
    NSLog(@"move to right/east");
    //save moving possition in global variable
    futureMovinDirection = @"east";
    
    //get current moving possition
    if (currentMovinDirection == nil) {
        currentMovinDirection = futureMovinDirection;
    }
    
    if (isMoving == NO) {
        //get current possition and calculete the neighboard array possition using moving dirrection
        int neighbordX = playerXPos + 1;
        int neighbordY = playerYPos;
        
        //if next tile is walkable
        if (neighbordX >= 0 && neighbordX < 11) {
            if (neighbordY >= 0 && neighbordY < 19) {
                if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                    //animate to east function
                    [self animateEast];
                }else{
                    currentMovinDirection = nil;
                    isMoving = NO;
                    NSLog(@"case 1");
                }
            }else{
                currentMovinDirection = nil;
                isMoving = NO;
                NSLog(@"case 2");
            }
        }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX - 1] valueForKey:@"specialNeighboards"] valueForKey:@"east"] isEqualToString:@"123"]){
            [self wormHoleEastAnimation];
        }else{
            currentMovinDirection = nil;
            isMoving = NO;
            NSLog(@"case 3");
        }
    }
}
- (void)animateWest{
    
    if(CGRectIntersectsRect(player.frame, zombieZomboni1.frame) || CGRectIntersectsRect(player.frame, zombieZomboni2.frame) || CGRectIntersectsRect(player.frame, zombieZomboni3.frame))
        [self displayEndGameScreen];
    
    if (gameOn == YES) {
        [UIView animateWithDuration:0.19f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             isMoving = YES;
                             [player setFrame: CGRectMake(player.frame.origin.x - mazeImage.frame.size.width / 11, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                             
                             playerXPos = playerXPos - 1;
                             NSLog(@"PLayer Position becomes: %d and %d", playerXPos, playerYPos);
                             
                             UIImageView *pucksImageViewReconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos  + 5000];
                             if (pucksImageViewReconstructor.hidden == NO) {
                                 pointsCounter = pointsCounter + 1;
                                 [pucksImageViewReconstructor setHidden:YES];
                             }
                             
                             //we previouslly created a unique view by using a tag, then check the container view for existence
                             if (![(NSString *)[[[mapArray objectAtIndex:playerYPos] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                                 UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos + 100];
                                 if (gearImageViewRecconstructor.hidden == NO) {
                                     gearParts = gearParts + 1;
                                     [gearImageViewRecconstructor setHidden:YES];
                                     if (gearParts == 8) {
                                         
                                         //play winning sound and display ending screen
                                         [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                         [self displayEndGameScreen];
                                     }
                                 }
                             }
                         }
                         completion:^(BOOL finished){
                             
                             //if future direction != currrent direction move
                             //check if neighboard in future direction allows movement
                             //if yes update current dirrrection with future direction and animate in that dirrection
                             //if no, continue in the current direction of movement if possible
                             
                             
                             
                             if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                                 
                                 if ([futureMovinDirection isEqualToString:@"north"]) {
                                     int neighbordY = playerYPos - 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateNorth];
                                             currentMovinDirection = @"north";
                                         }else{
                                             int neighbordX = playerXPos - 1;
                                             int neighbordY = playerYPos;
                                             if (neighbordX >= 0 && neighbordX < 11) {
                                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                     [self animateWest];
                                                 }else{
                                                     currentMovinDirection = nil;
                                                     isMoving = NO;
                                                 }
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }
                                     }else{
                                         int neighbordX = playerXPos - 1;
                                         int neighbordY = playerYPos;
                                         if (neighbordX >= 0 && neighbordX < 11) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateWest];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                     
                                 }
                                 else if ([futureMovinDirection isEqualToString:@"east"]){
                                     int neighbordX = playerXPos + 1;
                                     if (neighbordX >= 0 && neighbordX < 11) {
                                         if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateEast];
                                             currentMovinDirection = @"east";
                                         }else{
                                             int neighbordX = playerXPos - 1;
                                             int neighbordY = playerYPos;
                                             if (neighbordX >= 0 && neighbordX < 11) {
                                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                     [self animateWest];
                                                 }else{
                                                     currentMovinDirection = nil;
                                                     isMoving = NO;
                                                 }
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }
                                     }else{
                                         int neighbordX = playerXPos - 1;
                                         int neighbordY = playerYPos;
                                         if (neighbordX >= 0 && neighbordX < 11) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateWest];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                     
                                 }else if ([futureMovinDirection isEqualToString:@"south"]){
                                     int neighbordY = playerYPos + 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateSouth];
                                             currentMovinDirection = @"south";
                                         }else{
                                             int neighbordX = playerXPos - 1;
                                             int neighbordY = playerYPos;
                                             if (neighbordX >= 0 && neighbordX < 11) {
                                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                     [self animateWest];
                                                 }else{
                                                     currentMovinDirection = nil;
                                                     isMoving = NO;
                                                 }
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }
                                     }else{
                                         int neighbordX = playerXPos - 1;
                                         int neighbordY = playerYPos;
                                         if (neighbordX >= 0 && neighbordX < 11) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateWest];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                     
                                 }
                                 
                             }
                             else{
                                 int neighbordX = playerXPos - 1;
                                 int neighbordY = playerYPos;
                                 if (neighbordX >= 0 && neighbordX < 11) {
                                     if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateWest];
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX + 1] valueForKey:@"specialNeighboards"] valueForKey:@"west"] isEqualToString:@"123"]){
                                     [self wormHoleWestAnimation];
                                 }else{
                                     currentMovinDirection = nil;
                                     isMoving = NO;
                                 }
                             }
                             
                         }];
    }
};
- (void)wormHoleWestAnimation{
    if (
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni1.frame.origin.y && player.frame.origin.x == zombieZomboni1.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni2.frame.origin.y && player.frame.origin.x == zombieZomboni2.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni3.frame.origin.y && player.frame.origin.x == zombieZomboni3.frame.origin.x)
        
        ) {
        
        [self displayEndGameScreen];
        
    }
    if (gameOn == YES) {
        [UIView animateWithDuration:0.19f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             isMoving = YES;
                             [player setFrame: CGRectMake(player.frame.origin.x - mazeImage.frame.size.width / 11, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished){
                             //set frame to new possition that is outside the map from bottom to top
                             float futureXPos = mazeImage.frame.size.width;
                             [player setFrame: CGRectMake(futureXPos, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                             //second animation from new possition to new tile situated at the top but Y=0 and old X
                             [UIView animateWithDuration:0.125f
                                                   delay:0.f
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  
                                                  [player setFrame: CGRectMake(player.frame.origin.x - mazeImage.frame.size.width / 11, player.frame.origin.y, player.frame.size.width, player.frame.size.height)];
                                                  //resave new X and Y
                                                  playerXPos = 10;
                                                  
                                                  //check for pucks and add them if not added
                                                  UIImageView *pucksImageViewReconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos  + 5000];
                                                  if (pucksImageViewReconstructor.hidden == NO) {
                                                      pointsCounter = pointsCounter + 1;
                                                      [pucksImageViewReconstructor setHidden:YES];
                                                  }
                                                  
                                                  //we previouslly created a unique view by using a tag, then check the container view for existence
                                                  if (![(NSString *)[[[mapArray objectAtIndex:playerYPos] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                                                      UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos + 100];
                                                      if (gearImageViewRecconstructor.hidden == NO) {
                                                          gearParts = gearParts + 1;
                                                          [gearImageViewRecconstructor setHidden:YES];
                                                          if (gearParts == 8) {
                                                              
                                                              //play winning sound and display ending screen
                                                              [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                                              [self displayEndGameScreen];
                                                          }
                                                      }
                                                  }
                                              }
                                              completion:^(BOOL finished){
                                                  //depending the animation direction call one of the animations functions
                                                  if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                                                      
                                                      if ([futureMovinDirection isEqualToString:@"north"]) {
                                                          int neighbordY = playerYPos - 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateNorth];
                                                                  currentMovinDirection = @"north";
                                                              }else{
                                                                  int neighbordX = playerXPos - 1;
                                                                  int neighbordY = playerYPos;
                                                                  if (neighbordX >= 0 && neighbordX < 11) {
                                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                          [self animateWest];
                                                                      }else{
                                                                          currentMovinDirection = nil;
                                                                          isMoving = NO;
                                                                      }
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }
                                                          }else{
                                                              int neighbordX = playerXPos - 1;
                                                              int neighbordY = playerYPos;
                                                              if (neighbordX >= 0 && neighbordX < 11) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateWest];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                          
                                                      }
                                                      else if ([futureMovinDirection isEqualToString:@"east"]){
                                                          int neighbordX = playerXPos + 1;
                                                          if (neighbordX >= 0 && neighbordX < 11) {
                                                              if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateEast];
                                                                  currentMovinDirection = @"east";
                                                              }else{
                                                                  int neighbordX = playerXPos - 1;
                                                                  int neighbordY = playerYPos;
                                                                  if (neighbordX >= 0 && neighbordX < 11) {
                                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                          [self animateWest];
                                                                      }else{
                                                                          currentMovinDirection = nil;
                                                                          isMoving = NO;
                                                                      }
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }
                                                          }else{
                                                              int neighbordX = playerXPos - 1;
                                                              int neighbordY = playerYPos;
                                                              if (neighbordX >= 0 && neighbordX < 11) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateWest];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                          
                                                      }else if ([futureMovinDirection isEqualToString:@"south"]){
                                                          int neighbordY = playerYPos + 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateSouth];
                                                                  currentMovinDirection = @"south";
                                                              }else{
                                                                  int neighbordX = playerXPos - 1;
                                                                  int neighbordY = playerYPos;
                                                                  if (neighbordX >= 0 && neighbordX < 11) {
                                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                          [self animateWest];
                                                                      }else{
                                                                          currentMovinDirection = nil;
                                                                          isMoving = NO;
                                                                      }
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }
                                                          }else{
                                                              int neighbordX = playerXPos - 1;
                                                              int neighbordY = playerYPos;
                                                              if (neighbordX >= 0 && neighbordX < 11) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateWest];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                          
                                                      }
                                                      
                                                  }
                                                  else{
                                                      int neighbordX = playerXPos - 1;
                                                      int neighbordY = playerYPos;
                                                      if (neighbordX >= 0 && neighbordX < 11) {
                                                          if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateWest];
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX + 1] valueForKey:@"specialNeighboards"] valueForKey:@"west"] isEqualToString:@"123"]){
                                                          [self animateWest];
                                                      }else{
                                                          currentMovinDirection = nil;
                                                          isMoving = NO;
                                                      }
                                                  }
                                              }];
                             
                         }];
    }
}

- (void)swipeDown{
    NSLog(@"swipe south");
    //save moving possition in global variable
    futureMovinDirection = @"south";
    //get current moving possition
    if (currentMovinDirection == nil) {
        currentMovinDirection = futureMovinDirection;
        NSLog(@"save poz");
    }
    if (isMoving == NO) {
        //get current possition and calculete the neighboard array possition using moving dirrection
        int neighbordX = playerXPos;
        int neighbordY = playerYPos + 1;
        //if next tile is walkable
        if (neighbordY >= 0 && neighbordY <19) {
            if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                [self animateSouth];
            }else{
                currentMovinDirection = nil;
                isMoving = NO;
            }
        }
        else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY - 1] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"south"] isEqualToString:@"123"]){
            [self wormHoleSouthAnimation];
        }
    }
    
}
- (void)animateSouth{
    
    if(CGRectIntersectsRect(player.frame, zombieZomboni1.frame) || CGRectIntersectsRect(player.frame, zombieZomboni2.frame) || CGRectIntersectsRect(player.frame, zombieZomboni3.frame))
        [self displayEndGameScreen];
    
    [UIView animateWithDuration:0.19f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         isMoving = YES;
                         [player setFrame: CGRectMake(player.frame.origin.x, player.frame.origin.y +  mazeImage.frame.size.height / mapArray.count, player.frame.size.width, player.frame.size.height)];
                         UIImageView *pucksImageViewReconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos + 1) * 11 + playerXPos + 5000];
                         if (pucksImageViewReconstructor.hidden == NO) {
                             pointsCounter = pointsCounter + 1;
                             [pucksImageViewReconstructor setHidden:YES];
                         }
                         //we previouslly created a unique view by using a tag, then check the container view for existence
                         if (![(NSString *)[[[mapArray objectAtIndex:playerYPos + 1] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                             UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos + 1) * 11 + playerXPos + 100];
                             if (gearImageViewRecconstructor.hidden == NO) {
                                 gearParts = gearParts + 1;
                                 [gearImageViewRecconstructor setHidden:YES];
                                 if (gearParts == 8) {
                                     
                                     //play winning sound and display ending screen
                                     [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                     [self displayEndGameScreen];
                                 }
                             }
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         //if future direction != currrent direction move
                         //check if neighboard in future direction allows movement
                         //if yes update current dirrrection with future direction and animate in that dirrection
                         //if no, continue in the current direction of movement if possible
                         playerYPos = playerYPos + 1;
                         NSLog(@"PLayer Position becomes: %d and %d", playerXPos, playerYPos);
                         
                         if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                             
                             if ([futureMovinDirection isEqualToString:@"east"]) {
                                 int neighbordX = playerXPos + 1;
                                 if (neighbordX >= 0 && neighbordX < 11) {
                                     if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateEast];
                                         currentMovinDirection = @"east";
                                     }else{
                                         int neighbordX = playerXPos;
                                         int neighbordY = playerYPos + 1;
                                         if (neighbordY >= 0 && neighbordY < 19) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateSouth];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                 }else{
                                     int neighbordX = playerXPos;
                                     int neighbordY = playerYPos + 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateSouth];
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }
                                 
                             }
                             else if ([futureMovinDirection isEqualToString:@"west"]){
                                 int neighbordX = playerXPos - 1;
                                 if (neighbordX >= 0 && neighbordX < 11) {
                                     if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateWest];
                                         currentMovinDirection = @"west";
                                     }else{
                                         int neighbordX = playerXPos;
                                         int neighbordY = playerYPos + 1;
                                         if (neighbordY >= 0 && neighbordY < 19) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateSouth];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                 }else{
                                     int neighbordX = playerXPos;
                                     int neighbordY = playerYPos + 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateSouth];
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }
                                 
                             }
                             else if ([futureMovinDirection isEqualToString:@"north"]){
                                 int neighbordY = playerYPos - 1;
                                 if (neighbordY >= 0 && neighbordY < 19) {
                                     if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateNorth];
                                         currentMovinDirection = @"north";
                                     }else{
                                         int neighbordX = playerXPos;
                                         int neighbordY = playerYPos + 1;
                                         if (neighbordY >= 0 && neighbordY < 19) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateSouth];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                 }else{
                                     int neighbordX = playerXPos;
                                     int neighbordY = playerYPos + 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateSouth];
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }
                                 
                             }
                             
                         }
                         else{
                             int neighbordX = playerXPos;
                             int neighbordY = playerYPos + 1;
                             if (neighbordY >= 0 && neighbordY < 19) {
                                 
                                 
                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                     [self animateSouth];
                                 }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"south"] isEqualToString:@"123"]){
                                     [self wormHoleSouthAnimation];
                                 }else{
                                     currentMovinDirection = nil;
                                     isMoving = NO;
                                 }
                                 
                             }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY - 1] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"south"] isEqualToString:@"123"]){
                                 [self wormHoleSouthAnimation];
                             }else{
                                 currentMovinDirection = nil;
                                 isMoving = NO;
                             }
                         }
                         
                     }];
};
- (void)wormHoleSouthAnimation{
    
    if (
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni1.frame.origin.y && player.frame.origin.x == zombieZomboni1.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni2.frame.origin.y && player.frame.origin.x == zombieZomboni2.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni3.frame.origin.y && player.frame.origin.x == zombieZomboni3.frame.origin.x)
        
        ) {
        
        [self displayEndGameScreen];
        
    }
    
    [UIView animateWithDuration:0.19f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         isMoving = YES;
                         [player setFrame: CGRectMake(player.frame.origin.x, player.frame.origin.y +  2 * (mazeImage.frame.size.height / mapArray.count), player.frame.size.width, player.frame.size.height)];
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         //set frame to new possition that is outside the map from bottom to top
                         float futureYPos = -((mazeImage.frame.size.height / mapArray.count) * 2);
                         [player setFrame: CGRectMake(player.frame.origin.x, futureYPos, player.frame.size.width, player.frame.size.height)];
                         //second animation from new possition to new tile situated at the top but Y=0 and old X
                         [UIView animateWithDuration:0.125f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              
                                              [player setFrame: CGRectMake(player.frame.origin.x, -(mazeImage.frame.size.height / mapArray.count), player.frame.size.width, player.frame.size.height)];
                                              //resave new X and Y
                                              playerYPos = 0;
                                              
                                              //check for pucks and add them if not added
                                              UIImageView *pucksImageViewReconstructor = (UIImageView *)[self.view viewWithTag:playerYPos * 11 + playerXPos + 5000];
                                              if (pucksImageViewReconstructor.hidden == NO) {
                                                  pointsCounter = pointsCounter + 1;
                                                  [pucksImageViewReconstructor setHidden:YES];
                                              }
                                              
                                              //we previouslly created a unique view by using a tag, then check the container view for existence
                                              if (![(NSString *)[[[mapArray objectAtIndex:playerYPos] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                                                  UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:playerYPos  * 11 + playerXPos + 100];
                                                  if (gearImageViewRecconstructor.hidden == NO) {
                                                      gearParts = gearParts + 1;
                                                      [gearImageViewRecconstructor setHidden:YES];
                                                      if (gearParts == 8) {
                                                          
                                                          //play winning sound and display ending screen
                                                          [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                                          [self displayEndGameScreen];
                                                      }
                                                  }
                                              }
                                          }
                                          completion:^(BOOL finished){
                                              //depending the animation direction call one of the animations functions
                                              if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                                                  
                                                  if ([futureMovinDirection isEqualToString:@"east"]) {
                                                      int neighbordX = playerXPos + 1;
                                                      if (neighbordX >= 0 && neighbordX < 11) {
                                                          if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateEast];
                                                              currentMovinDirection = @"east";
                                                          }else{
                                                              int neighbordX = playerXPos;
                                                              int neighbordY = playerYPos + 1;
                                                              if (neighbordY >= 0 && neighbordY < 19) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateSouth];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                      }else{
                                                          int neighbordX = playerXPos;
                                                          int neighbordY = playerYPos + 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateSouth];
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }
                                                      
                                                  }
                                                  else if ([futureMovinDirection isEqualToString:@"west"]){
                                                      int neighbordX = playerXPos - 1;
                                                      if (neighbordX >= 0 && neighbordX < 11) {
                                                          if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateWest];
                                                              currentMovinDirection = @"west";
                                                          }else{
                                                              int neighbordX = playerXPos;
                                                              int neighbordY = playerYPos + 1;
                                                              if (neighbordY >= 0 && neighbordY < 19) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateSouth];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                      }else{
                                                          int neighbordX = playerXPos;
                                                          int neighbordY = playerYPos + 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateSouth];
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }
                                                      
                                                  }
                                                  else if ([futureMovinDirection isEqualToString:@"north"]){
                                                      int neighbordY = playerYPos - 1;
                                                      if (neighbordY >= 0 && neighbordY < 19) {
                                                          if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateNorth];
                                                              currentMovinDirection = @"north";
                                                          }else{
                                                              int neighbordX = playerXPos;
                                                              int neighbordY = playerYPos + 1;
                                                              if (neighbordY >= 0 && neighbordY < 19) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateSouth];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                      }else{
                                                          int neighbordX = playerXPos;
                                                          int neighbordY = playerYPos + 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateSouth];
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }
                                                      
                                                  }
                                                  
                                              }
                                              else{
                                                  int neighbordX = playerXPos;
                                                  int neighbordY = playerYPos + 1;
                                                  if (neighbordY >= 0 && neighbordY < 19) {
                                                      
                                                      
                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                          [self animateSouth];
                                                      }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"south"] isEqualToString:@"123"]){
                                                          [self wormHoleSouthAnimation];
                                                      }else{
                                                          currentMovinDirection = nil;
                                                          isMoving = NO;
                                                      }
                                                      
                                                  }else{
                                                      currentMovinDirection = nil;
                                                      isMoving = NO;
                                                  }
                                              }
                                              
                                              
                                          }];

                     }];
    
}

- (void)swipeUp{
    
    NSLog(@"swipe north");
    //save moving possition in global variable
    futureMovinDirection = @"north";
    
    //get current moving possition
    if (currentMovinDirection == nil) {
        currentMovinDirection = futureMovinDirection;
    }
    
    if (isMoving == NO) {
        //get current possition and calculete the neighboard array possition using moving dirrection
        int neighbordX = playerXPos;
        int neighbordY = playerYPos - 1;
        if (neighbordY == -1) {
            neighbordY = 0;
        }
        
        //if next tile is walkable
        if (![(NSString *)[[[[mapArray objectAtIndex:neighbordY + 1] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"north"] isEqualToString:@"123"]) {
            if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                //animate to north function
                [self animateNorth];
            }else{
                currentMovinDirection = nil;
                isMoving = NO;
            }
        }
        else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY + 1] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"north"] isEqualToString:@"123"]){
            [self wormHoleNorthAnimation];
        }else{
            currentMovinDirection = nil;
            isMoving = NO;
        }
    }
}
- (void)animateNorth{

    
    if(CGRectIntersectsRect(player.frame, zombieZomboni1.frame) || CGRectIntersectsRect(player.frame, zombieZomboni2.frame) || CGRectIntersectsRect(player.frame, zombieZomboni3.frame))
        [self displayEndGameScreen];
    
    [UIView animateWithDuration:0.19f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         isMoving = YES;
                         [player setFrame: CGRectMake(player.frame.origin.x, player.frame.origin.y -  mazeImage.frame.size.height / mapArray.count, player.frame.size.width, player.frame.size.height)];
                         UIImageView *pucksImageViewReconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos - 1) * 11 + playerXPos + 5000];
                         if (pucksImageViewReconstructor.hidden == NO) {
                             pointsCounter = pointsCounter + 1;
                             [pucksImageViewReconstructor setHidden:YES];
                         }
                         
                         
                         //we previouslly created a unique view by using a tag, then check the container view for existence
                         int gearOnItYPos = playerYPos - 1;
                         if (gearOnItYPos < 0) {
                             gearOnItYPos = 18;
                         }
                         if (![(NSString *)[[[mapArray objectAtIndex:gearOnItYPos] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                             UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:gearOnItYPos * 11 + playerXPos + 100];
                             if (gearImageViewRecconstructor.hidden == NO) {
                                 gearParts = gearParts + 1;
                                 [gearImageViewRecconstructor setHidden:YES];
                                 if (gearParts == 8) {
                                     
                                     //play winning sound and display ending screen
                                     [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                     [self displayEndGameScreen];
                                 }
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         
                         //if future direction != currrent direction move
                         //check if neighboard in future direction allows movement
                         //if yes update current dirrrection with future direction and animate in that dirrection
                         //if no, continue in the current direction of movement if possible
                         playerYPos = playerYPos - 1;
                         NSLog(@"PLayer Position becomes: %d and %d", playerXPos, playerYPos);
                         
                         if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                             
                             if ([futureMovinDirection isEqualToString:@"east"]) {
                                 int neighbordX = playerXPos + 1;
                                 if (neighbordX >= 0 && neighbordX < 11) {
                                     if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateEast];
                                         currentMovinDirection = @"east";
                                     }else{
                                         int neighbordX = playerXPos;
                                         int neighbordY = playerYPos - 1;
                                         if (neighbordY >= 0 && neighbordY < 19) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateNorth];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                 }else{
                                     int neighbordX = playerXPos;
                                     int neighbordY = playerYPos - 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateNorth];
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }
                                 
                             }
                             else if ([futureMovinDirection isEqualToString:@"west"]){
                                 int neighbordX = playerXPos - 1;
                                 if (neighbordX >= 0 && neighbordX < 11) {
                                     if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateWest];
                                         currentMovinDirection = @"west";
                                     }else{
                                         int neighbordX = playerXPos;
                                         int neighbordY = playerYPos - 1;
                                         if (neighbordY >= 0 && neighbordY < 19) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateNorth];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                 }else{
                                     int neighbordX = playerXPos;
                                     int neighbordY = playerYPos - 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateNorth];
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }
                                 
                             }else if ([futureMovinDirection isEqualToString:@"south"]){
                                 int neighbordY = playerYPos + 1;
                                 if (neighbordY >= 0 && neighbordY < 19) {
                                     if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                         [self animateSouth];
                                         currentMovinDirection = @"south";
                                     }else{
                                         int neighbordX = playerXPos;
                                         int neighbordY = playerYPos - 1;
                                         if (neighbordY >= 0 && neighbordY < 19) {
                                             if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                 [self animateNorth];
                                             }else{
                                                 currentMovinDirection = nil;
                                                 isMoving = NO;
                                             }
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }
                                 }else{
                                     int neighbordX = playerXPos;
                                     int neighbordY = playerYPos - 1;
                                     if (neighbordY >= 0 && neighbordY < 19) {
                                         if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                             [self animateNorth];
                                         }else{
                                             currentMovinDirection = nil;
                                             isMoving = NO;
                                         }
                                     }else{
                                         currentMovinDirection = nil;
                                         isMoving = NO;
                                     }
                                 }
                                 
                             }
                             
                         }else{
                             int neighbordX = playerXPos;
                             int neighbordY = playerYPos - 1;
                             if (neighbordY == -1 || neighbordY == -2) {
                                 neighbordY = 0;
                             }
                             if (![(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"north"] isEqualToString:@"123"]) {
                                 if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                     [self animateNorth];
                                 }else{
                                     currentMovinDirection = nil;
                                     isMoving = NO;
                                 }
                             }else if ([(NSString *)[[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"specialNeighboards"] valueForKey:@"north"] isEqualToString:@"123"]){
                                 [self wormHoleNorthAnimation];
                             }else{
                                 currentMovinDirection = nil;
                                 isMoving = NO;
                             }
                         }
                         
                     }];
    
}
- (void)wormHoleNorthAnimation{
    
    if (
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni1.frame.origin.y && player.frame.origin.x == zombieZomboni1.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni2.frame.origin.y && player.frame.origin.x == zombieZomboni2.frame.origin.x) ||
        ((player.frame.origin.y + ([UIScreen mainScreen].bounds.size.height - topBarHeight) / 19) == zombieZomboni3.frame.origin.y && player.frame.origin.x == zombieZomboni3.frame.origin.x)
        
        ) {
        
        [self displayEndGameScreen];
        
    }
    
    [UIView animateWithDuration:0.19f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         isMoving = YES;
                         [player setFrame: CGRectMake(player.frame.origin.x, player.frame.origin.y - (mazeImage.frame.size.height / mapArray.count), player.frame.size.width, player.frame.size.height)];
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         //set frame to new possition that is outside the map from bottom to top
                         float futureYPos = mazeImage.frame.size.height + (mazeImage.frame.size.height / mapArray.count);
                         [player setFrame: CGRectMake(player.frame.origin.x, futureYPos, player.frame.size.width, player.frame.size.height)];
                         //second animation from new possition to new tile situated at the top but Y=0 and old X
                         [UIView animateWithDuration:0.125f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              
                                              [player setFrame: CGRectMake(player.frame.origin.x, mazeImage.frame.size.height - (mazeImage.frame.size.height / mapArray.count) * 2, player.frame.size.width, player.frame.size.height)];
                                              //resave new X and Y
                                              playerYPos = 18;
                                              
                                              //check for pucks and add them if not added
                                              UIImageView *pucksImageViewReconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos) * 11 + playerXPos + 5000];
                                              if (pucksImageViewReconstructor.hidden == NO) {
                                                  pointsCounter = pointsCounter + 1;
                                                  [pucksImageViewReconstructor setHidden:YES];
                                              }
                                              //we previouslly created a unique view by using a tag, then check the container view for existence
                                              if (![(NSString *)[[[mapArray objectAtIndex:playerYPos - 1] objectAtIndex:playerXPos] objectForKey:@"gearOnIt"]  isEqualToString: @"NO"]) {
                                                  UIImageView *gearImageViewRecconstructor = (UIImageView *)[self.view viewWithTag:(playerYPos - 1) * 11 + playerXPos + 100];
                                                  if (gearImageViewRecconstructor.hidden == NO) {
                                                      gearParts = gearParts + 1;
                                                      [gearImageViewRecconstructor setHidden:YES];
                                                      if (gearParts == 8) {
                                                          
                                                          //play winning sound and display ending screen
                                                          [self playSound:@"048677059-sports-crowd-cheering-01" andVolume:1.f andNumberOfTimes:0 andAudioFormat:@"wav"];
                                                          [self displayEndGameScreen];
                                                      }
                                                  }
                                              }
                                          }
                                          completion:^(BOOL finished){
                                              //depending the animation direction call one of the animations functions
                                              if (![currentMovinDirection isEqualToString:futureMovinDirection]) {
                                                  
                                                  if ([futureMovinDirection isEqualToString:@"east"]) {
                                                      int neighbordX = playerXPos + 1;
                                                      if (neighbordX >= 0 && neighbordX < 11) {
                                                          if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateEast];
                                                              currentMovinDirection = @"east";
                                                          }else{
                                                              int neighbordX = playerXPos;
                                                              int neighbordY = playerYPos - 1;
                                                              if (neighbordY >= 0 && neighbordY < 19) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateNorth];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                      }else{
                                                          int neighbordX = playerXPos;
                                                          int neighbordY = playerYPos - 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateNorth];
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }
                                                      
                                                  }
                                                  else if ([futureMovinDirection isEqualToString:@"west"]){
                                                      int neighbordX = playerXPos - 1;
                                                      if (neighbordX >= 0 && neighbordX < 11) {
                                                          if ([[[[mapArray objectAtIndex:playerYPos] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateWest];
                                                              currentMovinDirection = @"west";
                                                          }else{
                                                              int neighbordX = playerXPos;
                                                              int neighbordY = playerYPos - 1;
                                                              if (neighbordY >= 0 && neighbordY < 19) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateNorth];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                      }else{
                                                          int neighbordX = playerXPos;
                                                          int neighbordY = playerYPos - 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateNorth];
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }
                                                      
                                                  }else if ([futureMovinDirection isEqualToString:@"south"]){
                                                      int neighbordY = playerYPos + 1;
                                                      if (neighbordY >= 0 && neighbordY < 19) {
                                                          if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:playerXPos] valueForKey:@"walkable"] boolValue] == YES) {
                                                              [self animateSouth];
                                                              currentMovinDirection = @"south";
                                                          }else{
                                                              int neighbordX = playerXPos;
                                                              int neighbordY = playerYPos - 1;
                                                              if (neighbordY >= 0 && neighbordY < 19) {
                                                                  if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                      [self animateNorth];
                                                                  }else{
                                                                      currentMovinDirection = nil;
                                                                      isMoving = NO;
                                                                  }
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }
                                                      }else{
                                                          int neighbordX = playerXPos;
                                                          int neighbordY = playerYPos - 1;
                                                          if (neighbordY >= 0 && neighbordY < 19) {
                                                              if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                                  [self animateNorth];
                                                              }else{
                                                                  currentMovinDirection = nil;
                                                                  isMoving = NO;
                                                              }
                                                          }else{
                                                              currentMovinDirection = nil;
                                                              isMoving = NO;
                                                          }
                                                      }
                                                      
                                                  }
                                                  
                                              }else{
                                                  int neighbordX = playerXPos;
                                                  int neighbordY = playerYPos - 1;
                                                  if (neighbordY >= 0 && neighbordY < 19) {
                                                      if ([[[[mapArray objectAtIndex:neighbordY] objectAtIndex:neighbordX] valueForKey:@"walkable"] boolValue] == YES) {
                                                          [self animateNorth];
                                                      }else{
                                                          currentMovinDirection = nil;
                                                          isMoving = NO;
                                                      }
                                                  }else{
                                                      currentMovinDirection = nil;
                                                      isMoving = NO;
                                                  }
                                              }
                                          }];
                         
                         
                     }];
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

@end
