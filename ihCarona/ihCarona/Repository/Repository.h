//
//  Repository.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 29/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

/**
 *  Dictionary of facebook friends
 */
@property (nonatomic, strong) NSMutableDictionary *fbFriends;

/**
 *  Alocate unique repository for all application
 *
 *  @return Single isntace of Repository
 */
+ (Repository *) instance;

/**
 *  Clear all Repository
 */
- (void) reset;

@end
