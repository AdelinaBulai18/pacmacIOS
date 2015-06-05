//
//  GameManager.h
//  SportsAppTemplate
//
//  Created by Daniel Sexton on 2015-04-21.
//  Copyright (c) 2015 Just Be Friends Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject
@property (readonly, nonatomic, strong) NSString* GameId;

@property (readonly, nonatomic, strong) NSString* UserName;
@property (readonly, nonatomic, strong) UIImage* Avatar;

@property (readonly, nonatomic, strong) NSString* TeamName;
@property (readonly, nonatomic, strong) NSString* TeamShortCode;
@property (readonly, nonatomic, strong) NSString* TeamCity;
@property (readonly, nonatomic, strong) UIImage* TeamLogo;

@property (nonatomic, strong) NSNumber* HighScore;
@property (nonatomic, strong) NSString* ProgressDescription;
@property (nonatomic, strong) NSString* GameData;


- (id) initWithGameId: (NSString*)gameId;
- (id) initWithTestScore:(NSNumber*)score progress:(NSString*)progress GameData: (NSString*)data andGameId:(NSString*)gameId;


-(void)recordScore: (NSNumber *)score;
-(void)recordEventWithCategory: (NSString*)category Action: (NSString*)action Label: (NSString*)label AndValue: (NSNumber*)value;

@end
