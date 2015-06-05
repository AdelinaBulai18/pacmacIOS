//
//  TriviaOverviewController.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-11-13.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import "TriviaOverviewController.h"
#import "TriviaStageViewController.h"
#import "DateTools.h"

@interface TriviaOverviewController () {
    TriviaDataManager *triviaData;
    IBOutlet UITableView *categoryTable;
    IBOutlet UIButton *difficultyButton;
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *totalCorrectLabel;
    IBOutlet UILabel *totalPointsLabel;
    IBOutlet UILabel *nameLabel;
    NSNumber *difficulty;
    IBOutlet UIImageView *offline;
    IBOutlet UIView *difficultyBackground;
    id AvatarUpdatedNotice;
}

@end

@implementation TriviaOverviewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [JBFUIViewController applyStyles:self];
    
    // drop shadow
    [difficultyBackground.layer setShadowColor:[UIColor blackColor].CGColor];
    [difficultyBackground.layer setShadowOpacity:0.4];
    [difficultyBackground.layer setShadowRadius:7.0];
    [difficultyBackground.layer setShadowOffset:CGSizeMake(0.0, 3.0)];
    
    if (triviaData == nil) triviaData = [[TriviaDataManager alloc] init];
    if (difficulty == nil) difficulty = @1;
    
    [triviaData fetchOverview:^{
        //NSLog(@"Categories: %@", [triviaData categories]);
        [offline setHidden:YES];
        [categoryTable reloadData];
        [self checkUpdates];
        [self updatePointTotals];
    } error:^{
        [offline setHidden:NO];
    }];
    
    [self updateDifficultyIndicator];
    [self updatePointTotals];
    
    SessionManager *sharedSession = [SessionManager sharedManager];
    if (sharedSession.avatarTransparent) [avatar setImage:sharedSession.avatarTransparent];
    [nameLabel setText:sharedSession.localUsername];
    
    [offline setHidden:YES];
    
    AvatarUpdatedNotice = [[NSNotificationCenter defaultCenter] addObserverForName:@"avatarUpdated" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [avatar setImage:sharedSession.avatarTransparent];
    }];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // A little welcome toast for guests
    if (!sharedSession.seenToastTrivia && !sharedSession.account) {
        app.toast = [[ToastViewController alloc] initAndPopupOnView:(UIViewController *)self.navigationController
                                                              title:@"Save your badges"
                                                        description:@"Remember to Register for exclusive access!"
                                                             action:nil];
        sharedSession.seenToastTrivia = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Trivia Overview"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:AvatarUpdatedNotice];
}

- (void)dealloc
{

    [triviaData unload];
    triviaData = nil;
}

- (void)checkUpdates
{
    for (NSDictionary *category in [triviaData categoriesVisible]) {
        //NSLog(@"Cat: %@", category);
        BOOL needsUpdate = [triviaData categoryNeedsUpdate:category[@"id"]];
        if (needsUpdate && [triviaData isCategoryDownloaded:category[@"id"]]) {
            //NSLog(@"Category needs update.");
            TriviaCategoryTableViewCell *cell = [self cellForCategory:category];
            [self downloadPackWithCategory:category cell:cell updating:YES];
        }
    }
}

- (void)setDifficulty:(NSNumber *)level withManager:(TriviaDataManager *)manager
{
    triviaData = manager;
    difficulty = level;
    [self updateDifficultyIndicator];
    [self updatePointTotals];
    [categoryTable reloadData];
}

#pragma mark - IBAction

- (IBAction)showAvatar:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showAvatar];
}

- (IBAction)cycleDifficulty:(id)sender
{
    if ([difficulty isEqualToNumber:@1]) {
        difficulty = @2;
    } else if ([difficulty isEqualToNumber:@2]) {
        difficulty = @3;
    } else {
        difficulty = @1;
    }
    
    [self updateDifficultyIndicator];
    [self animateCategoryCells];
}

