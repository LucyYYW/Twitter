//
//  ComposeViewController.m
//  twitter
//
//  Created by lucyyyw on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "TimelineViewController.h"
#import "UITextView+Placeholder.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postTextView.delegate = self;
    // Do any additional setup after loading the view.
    self.postTextView.placeholder = @"What's happening?";
    self.postTextView.placeholderColor = [UIColor lightGrayColor]; // optional
}

- (IBAction)onTweet:(id)sender {
    NSLog(@"tweet clicked");
    [[APIManager shared] postStatusWithText: self.postTextView.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"😎😎😎 Successfully posted a new tweet");
            [self.delegate didTweet:tweet];
            
        } else {
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
        }
        
    }];
    [self dismissViewControllerAnimated:true completion: nil];
}


- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion: nil];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // TODO: Check the proposed new text character count
    // Allow or disallow the new text
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.postTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    // TODO: Update Character Count Label
    
    // The new text should be allowed? True/False
    return newText.length < characterLimit;
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
