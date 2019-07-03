//
//  User.m
//  twitter
//
//  Created by lucyyyw on 6/29/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url_https"];
        self.tweetsCount = [dictionary[@"statuses_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        
        
    }
    return self;
}



@end
