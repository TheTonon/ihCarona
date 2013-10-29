//
//  Comms.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 25/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "Comms.h"

@implementation Comms

+ (void) login:(id<FbUserDelegate>)delegate
{
	// Basic User information and your friends are part of the standard permissions
	// so there is no reason to ask for additional permissions
	[PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
		// Was login successful ?
		if (!user) {
			if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }
            
			// Callback - login failed
			if ([delegate respondsToSelector:@selector(userDidLogin:)]) {
				[delegate userDidLogin:NO];
			}
		} else {
			if (user.isNew) {
				NSLog(@"User signed up and logged in through Facebook!");
			} else {
				NSLog(@"User logged in through Facebook!");
			}
            
			// Callback - login successful
			[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                    // Store the Facebook Id
                    [[PFUser currentUser] setObject:me.id forKey:@"fbId"];
                    [[PFUser currentUser] saveInBackground];
                }
                
                // Callback - login successful
                if ([delegate respondsToSelector:@selector(userDidLogin:)]) {
                    [delegate userDidLogin:YES];
                }
            }];
		}
	}];
}
@end