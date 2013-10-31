//
//  Repository.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 29/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "Repository.h"

@implementation Repository

static Repository *instance = nil;
+(Repository *) instance
{
    @synchronized (self) {
        if (instance == nil) {
            instance = [[Repository alloc] init];
        }
    }
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.fbFriends = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) reset
{
    [self.fbFriends removeAllObjects];
    self.driver = false;
 }

@end
