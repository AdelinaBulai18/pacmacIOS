//
//  Constants.h
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-16.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//
//

#ifndef SportsAppTemplate_Constants_h
#define SportsAppTemplate_Constants_h

extern NSString* const kBaseURL;
extern NSString* const kHostDomain;
extern NSUInteger const kSocketPort;
extern NSString* const kGoogleAnalyticsId;

extern NSString* const kContentBaseURL;
extern NSInteger const kContentCacheExpiry;

extern NSString* const kAppName;

extern BOOL const demoMode;
extern BOOL const kRatingDemoMode;

extern NSString* const kLeague;
extern NSString* const kTeamSlug;
extern NSString* const kTeamName;
extern NSString* const kTeamCity;
extern NSString* const kTeamCode;
extern NSUInteger const kTeamId;
extern NSString* const kWelcomeTextFormat;
extern NSString* const kWelcomeDefaultPlayerName;

extern NSUInteger const kChosenPlayer;
extern NSUInteger const kLimitedRosterAmount;

extern NSUInteger const kContentLoadAhead;
extern NSUInteger const kContentLoadIncrement;
extern NSString* const kContentCampaign;

extern NSUInteger const kTriviaLoadIncrement;

// Badges
extern NSString* const kBadgeEnabledSuffix;
extern NSString* const kBadgeDisabledSuffix;

// Fantasy League
#define kStokedMessages @[@"Aww yeah!", @"Pick me!", @"We can win!", @"Me! Pick me!", @"Woohoo!", @"You can do it!", @"Let's go boys!"]
#define kKeepMessages @[@"You made the right choice", @"Good call", @"We're going to win!", @"Let's go!", @"He shoots he scores!", @"Right on!", @"Let's do this!", @"Well done!", @"You've got it!"]

#define kBadgeCategoryNames ((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys: \
    @"Family Badges",                @"platform", \
    @"A Million Acts of Friendship", @"maof", \
    @"Abundant Acts",                @"abundantActs", \
    @"Chicago Blackhawks",           @"blackhawks", \
nil]);

#define kBadgeLocalDefaults @[ [@{ \
    @"achieved": @0, \
    @"category": @"blackhawks", \
    @"count": @0, \
    @"description": @"Answered 5 trivia questions", \
    @"meta": @{ \
               @"hidden": @0, \
               @"limit": @"-1" \
               }, \
    @"name": @"Trivia Guru", \
    @"progress": @0, \
    @"slug": @"triviaguru5" \
} mutableCopy], [@{ \
    @"achieved": @0, \
    @"category": @"blackhawks", \
    @"count": @0, \
    @"description": @"Answered 10 trivia questions", \
    @"meta": @{ \
        @"hidden": @0, \
        @"limit": @"-1" \
    }, \
    @"name": @"Trivia Guru (10)", \
    @"progress": @0, \
    @"slug": @"triviaguru10" \
} mutableCopy], [@{ \
    @"achieved": @0, \
    @"category": @"blackhawks", \
    @"count": @0, \
    @"description": @"Answered 25 trivia questions", \
    @"meta": @{ \
        @"hidden": @0, \
        @"limit": @"-1" \
    }, \
    @"name": @"Trivia Guru (25)", \
    @"progress": @0, \
    @"slug": @"triviaguru25" \
} mutableCopy] ]

// Flames Colors
/*
#define kAvatarAccessoryColors @[ \
    [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0], \
    [UIColor colorWithRed:0.59607 green:0.59607 blue:0.59607 alpha:1.0], \
    [UIColor colorWithRed:0.13725 green:0.13725 blue:0.13725 alpha:1.0], \
    [UIColor colorWithRed:1 green:0.77647 blue:0.03529 alpha:1.0], \
    [UIColor colorWithRed:0.92941 green:0.10980 blue:0.14117 alpha:1.0], \
    [UIColor colorWithRed:0.76862 green:0.15686 blue:0.14901 alpha:1.0], \
]*/

// Blackhawks Colors
#define kAvatarAccessoryColors @[ \
[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0], \
[UIColor colorWithRed:0.59607 green:0.59607 blue:0.59607 alpha:1.0], \
[UIColor colorWithRed:0.13725 green:0.13725 blue:0.13725 alpha:1.0], \
[UIColor colorWithRed:0.63921 green:0.85882 blue:0.88627 alpha:1.0], \
[UIColor colorWithRed:0.81176 green:0.20000 blue:0.23921 alpha:1.0], \
[UIColor colorWithRed:0.72941 green:0.14509 blue:0.20392 alpha:1.0], \
]

// Swatches & Global Fonts
#define kGlobalFont @"Arvo"
#define kGlobalFontBold @"Arvo-bold"
#define kColorTitles [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorLabels [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]
#define kFontTitles [UIFont fontWithName:kGlobalFont size:18]
#define kFontLabels [UIFont fontWithName:kGlobalFont size:16]
#define kFontTitlesBold [UIFont fontWithName:kGlobalFontBold size:18]
#define kFontLabelsBold [UIFont fontWithName:kGlobalFontBold size:16]
#define kColorBackgrounds [UIColor colorWithRed:0.443 green:0.047 blue:0.106 alpha:1.0]

