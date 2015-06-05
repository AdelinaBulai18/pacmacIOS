//
//  SessionManager.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-06.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import "SessionManager.h"
#import "TMCache.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation SessionManager

static NSMutableDictionary *userList = nil;

//@synthesize account;
@synthesize username = _username;
@synthesize deviceTokenString = _deviceTokenString;
@synthesize seenToastBadges;
@synthesize seenToastLocker;
@synthesize seenToastRoster;
@synthesize seenToastTrivia;
@synthesize seenContentWelcome;
@synthesize seenRegisterTour = _seenRegisterTour;
@synthesize localBadges;
@synthesize cachedTrivia = _cachedTrivia;
@synthesize triviaAnswered = _triviaAnswered;
@synthesize limitedRosterPicks;
@synthesize unlockedRoster = _unlockedRoster;
@synthesize requestedPermission;
@synthesize cachedRoster;
@synthesize cachedBadges;
@synthesize cachedHouseholdBadges;

@synthesize avatar = _avatar;
@synthesize avatarTransparent = _avatarTransparent;
@synthesize avatarParts = _avatarParts;
@synthesize avatarMeta = _avatarMeta;
@synthesize avatarData = _avatarData;

@synthesize localUsername;
@synthesize soundEnabled = _soundEnabled;
@synthesize musicEnabled = _musicEnabled;
@synthesize hiddenContentHashes = _hiddenContentHashes;
@synthesize allowPost = _allowPost;
@synthesize remoteUserId;
@synthesize trivia = _trivia;

@synthesize returnStoryboard;
@synthesize returnView;

@synthesize noticeAllowBadges;
@synthesize noticeAllowContent;
/*
@synthesize HighScore;
@synthesize ProgressDescription;
@synthesize GameData;
*/
#pragma mark Singleton Methods

+ (void)initialize
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Initializing session storage");
    NSArray *storedUsers = [app.persistStore objectForKey:@"storedUsernames"];
    userList = [[NSMutableDictionary alloc] init];
    for (NSString *user in storedUsers) {
        NSLog(@"Loading user: %@", user);
        [userList setObject:[self getManagerForUser:user] forKey:user];
    }
}

+ (id)sharedManager
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [SessionManager getManagerForUser:app.activeUser];
}

+ (id)getManagerForUser:(NSString *)user
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"Fetching shared session for: %@", user);
    if ([userList objectForKey:user] == nil) {
        NSLog(@"Creating new session store for: %@", user);
        SessionManager *sharedSession = [[self alloc] initWithUsername:user];
        // Only set the username if we're the guest account
        if ([user isEqualToString:@"Guest"]) sharedSession.username = user;
        [userList setObject:sharedSession forKey:user];
        [app.persistStore setObject:[userList allKeys] forKey:@"storedUsernames"];
    }
    return [userList objectForKey:user];
}

+ (id)getManagerForUserByUsername:(NSString *)username
{
    for (NSString *curName in [SessionManager getUserListProper]) {
        SessionManager *curUser = [SessionManager getManagerForUser:curName];
        if (curUser.username != nil && [curUser.username isEqualToString:username]) {
            return curUser;
        }
    }
    return nil;
}

+ (id)getManagerFromGuestForUser:(NSString *)user
{
    NSLog(@"Copying guest account to new user: %@", user);
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [userList setObject:[self getManagerForUser:@"Guest"] forKey:user];
    [app.persistStore setObject:[userList allKeys] forKey:@"storedUsernames"];
    SessionManager *copiedUser = [userList objectForKey:user];
    copiedUser.localUsername = user;
    return copiedUser;
}

+ (NSMutableDictionary *)getUserList
{
    return userList;
}

+ (NSMutableDictionary *)getUserListProper
{
    NSMutableDictionary *sansGuest = [userList mutableCopy];
    [sansGuest removeObjectForKey:@"Guest"];
    return sansGuest;
}

+ (void)removeUser:(NSString *)user
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [userList removeObjectForKey:user];
    [app.persistStore setObject:[userList allKeys] forKey:@"storedUsernames"];
    TMCache *userAchieved = [[TMCache alloc] initWithName:[NSString stringWithFormat:@"user-%@", user]];
    [userAchieved removeAllObjects];
    userAchieved = nil;
}