- (void)updatePointTotals
{
    NSUInteger totalPoints = 0;
    NSUInteger totalCorrect = 0;
    
    NSMutableDictionary *answered = [triviaData answeredQuestions];
    totalCorrect = [answered count];
    totalPoints = [triviaData pointsTotal];
    
    [totalCorrectLabel setText:[NSString stringWithFormat:@"%i", totalCorrect]];
    [totalPointsLabel setText:[NSString stringWithFormat:@"%i Points", totalPoints]];
}

- (void)updateDifficultyIndicator
{
    if ([difficulty isEqualToNumber:@1]) {
        [difficultyButton setTitle:@"Difficulty: Easy" forState:UIControlStateNormal];
        [difficultyButton setImage:[UIImage imageNamed:@"TriviaDifficulty1"] forState:UIControlStateNormal];
    } else if ([difficulty isEqualToNumber:@2]) {
        [difficultyButton setTitle:@"Difficulty: Medium" forState:UIControlStateNormal];
        [difficultyButton setImage:[UIImage imageNamed:@"TriviaDifficulty2"] forState:UIControlStateNormal];
    } else {
        [difficultyButton setTitle:@"Difficulty: Hard" forState:UIControlStateNormal];
        [difficultyButton setImage:[UIImage imageNamed:@"TriviaDifficulty3"] forState:UIControlStateNormal];
    }
}

