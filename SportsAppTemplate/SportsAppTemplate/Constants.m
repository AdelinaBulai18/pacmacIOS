//
//  Constants.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-16.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import "Constants.h"

// Production server values
NSString* const kApplicationHash = @"";
NSString* const kApplicationGroupHash =  @"";
NSString* const kApplicationSecret = @"";
NSString* const kBaseURL = @"https://www.jbfsports.com";
NSString* const kHostDomain = @"www.jbfsports.com";
NSUInteger const kSocketPort = 443;
NSString* const kGoogleAnalyticsId = @"UA-53069118-2";

BOOL const demoMode = NO;
BOOL const kRatingDemoMode = NO;

NSString* const kAppName = @"Club JBF";

// Static content server (CDN)
NSString* const kContentBaseURL = @"https://www.jbfsports.com/static/cdn";
NSInteger const kContentCacheExpiry = -86400;

// League
NSString* const kLeague = @"nhl";

// Team name (Blackhawks) used for content meta as well as folder paths, etc
NSString* const kTeamSlug = @"jbf";
NSString* const kTeamName = @"Team JBF";
NSString* const kTeamCity = @"Kelowna";
NSString* const kTeamCode = @"JBF";

// Welcome text
NSString* const kWelcomeTextFormat = @"Hi, I'm %@. Welcome to %@!";
NSString* const kWelcomeDefaultPlayerName = @"Joe Smith";

// Chosen player's number, guarantees they show up in limited roster view
NSUInteger const kChosenPlayer = 19;
NSUInteger const kLimitedRosterAmount = 2; // How many additional players to be chosen randomly for limited roster view

// Sports team ID (Blackhawks = 1)
NSUInteger const kTeamId = 1;


// BADGES

NSString* const kBadgeDisabledSuffix = @"-disabled.png";
NSString* const kBadgeEnabledSuffix = @".png";


// Content
NSUInteger const kContentLoadAhead = 3;
NSUInteger const kContentLoadIncrement = 10;
NSString* const kContentCampaign = @"sportsApp";

// Trivia
NSUInteger const kTriviaLoadIncrement = 10;

// Intents
const int kIntentAvatarCreated = 10;
const int kIntentAvatarCancelled = 11;
const int kIntentAvatarMarket = 12;
const int kIntentAvatarUpdated = 13;

BOOL const kNeedUnlockRoster = NO;
