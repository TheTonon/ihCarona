//
//  APIUser.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIUser.h"
#import <RestKit/RestKit.h>

@implementation APIUser

- (id)initWithFBGraphUser:(NSDictionary<FBGraphUser> *)user
{
    self = [super init];
    if (self) {
        self.Id = user.id;
        self.Name = user.name;
        self.LastName = user.last_name;
        self.FirstName = user.first_name;
        self.Link = user.link;
    }
    return self;
}

+(void)insertUser:(APIUser *)user
{
    RKObjectMapping * dataMapping
}
@end