+ (void)resetGuest
{
    NSLog(@"Resetting guest account");
    TMCache *userAchieved = [[TMCache alloc] initWithName:[NSString stringWithFormat:@"user-%@", @"Guest"]];
    [userAchieved removeAllObjects];
    [userList setObject:[[self alloc] initWithUsername:@"Guest"] forKey:@"Guest"];
}

- (void)setUnlockedRoster:(BOOL)state
{
    if (state) {
        [self.userPersist setObject:@"YES" forKey:@"unlockedRoster"];
        [self awardBadge:@"triviaguru5"];
    } else {
        [self.userPersist removeObjectForKey:@"unlockedRoster"];
    }
    _unlockedRoster = state;
}

- (void)setSoundEnabled:(BOOL)soundEnabled
{
    if (soundEnabled) {
        [self.userPersist setObject:@"YES" forKey:@"soundEnabled"];
    } else {
        [self.userPersist setObject:@"NO" forKey:@"soundEnabled"];
    }
    _soundEnabled = soundEnabled;
}

- (void)setMusicEnabled:(BOOL)musicEnabled
{
    if (musicEnabled) {
        [self.userPersist setObject:@"YES" forKey:@"musicEnabled"];
    } else {
        [self.userPersist setObject:@"NO" forKey:@"musicEnabled"];
    }
    _musicEnabled = musicEnabled;
}

- (void)awardBadge:(NSString *)slug
{
    [self awardBadge:slug silent:NO];
}