#define kColorModalTitles [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define kColorModalLabels [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define kColorModalBackgrounds [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0]

// Global App Styles
#define kNavBarTintColor [UIColor colorWithRed:0.886 green:0.094 blue:0.212 alpha:1.0]
#define kNavBarTextColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kNavBarButtonColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kColorSidebarBackground kColorBackgrounds
#define kColorSidebarText [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorSidebarSwitchButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorSidebarButton [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0]
#define kColorToastBackground [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorToastLabel [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define kColorModalOverlay [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]

#define kColorTooltipBackground kNavBarTintColor
#define kColorTooltipLabel [UIColor whiteColor]

#define kFontNavBarButton [UIFont fontWithName:kGlobalFont size:15]
#define kFontNavBarText [UIFont fontWithName:kGlobalFont size:17]
#define kFontSidebarText kFontLabels
#define kFontSidebarSwitchButton [UIFont fontWithName:kGlobalFont size:18]
#define kFontSidebarButton [UIFont fontWithName:kGlobalFont size:17]

#define kFontToastTitle [UIFont fontWithName:kGlobalFont size:15]
#define kFontToastLabel [UIFont fontWithName:kGlobalFont size:13]

// Content Feed / Locker / Fridge
#define kContentBackgroundColor kColorBackgrounds
#define kContentCellBackgroundColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kContentCaptionColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define kContentAttribColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define kContentDateColor [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]

#define kFontContentCaption [UIFont fontWithName:kGlobalFont size:17]
#define kFontContentAttrib [UIFont fontWithName:kGlobalFont size:17]
#define kFontContentDate [UIFont fontWithName:kGlobalFont size:13]

#define kGameNightBannerColor [UIColor colorWithRed:0.86 green:0.95 blue:0.96 alpha:1.0]

// Welcome popup
#define kFontWelcomeText [UIFont fontWithName:kGlobalFont size:17]
#define kFontWelcomeButton [UIFont fontWithName:kGlobalFont size:16]
#define kColorWelcomeButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorWelcomeButtonBackground [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]

// Settings Area
#define kColorSettingsBackground kColorBackgrounds
#define kColorSettingsTitleLabel kColorTitles
#define kColorSettingsLabel kColorLabels
#define kColorSettingsButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorSettingsSwitchOn [UIColor colorWithRed:0.886 green:0.094 blue:0.212 alpha:1.0]
#define kColorSettingsSwitchOff [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]

#define kFontSettingsTitleLabel kFontTitles
#define kFontSettingsLabel kFontLabels
#define kFontSettingsButton [UIFont fontWithName:kGlobalFont size:15]

// Trivia
#define kColorTriviaBackground kColorBackgrounds
#define kColorTriviaTitleLabel kColorModalTitles
#define kColorTriviaAnswerLabel kColorModalTitles
#define kColorTriviaLabel kColorModalLabels
#define kColorTriviaRevealBackground [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]
#define kColorTriviaButton [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]

#define kFontTriviaTitleLabel kFontTitles
#define kFontTriviaAnswerLabel kFontLabels
#define kFontTriviaLabel [UIFont fontWithName:kGlobalFont size:15]
#define kFontTriviaButton [UIFont fontWithName:kGlobalFont size:14]

// Roster
#define kRosterBackgroundColor kColorBackgrounds

#define kRosterCellBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define kRosterGoalieCellBackgroundColor kRosterCellBackgroundColor

#define kRosterBackgroundTextColor [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5]
#define kRosterGoalieBackgroundTextColor kRosterBackgroundTextColor

#define kRosterNameColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontRosterTitleLabel kFontTitles
#define kFontRosterLabel kFontLabels

// Badge Book
#define kColorBadgeBackground kColorBackgrounds
#define kColorBadgeCellBackground [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.0]
#define kColorBadgeSectionBackground [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define kColorBadgeTitleLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorBadgeLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontBadgeTitleLabel kFontTitles
#define kFontBadgeLabel [UIFont fontWithName:kGlobalFont size:11]
#define kFontBadgeToggleButton [UIFont fontWithName:kGlobalFont size:14]

// Badge Info Popup
#define kColorBadgeModalTitleLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorBadgeModalLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontBadgeModalTitleLabel kFontTitles
#define kFontBadgeModalLabel [UIFont fontWithName:kGlobalFont size:13]

// About
#define kColorAboutBackground kColorBackgrounds
#define kColorAboutTitleLabel kColorModalTitles
#define kColorAboutLabel kColorModalLabels
#define kColorAboutButton [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]

#define kFontAboutTitleLabel kFontTitles
#define kFontAboutLabel kFontLabels
#define kFontAboutButton [UIFont fontWithName:kGlobalFont size:18]

