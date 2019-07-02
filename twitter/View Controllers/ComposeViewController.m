//
//  ComposeViewController.m
//  twitter
//
//  Created by lucyyyw on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onTweet:(id)sender {
    NSLog(@"tweet clicked");
    //[[APIManager shared] postStatusWithText: self.postTextView.text];
    [[APIManager shared] postStatusWithText: self.postTextView.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully posted a new tweet");
            
            //[self dismissViewControllerAnimated:true completion: nil];
            
            
        } else {
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
        }
        
    }];
    [self dismissViewControllerAnimated:true completion: nil];
}
        
        
    
    
    
    
    


- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion: nil];
    
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
