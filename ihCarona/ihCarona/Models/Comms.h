//
//  Comms.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 25/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FbUserDelegate <NSObject>
@optional
- (void) userDidLogin:(BOOL)loggedIn;
@end

@interface Comms : NSObject
+ (void) login:(id<FbUserDelegate>)delegate;
@end
