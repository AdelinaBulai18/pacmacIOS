//
//  SessionManager.h
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-06.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

//#import "NXOAuth2.h"
#import "TMCache.h"

@interface SessionManager : NSObject {}

//@property (nonatomic, retain) NXOAuth2Account *account;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *deviceTokenString;
@property (nonatomic) BOOL seenToastTrivia;
@property (nonatomic) BOOL seenToastLocker;
@property (nonatomic) BOOL seenToastBadges;
@property (nonatomic) BOOL seenToastRoster;
@property (nonatomic) BOOL seenToastSchedule;
@property (nonatomic) BOOL seenToastRedeem;
@property (nonatomic) BOOL seenContentWelcome;
@property (nonatomic) BOOL seenRegisterTour;
@property (nonatomic, strong) NSMutableArray *localBadges;
@property (nonatomic, strong) NSMutableArray *cachedTrivia;
@property (nonatomic, strong) NSMutableArray *triviaAnswered;
@property (nonatomic) BOOL unlockedRoster;
@property (nonatomic, strong) NSArray *limitedRosterPicks;
@property (nonatomic) BOOL requestedPermission;
@property (nonatomic, strong) NSArray *cachedRoster;
@property (nonatomic, strong) NSDictionary *cachedBadges;
@property (nonatomic, strong) NSDictionary *cachedHouseholdBadges;

// Avatar
@property (nonatomic, strong) UIImage *avatar; // Full card version
@property (nonatomic, strong) UIImage *avatarTransparent; // Just the avatar
@property (nonatomic, strong) NSString *avatarParts; // Hyper Hippo Data
@property (nonatomic, strong) NSString *avatarMeta;  // Hyper Hippo Data

@property (nonatomic, strong) NSDictionary *avatarData; // Avatar Builder 2.0
@property (nonatomic, strong) NSMutableArray *unlockedAvatarPacks;
@property (nonatomic, strong) NSNumber *avatarPlayerNumber;
@property (nonatomic, strong) NSNumber *avatarPickedCard;
@property (nonatomic, strong) NSNumber *avatarSeenTour;

@property (nonatomic, strong) TMCache *userPersist;
@property (nonatomic, strong) NSString *localUsername;
@property (nonatomic) BOOL soundEnabled;
@property (nonatomic) BOOL musicEnabled;
@property (nonatomic, strong) NSMutableArray *hiddenContentHashes;
@property (nonatomic, strong) NSNumber *allowPost;
@property (nonatomic, strong) NSString *remoteUserId;
@property (nonatomic, strong) NSDictionary *trivia;
@property (nonatomic, strong) NSString *returnView;
@property (nonatomic, strong) NSString *returnStoryboard;

@property (nonatomic, strong) NSNumber *noticeAllowBadges;
@property (nonatomic, strong) NSNumber *noticeAllowContent;

//game shell
@property (nonatomic, strong) NSNumber* HighScore;
@property (nonatomic, strong) NSString* ProgressDescription;
@property (nonatomic, strong) NSString* GameData;

+ (id)sharedManager;
+ (id)getManagerForUser:(NSString *)user;
+ (id)getManagerForUserByUsername:(NSString *)username;
+ (void)removeUser:(NSString *)user;
+ (void)resetGuest;
+ (id)getManagerFromGuestForUser:(NSString *)user;
+ (NSMutableDictionary *)getUserList;
+ (NSMutableDictionary *)getUserListProper;

- (void)awardBadge:(NSString *)slug;
- (void)saveAll;

@end