- (void)awardBadge:(NSString *)slug silent:(BOOL)silent
{
    for (NSMutableDictionary *badge in self.localBadges) {
        if ([[badge valueForKey:@"slug"] isEqualToString:slug]) {
            if ([(NSNumber *)[badge valueForKey:@"achieved"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [badge setValue:@1 forKey:@"achieved"];
                [badge setValue:@1 forKey:@"count"];
                [badge setValue:@100 forKey:@"progress"];
                if (!silent) [[NSNotificationCenter defaultCenter] postNotificationName:@"badgeAchieved" object:self userInfo:[badge copy]];
            }
            break;
        }
    }
}

- (id)init
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [self initWithUsername:app.activeUser];
}

- (id)initWithUsername:(NSString *)aUsername
{
    if (self = [super init]) {
        // Initial values
        
        self.userPersist = [[TMCache alloc] initWithName:[NSString stringWithFormat:@"user-%@", aUsername]];

        self.localBadges = [[NSMutableArray alloc] init];
        [self.localBadges addObjectsFromArray:[kBadgeLocalDefaults mutableCopy]];

        // Set these after initializing the default badges
        self.localUsername = aUsername;
        
        // Default the sounds on
        if ([self.userPersist objectForKey:@"soundEnabled"] == nil) [self.userPersist setObject:@"YES" forKey:@"soundEnabled"];
        
        _seenRegisterTour = [[self.userPersist objectForKey:@"seenRegisterTour"] isEqualToString:@"YES"];
        
        _soundEnabled = [[self.userPersist objectForKey:@"soundEnabled"] isEqualToString:@"YES"];
        _musicEnabled = [[self.userPersist objectForKey:@"musicEnabled"] isEqualToString:@"YES"];
        
        _unlockedRoster = [[self.userPersist objectForKey:@"unlockedRoster"] isEqualToString:@"YES"];
        if (_unlockedRoster) [self awardBadge:@"triviaguru5" silent:YES];
        
        _avatarTransparent = [self.userPersist objectForKey:@"avatarTransparent"];
        _avatar = [self.userPersist objectForKey:@"avatar"];
        _avatarParts = [self.userPersist objectForKey:@"avatarParts"];
        _avatarMeta = [self.userPersist objectForKey:@"avatarMeta"];
        
        // New Avatar builder
        _avatarData = [self.userPersist objectForKey:@"avatarData"];
        _unlockedAvatarPacks = [self.userPersist objectForKey:@"unlockedAvatarPacks"];
        _avatarPlayerNumber = [self.userPersist objectForKey:@"avatarPlayerNumber"];
        _avatarPickedCard = [self.userPersist objectForKey:@"avatarPickedCard"];
        _avatarSeenTour = [self.userPersist objectForKey:@"avatarSeenTour"];
        
        _username = [self.userPersist objectForKey:@"username"];
        _triviaAnswered = [self.userPersist objectForKey:@"triviaAnswered"];
        _cachedTrivia = [self.userPersist objectForKey:@"cachedTrivia"];
        _deviceTokenString = [self.userPersist objectForKey:@"deviceTokenString"];
        _hiddenContentHashes = [self.userPersist objectForKey:@"hiddenContentHashes"];
        _allowPost = [self.userPersist objectForKey:@"allowPost"];
        _trivia = [self.userPersist objectForKey:@"trivia"];
        
        //game shell stuff
        _HighScore = [self.userPersist objectForKey:@"HighScore"];
        _ProgressDescription = [self.userPersist objectForKey:@"ProgressDescription"];
        _GameData = [self.userPersist objectForKey:@"GameData"];
        
        if (_allowPost == nil) _allowPost = @1;
        
        [self checkTriviaBadges:YES];
        
    }
    return self;
}

- (void)setSeenRegisterTour:(BOOL)seenRegisterTour
{
    _seenRegisterTour = seenRegisterTour;
    [self.userPersist setObject:seenRegisterTour ? @"YES" : @"NO" forKey:@"seenRegisterTour"];
}

- (void)setAllowPost:(NSNumber *)allowPost
{
    _allowPost = allowPost;
    [self.userPersist setObject:allowPost forKey:@"allowPost"];
}

- (void)setHiddenContentHashes:(NSMutableArray *)hiddenContentHashes
{
    _hiddenContentHashes = hiddenContentHashes;
    [self.userPersist setObject:hiddenContentHashes forKey:@"hiddenContentHashes"];
    //NSLog(@"Saving hidden: %@", hiddenContentHashes);
}

- (void)setTrivia:(NSDictionary *)trivia
{
    _trivia = trivia;
    [self.userPersist setObject:trivia forKey:@"trivia"];
    [self checkTriviaBadges:NO];
}

- (void)checkTriviaBadges:(BOOL)silent
{
    if ([_trivia isKindOfClass:[NSDictionary class]]) {
        if ([_trivia[@"answeredQuestions"] isKindOfClass:[NSDictionary class]]) {
            NSArray *triviaAnswered = [_trivia[@"answeredQuestions"] allKeys];
            if ([triviaAnswered count] >= 5) self.unlockedRoster = YES;
            if ([triviaAnswered count] >= 10) [self awardBadge:@"triviaguru10" silent:silent];
            if ([triviaAnswered count] >= 25) [self awardBadge:@"triviaguru25" silent:silent];
        }
    }
}

- (void)setCachedTrivia:(NSMutableArray *)cachedTrivia
{
    _cachedTrivia = cachedTrivia;
    [self.userPersist setObject:cachedTrivia forKey:@"cachedTrivia"];
}

- (void)setTriviaAnswered:(NSMutableArray *)triviaAnswered
{
    // Delay the badge awardment until after the reactview closes
    if ([triviaAnswered count] >= 5) self.unlockedRoster = YES;
    if ([triviaAnswered count] >= 10) [self awardBadge:@"triviaguru10"];
    if ([triviaAnswered count] >= 25) [self awardBadge:@"triviaguru25"];
    _triviaAnswered = triviaAnswered;
    [self.userPersist setObject:triviaAnswered forKey:@"triviaAnswered"];
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    [self.userPersist setObject:username forKey:@"username"];
}

- (void)setAvatarTransparent:(UIImage *)avatarTransparent
{
    _avatarTransparent = avatarTransparent;
    [self.userPersist setObject:avatarTransparent forKey:@"avatarTransparent"];
}

- (void)setAvatarParts:(NSString *)avatarParts
{
    //NSLog(@"Avatar parts saved: %@", avatarParts);
    _avatarParts = avatarParts;
    [self.userPersist setObject:avatarParts forKey:@"avatarParts"];
}

- (void)setAvatarMeta:(NSString *)avatarMeta
{
    //NSLog(@"Avatar meta saved: %@", avatarMeta);
    _avatarMeta = avatarMeta;
    [self.userPersist setObject:avatarMeta forKey:@"avatarMeta"];
}

- (void)setAvatar:(UIImage *)avatar
{
    _avatar = avatar;
    [self.userPersist setObject:avatar forKey:@"avatar"];
}

- (void)setAvatarData:(NSDictionary *)avatarData
{
    _avatarData = avatarData;
    [self.userPersist setObject:avatarData forKey:@"avatarData"];
}

- (void)setUnlockedAvatarPacks:(NSMutableArray *)unlockedAvatarPacks
{
    _unlockedAvatarPacks = unlockedAvatarPacks;
    [self.userPersist setObject:unlockedAvatarPacks forKey:@"unlockedAvatarPacks"];
}

- (void)setAvatarPlayerNumber:(NSNumber *)avatarPlayerNumber
{
    _avatarPlayerNumber = avatarPlayerNumber;
    [self.userPersist setObject:avatarPlayerNumber forKey:@"avatarPlayerNumber"];
}

- (void)setAvatarSeenTour:(NSNumber *)avatarSeenTour
{
    _avatarSeenTour = avatarSeenTour;
    [self.userPersist setObject:avatarSeenTour forKey:@"avatarSeenTour"];
}

- (void)setAvatarPickedCard:(NSNumber *)avatarPickedCard
{
    _avatarPickedCard = avatarPickedCard;
    [self.userPersist setObject:avatarPickedCard forKey:@"avatarPickedCard"];
}

- (void)setDeviceTokenString:(NSString *)deviceTokenString
{
    _deviceTokenString = deviceTokenString;
    [self.userPersist setObject:deviceTokenString forKey:@"deviceTokenString"];
}

-(void) setHighScore:(NSNumber *)HighScore{
    _HighScore = HighScore;
    [self.userPersist setObject:HighScore forKey:@"HighScore"];
}

-(void) setProgressDescription:(NSString *)ProgressDescription{
    _ProgressDescription = ProgressDescription;
    [self.userPersist setObject:ProgressDescription forKey:@"ProgressDescription"];
    
}

-(void) setGameData:(NSString *)GameData{
    _GameData = GameData;
    [self.userPersist setObject:GameData forKey:@"GameData"];
}

- (void)saveAll
{
    //NSLog(@"Re-saving everything for %@", self.localUsername);
    self.userPersist = [[TMCache alloc] initWithName:[NSString stringWithFormat:@"user-%@", self.localUsername]];
    
    if (_soundEnabled) {
        [self.userPersist setObject:@"YES" forKey:@"soundEnabled"];
    } else {
        [self.userPersist setObject:@"NO" forKey:@"soundEnabled"];
    }
    
    if (_musicEnabled) {
        [self.userPersist setObject:@"YES" forKey:@"musicEnabled"];
    } else {
        [self.userPersist setObject:@"NO" forKey:@"musicEnabled"];
    }
    
    if (_unlockedRoster) {
        [self.userPersist setObject:@"YES" forKey:@"unlockedRoster"];
    } else {
        [self.userPersist setObject:@"NO" forKey:@"unlockedRoster"];
    }
    
    [self.userPersist setObject:_trivia forKey:@"trivia"];
    [self.userPersist setObject:_cachedTrivia forKey:@"cachedTrivia"];
    [self.userPersist setObject:_triviaAnswered forKey:@"triviaAnswered"];
    [self.userPersist setObject:_username forKey:@"username"];
    [self.userPersist setObject:_avatarTransparent forKey:@"avatarTransparent"];
    [self.userPersist setObject:_avatarParts forKey:@"avatarParts"];
    [self.userPersist setObject:_avatarMeta forKey:@"avatarMeta"];
    [self.userPersist setObject:_avatar forKey:@"avatar"];
    [self.userPersist setObject:_avatarData forKey:@"avatarData"];
    [self.userPersist setObject:_deviceTokenString forKey:@"deviceTokenString"];
    [self.userPersist setObject:_hiddenContentHashes forKey:@"hiddenContentHashes"];
    [self.userPersist setObject:_allowPost forKey:@"allowPost"];
}

@end