//
//  APIUserSettings.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 11/11/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIUserSettings.h"

@implementation APIUserSettings

- (id)init
{
    self = [super init];
    if (self) {
        //init instructions
        self.instructions = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