- (void)animateCategoryCells
{
    NSArray *cells = [categoryTable visibleCells];
    NSUInteger cellNumber = 0;
    for (TriviaCategoryTableViewCell *cell in cells) {
        /*
        [UIView animateWithDuration:0.15 delay:cellNumber * 0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            cell.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (cell != nil && finished) {
                CGRect cellFrame = cell.frame;
                //CGRect cellOffscreenFrame = cell.frame;
                //cellOffscreenFrame.origin.x = categoryTable.frame.size.width + 20;
                //cell.frame = cellOffscreenFrame;
         
                [UIView animateWithDuration:0.4 delay:cellNumber * 0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    //cell.frame = cellFrame;
                } completion:^(BOOL finished) {
                    if (cell != nil && finished) {
                        //cell.alpha = 1.0;*/
        
                /*   }
                }];
            }
        }];
        */
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000 * cellNumber), dispatch_get_main_queue(), ^{
        [categoryTable reloadRowsAtIndexPaths:@[[categoryTable indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationLeft];
        //});
        
        
        cellNumber++;
    }
}

- (void)downloadPack:(TriviaCategoryTableViewCell *)sender
{
    NSIndexPath *indexPath = [categoryTable indexPathForCell:sender];
    NSDictionary *category = [[triviaData categoriesVisible] objectAtIndex:indexPath.row];
    [self downloadPackWithCategory:category cell:sender updating:NO];
}

- (void)downloadPackWithCategory:(NSDictionary *)category cell:(TriviaCategoryTableViewCell *)cell updating:(BOOL)updating
{
    [cell.downloadButton setHidden:NO];
    [cell.downloadButton setEnabled:NO];
    [cell.downloadButton setTitle:updating ? @"Updating..." : @"Downloading..."
                         forState:UIControlStateNormal];
    [cell.answered setHidden:YES];
    
    [triviaData fetchCategory:category[@"id"] onProgress:^(CGFloat progress, BOOL done) {
        //NSLog(@"Download Progress: %f %i", progress, done);
        NSIndexPath *indexPath = [categoryTable indexPathForCell:cell];
        
        if (cell != nil && indexPath != nil) {
            NSUInteger newIndex = [[triviaData categoriesVisible] indexOfObject:category];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newIndex inSection:0];
            
            [cell.answered setHidden:NO];
            [cell.downloadButton setHidden:YES];
            [categoryTable beginUpdates];

            [self configureCellInTableView:categoryTable cell:cell withCategory:category];
            
            [categoryTable moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [categoryTable endUpdates];
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                                  action:@"trivia_download_pack"  // Event action (required)
                                                                   label:category[@"name"]     // Event label
                                                                   value:nil] build]];    // Event value
            
        }
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[triviaData categoriesVisible] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TriviaCategoryTableViewCell *cell = (TriviaCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TriviaCategoryCell"];
    NSDictionary *currentCategory = [[triviaData categoriesVisible] objectAtIndex:indexPath.row];
    
    [self configureCellInTableView:tableView cell:cell withCategory:currentCategory];
    
    [cell setDelegate:self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *category = [[triviaData categoriesVisible] objectAtIndex:[categoryTable indexPathForSelectedRow].row];
    [self startWave:category];
}

- (void)startWave:(NSDictionary *)category
{
    if ([self canLaunch:category]) {
        [self performSegueWithIdentifier:@"StartTrivia" sender:category];
    }
}

- (BOOL)canLaunch:(NSDictionary *)category
{
    BOOL canUse = [category[@"canUse"] isEqualToNumber:@1];
    return canUse &&
    // Is it downloaded?
    [triviaData isCategoryDownloaded:category[@"id"]] &&
    // Only can launch if there are questions left at this difficulty
    [[triviaData unansweredQuestionFromCategory:category[@"id"]
                                       forLevel:difficulty
                                       existing:nil] count];
}

- (void)startWaveFromCell:(TriviaCategoryTableViewCell *)cell
{
    NSDictionary *category = [[triviaData categoriesVisible] objectAtIndex:[categoryTable indexPathForCell:cell].row];
    [self startWave:category];
}

- (void)configureCellInTableView:(UITableView *)tableView
                            cell:(TriviaCategoryTableViewCell *)cell
                    withCategory:(NSDictionary *)currentCategory
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.categoryLabel setFont:[UIFont fontWithName:kGlobalFont size:17]];
    [cell.description setFont:[UIFont fontWithName:kGlobalFont size:13]];
    [cell.availability setFont:[UIFont fontWithName:kGlobalFont size:13]];
    [cell.answered setFont:[UIFont fontWithName:kGlobalFont size:17]];
    
    [cell.categoryLabel setText:currentCategory[@"name"]];
    [cell.description setText:@""];
    [cell.availability setText:@""];
    [cell.availability setHidden:YES];
    [cell.freshQuestions setHidden:YES];
    
    BOOL canDownload = [currentCategory[@"canDownload"] isEqualToNumber:@1];
    BOOL canUse = [currentCategory[@"canUse"] isEqualToNumber:@1];
    BOOL isDownloaded = [triviaData isCategoryDownloaded:currentCategory[@"id"]];
    BOOL hasQuestions = [triviaData unansweredQuestionFromCategory:currentCategory[@"id"]
                                                           forLevel:difficulty
                                                           existing:nil] != nil;
    
    NSUInteger availTimestamp = 0;
    NSUInteger endTimestamp = 0;
    NSUInteger serverUpdatedTimestamp = 0;
    NSUInteger packUsedTimestamp = [triviaData getUsedTimestamp:currentCategory[@"id"]];
    if (currentCategory[@"datestart"] != [NSNull null])
        availTimestamp = [currentCategory[@"datestart"] unsignedIntegerValue];
    if (currentCategory[@"dateend"] != [NSNull null])
        endTimestamp = [currentCategory[@"dateend"] unsignedIntegerValue];
    if (currentCategory[@"updated"] != [NSNull null])
        serverUpdatedTimestamp = [currentCategory[@"updated"] unsignedIntegerValue];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:availTimestamp];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimestamp];
    NSDate *serverUpdatedDate = [NSDate dateWithTimeIntervalSince1970:serverUpdatedTimestamp];
    
    // If the pack hasn't been downloaded, mark it new if its been updated in the last 3 days
    // If the pack HAS been downloaded, mark it as new if the updated date is greater than the last used date
    if (!isDownloaded && [serverUpdatedDate timeIntervalSinceNow] > -259200) {
        [cell.freshQuestions setHidden:NO];
    } else if (isDownloaded && serverUpdatedTimestamp > packUsedTimestamp) {
        [cell.freshQuestions setHidden:NO];
    }
    
    [cell.startButton setHidden:![self canLaunch:currentCategory]];
    
    // Only show availability messages if they haven't yet downloaded, or if they're restricted from use
    if (!isDownloaded || !canUse) {
        // If the category unlock is in the future
        if ((CGFloat)[startDate timeIntervalSinceNow] > 0) {
            [cell.availability setHidden:NO];
            [cell.availability setText:[NSString stringWithFormat:@"Unlocks %@", [startDate formattedDateWithStyle:NSDateFormatterMediumStyle]]];
        }
        // If the unlock is in the past
        else {
            // If there's an end date show the limited availability
            if (endTimestamp > 0) {
                [cell.availability setHidden:NO];
                [cell.availability setText:[NSString stringWithFormat:(CGFloat)[endDate timeIntervalSinceNow] > 0 ? @"Available until %@" : @"Ended %@", [endDate formattedDateWithStyle:NSDateFormatterMediumStyle]]];
            }
        }
    }
    
    // Download button state
    [cell.downloadButton setTitle:canDownload ? @"Get Pack" : @"Locked" forState:UIControlStateNormal];
    [cell.downloadButton setEnabled:canDownload];
    [cell.downloadButton setHidden:isDownloaded];
    [cell.status setHidden:hasQuestions || !isDownloaded];
    
    // If the pack completed is shown, hide the new questions banner (failsafe)
    if (!cell.status.hidden) [cell.freshQuestions setHidden:YES];
    
    // Don't show the description when the status (pack complete) is visible
    [cell.description setHidden:!cell.status.hidden];
    
    if (currentCategory[@"description"] != [NSNull null]) {
        [cell.description setText:currentCategory[@"description"]];
    }
    
    CGRect labelFrame = cell.categoryLabel.frame;
    CGRect availFrame = cell.availability.frame;
    
    // If there's an icon, let's download it
    if (currentCategory[@"image"] != nil && currentCategory[@"image"] != [NSNull null]) {
        [cell.icon setHidden:NO];
        [cell.icon setImageWithURL:[NSURL URLWithString:currentCategory[@"image"]]
                     cacheCategory:@"trivia"
                         cacheName:[NSString stringWithFormat:@"catIcon%@", currentCategory[@"id"]]];
        
        labelFrame.origin.x = 10 + cell.icon.frame.size.width + cell.icon.frame.origin.x;
        availFrame.origin.x = 10 + cell.icon.frame.size.width + cell.icon.frame.origin.x;
    }
    // If we don't have an icon we need to shuffle some things
    else {
        [cell.icon setHidden:YES];
        labelFrame.origin.x = 10;
        availFrame.origin.x = 10;
    }
    
    [cell.categoryLabel setFrame:labelFrame];
    [cell.availability setFrame:availFrame];
    
    // Question counters
    NSInteger totalQuestions = [[triviaData questionsInCategory:currentCategory[@"id"]] count];
    NSInteger answeredQuestions = [[triviaData answeredInCategory:currentCategory[@"id"]] count];
    [cell.answered setText:[NSString stringWithFormat:@"%i/%i", answeredQuestions, totalQuestions]];
    [cell.answered setHidden:!isDownloaded];
}

- (TriviaCategoryTableViewCell *)cellForCategory:(NSDictionary *)category
{
    for (NSIndexPath *indexPath in [categoryTable indexPathsForVisibleRows]) {
        if ([[[triviaData categoriesVisible] objectAtIndex:indexPath.row] isEqualToDictionary:category]) {
            //NSLog(@"Found visible matching cell!");
            return (TriviaCategoryTableViewCell *)[categoryTable cellForRowAtIndexPath:indexPath];
        }
    }
    return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TriviaStageViewController *stage = [segue destinationViewController];
    [stage setCategory:sender level:difficulty withDataManager:triviaData];
    triviaData = nil;
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // we want both our swipe left to change difficulty and the PKReveal menu pan right to open the menu to work
    //  as well as the tap recognizer, so just return a blanket YES
    // as the directions don't conflict, we're safe to do so
    return YES;
}
@end
