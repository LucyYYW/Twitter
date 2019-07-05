//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "WebKit/WebKit.h"
#import "OtherProfileViewController.h"
#import "InfiniteScrollActivityView.h"
#import "replyViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate, TweetCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property NSString* threshold_id;


@end

@implementation TimelineViewController


InfiniteScrollActivityView* loadingMoreView;
bool isMoreDataLoading = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. (done in storyboard)View Controller has a tableView as a subview
    //2. (done in storyboard)Define a custom table view cell and set its reuse identifier
    //3. View controller becomes its dataSource and delegate in viewDidLoad

    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //4. Make an API request (usually have it done in an separate function to make it cleaner)
    [self getTimeline];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

    


//4. Make an API request
- (void)getTimeline {
    
    //5. API manager calls the completion handler passing back data
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            //6. View controller stores that data passed into the completion handler
            self.tweets = [tweets mutableCopy];

            //7. Reload the tableView now that there is new data
            [self.tableView reloadData];
            
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//8. Tabel view asks its dataSource for cellForRowAt
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 10. cellForRow returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    if (!self.threshold_id) {
        self.threshold_id = tweet.idStr;
    } else if (([self.threshold_id length] > [self.threshold_id length]) | (([self.threshold_id length] > [self.threshold_id length]) & ([self.threshold_id intValue] > [tweet.idStr intValue]))) {
        self.threshold_id = tweet.idStr;
    }
    
    
    
    cell.tweet = tweet;
    
    NSURL *url = [NSURL URLWithString:tweet.user.profileImageUrl];
    [cell.profileImageView setImageWithURL:url];
    
    
    if (tweet.containsMedia == YES) {
        NSURL *mediaURL = [NSURL URLWithString:tweet.mediaURL];
        [cell.mediaImageView setImageWithURL:mediaURL];
    }
    
    
    cell.userNameLabel.text = tweet.user.name;
    cell.screenNameLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    cell.dateLabel.text = (NSAttributedString *)tweet.timeAgoString;
    
    
    cell.tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    cell.tweetTextLabel.delegate = self;
    
    
    cell.tweetTextLabel.text = tweet.text;
    
    
    cell.delegate = self;

    
    cell.replyLabel.text = [NSString stringWithFormat:@"%i", tweet.replyCount];
    cell.retweetLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    cell.likeLabel.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    
    if (tweet.favorited == NO) {
        [cell.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    
    if (tweet.retweeted == NO) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    } else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

//8. Table view asks its dataSource for numberOfRows
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //9. numberOfRows returns the number of items returned from the API
    return self.tweets.count;
}

- (void) didTweet: (Tweet *) tweet {
    [self.tweets insertObject: tweet atIndex:0];
    [self.tableView reloadData];
}


- (IBAction)onTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:nil];
    
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)replyTweetCell:(TweetCell *) tweetCell didTap:(Tweet *)tweet{
    [self performSegueWithIdentifier:@"replyFromHome" sender:tweet];
}

-(void)loadMoreData{
    [[APIManager shared] loadMoreHomeLineBefore:self.threshold_id completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline more");
            isMoreDataLoading = false;
            
            [loadingMoreView stopAnimating];
            
            //6. View controller stores that data passed into the completion handler
            [self.tweets addObjectsFromArray:tweets];
            
            
            //7. Reload the tableView now that there is new data
            [self.tableView reloadData];
            
            
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline more: %@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"compose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqual: @"details"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.tweet = tweet;
        detailsController.tweetCell = (TweetCell *) tappedCell;
        detailsController.tableView = self.tableView;
        
    } else if ([segue.identifier isEqual: @"profileSegue"]) {
        OtherProfileViewController *profileController = [segue destinationViewController];
        profileController.user = sender;
        
    } else if ([segue.identifier isEqual: @"replyFromHome"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        replyViewController *replyController = (replyViewController*)navigationController.topViewController;
        replyController.tweet = sender;
        //replyController.tableView = self.tableView;
    }
    
}



@end
