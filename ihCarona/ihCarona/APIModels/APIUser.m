//
//  APIUser.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIUser.h"

@implementation APIUser

- (id)initWithFBGraphUser:(NSDictionary<FBGraphUser> *)user
{
    self = [super init];
    if (self) {
        self.id = user.id;
        self.name = user.name;
        self.lastName = user.last_name;
        self.firstName = user.first_name;
        self.link = user.link;
    }
    return self;
}


@end
