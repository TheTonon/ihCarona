//
//  APIUserSettings.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 11/11/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIUserSettings : NSObject

//server properties
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *departureAddress;
@property (strong, nonatomic) NSString *destinationAddress;
@property (strong, nonatomic) NSString *schedule;
@property (strong, nonatomic) NSMutableArray *instructions;

-(id)init;
@end