// Help Area
#define kColorHelpBackground kColorBackgrounds
#define kColorHelpTitleLabel kColorTitles
#define kColorHelpLabel kColorLabels
#define kColorHelpButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontHelpTitleLabel kFontTitles
#define kFontHelpLabel kFontLabels
#define kFontHelpButton [UIFont fontWithName:kGlobalFont size:18]

// Call to Action
#define kColorCTABackground kColorBackgrounds
#define kColorCTATitleLabel kColorModalTitles
#define kColorCTALabel kColorModalLabels
#define kColorCTAButton [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]

#define kFontCTATitleLabel kFontTitles
#define kFontCTALabel kFontLabels
#define kFontCTAButton [UIFont fontWithName:kGlobalFont size:18]

// Register
#define kColorRegisterBackground kColorBackgrounds
#define kColorRegisterTitleLabel kColorTitles
#define kColorRegisterLabel kColorLabels
#define kColorRegisterButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontRegisterTitleLabel kFontTitles
#define kFontRegisterLabel kFontLabels
#define kFontRegisterButton [UIFont fontWithName:kGlobalFont size:18]

// Login
#define kColorLoginBackground kColorBackgrounds
#define kColorLoginTitleLabel kColorTitles
#define kColorLoginLabel kColorLabels
#define kColorLoginButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontLoginTitleLabel kFontTitles
#define kFontLoginLabel kFontLabels
#define kFontLoginButton [UIFont fontWithName:kGlobalFont size:18]

// Request Permission
#define kColorPermissionBackground kColorBackgrounds
#define kColorPermissionTitleLabel kColorTitles
#define kColorPermissionLabel kColorLabels
#define kColorPermissionButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kFontPermissionTitleLabel kFontTitles
#define kFontPermissionLabel kFontLabels
#define kFontPermissionButton [UIFont fontWithName:kGlobalFont size:18]

// Club Rules Dialog
#define kColorRulesBackground [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorRulesTitleLabel kColorModalTitles
#define kColorRulesLabel kColorModalLabels
#define kColorRulesButton [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]

#define kFontRulesTitleLabel kFontTitles
#define kFontRulesLabel [UIFont fontWithName:kGlobalFont size:13]
#define kFontRulesButton [UIFont fontWithName:kGlobalFont size:18]

// Register Call to Action
#define kFontCTARegisterLabel [UIFont fontWithName:kGlobalFont size:17]

// Multi User Switching
#define kColorUserSwitchingCellLabel [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]
#define kColorUserSwitchingBackLabel [UIColor colorWithRed:0.514 green:0.122 blue:0.149 alpha:1.0]
#define kColorUserSwitchingSwitchButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorUserSwitchingButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorUserSwitchingCancelButton [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kColorUserSwitchingBackground [UIColor colorWithRed:0.89 green:0.22 blue:0.26 alpha:1.0]
#define kColorUserSwitchingCellBackground [UIColor clearColor]
#define kColorUserSwitchingNewCellBackground [UIColor clearColor]

#define kFontUserSwitchingCellLabel [UIFont fontWithName:kGlobalFont size:13]
#define kFontUserSwitchingBackNameLabel [UIFont fontWithName:kGlobalFont size:18]
#define kFontUserSwitchingPasswordField [UIFont fontWithName:kGlobalFont size:18]
#define kFontUserSwitchingSwitchButton [UIFont fontWithName:kGlobalFont size:18]
#define kFontUserSwitchingButton [UIFont fontWithName:kGlobalFont size:18]
#define kFontUserSwitchingCancelButton [UIFont fontWithName:kGlobalFont size:14]
#define kFontUserSwitchingFields [UIFont fontWithName:kGlobalFont size:18]

// Fantasy League
#define kColorFantasyBackground [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]

// Main Screen Round Overview
#define kColorFantasyRoundTopBackground [UIColor colorWithRed:0.188 green:0.176 blue:0.149 alpha:1.0]

#define kColorFantasyRoundCellActiveBackground [UIColor colorWithRed:0.443 green:0.047 blue:0.106 alpha:1.0]
#define kColorFantasyRoundCellPastBackground [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0]
#define kColorFantasyRoundCellBackground [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.0]
#define kColorFantasyRoundCellLabel [UIColor whiteColor]

// Picks
#define kColorFantasyPickedCellBackground [UIColor colorWithRed:0.475 green:0.137 blue:0.18 alpha:1.0]
#define kColorFantasyAvailableCellBackground [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]

// Round Summary
#define kColorFantasySummaryBackground [UIColor colorWithRed:0.443 green:0.047 blue:0.106 alpha:1.0]
#define kColorFantasySummaryCellBackground [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0]
#define kColorFantasySummaryCellLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

// Intents
extern const int kIntentAvatarCreated;
extern const int kIntentAvatarCancelled;
extern const int kIntentAvatarMarket;
extern const int kIntentAvatarUpdated;

extern BOOL const kNeedUnlockRoster;

#endif
