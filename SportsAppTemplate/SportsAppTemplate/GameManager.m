//
//  GameManager.m
//  SportsAppTemplate
//
//  Created by Daniel Sexton on 2015-04-21.
//  Copyright (c) 2015 Just Be Friends Network. All rights reserved.
//

#import "GameManager.h"
#import "SessionManager.h"

static bool init = false;

@implementation GameManager{
    SessionManager *session;
}
@synthesize GameId, UserName, Avatar, TeamName, TeamShortCode, TeamCity, TeamLogo;



- (id) initWithGameId: (NSString*)gameId{
    //when initializing the gameManager object, load up a copy of the Main App's session manager
    session = [SessionManager sharedManager];
    
    if(self = [super init]){
        GameId = gameId;
    }
    
    return self;
}


- (id) initWithTestScore:(NSNumber*)score progress:(NSString*)progress GameData: (NSString*)data andGameId:(NSString*)gameId{
   
    if(self = [self initWithGameId:gameId]){
        self.HighScore = score;
        self.ProgressDescription = progress;
        self.GameData = data;
    }
    
    return self;
}


-(void)recordScore: (NSNumber *)score{
    NSLog(@"%@", score);
}

-(void)recordEventWithCategory: (NSString*)category Action: (NSString*)action Label: (NSString*)label AndValue: (NSNumber*)value{
    NSLog(@"category: %@", category);
    NSLog(@"action: %@", action);
    NSLog(@"label: %@", label);
    NSLog(@"value: %@", value);
}



-(void) setHighScore:(NSNumber *)HighScore{
    [session setHighScore:HighScore];
}

-(void) setProgressDescription:(NSString *)ProgressDescription {
    [session setProgressDescription:ProgressDescription];
}

-(void) setGameData:(NSString *)GameData{
    [session setGameData:GameData];
}

-(NSNumber *) HighScore{
    return [session HighScore];
}

-(NSString *) ProgressDescription{
    return [session ProgressDescription];
}

-(NSString *) GameData{
    return [session GameData];
}

-(NSString *) UserName{
    return [session username];
}

-(UIImage *) Avatar{
    return [session avatar];
}

-(NSString *) TeamName{
    return kTeamName;
}

-(NSString *) TeamShortCode{
    return kTeamCode;
}

-(NSString *) TeamCity{
    return kTeamCity;
}

-(UIImage *) TeamLogo{
    return [UIImage imageNamed:@"TeamLogo"];
}


@end
