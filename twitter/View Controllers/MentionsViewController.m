//
//  MentionsViewController.m
//  twitter
//
//  Created by lucyyyw on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "OtherProfileViewController.h"

@interface MentionsViewController () <UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mentionTableView;
@property (strong, nonatomic) NSMutableArray *mentions;

@property (nonatomic, strong) UIRefreshControl *refreshControl;



@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.mentionTableView.dataSource = self;
    self.mentionTableView.delegate = self;
    
    //4. Make an API request (usually have it done in an separate function to make it cleaner)
    [self getMentionTimeline];
    
    self.mentionTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMentionTimeline) forControlEvents:UIControlEventValueChanged];
    [self.mentionTableView insertSubview:self.refreshControl atIndex:0];
                              
}


- (void)getMentionTimeline {
    
    //5. API manager calls the completion handler passing back data
    [[APIManager shared] getMentionsTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded mention timeline");
            
            //6. View controller stores that data passed into the completion handler
            self.mentions = [tweets mutableCopy];
            //7. Reload the tableView now that there is new data
            [self.mentionTableView reloadData];
            
            
        } else {
            NSLog(@"😫😫😫 Error getting mention timeline: %@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 10. cellForRow returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MentionTweetCell"];
    
    Tweet *tweet = self.mentions[indexPath.row];
    
    
    
    
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
    return self.mentions.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:nil];
    
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
    [self performSegueWithIdentifier:@"MentionProfile" sender:user];
}


                              
                              
                              
                              
                              
                              
                              

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual: @"MentionProfile"]) {
        OtherProfileViewController *profileController = [segue destinationViewController];
        profileController.user = sender;
    }
}


@end
