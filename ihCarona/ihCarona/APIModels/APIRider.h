//
//  APIRider.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIUser.h"

@interface APIRider : NSObject

@property (nonatomic)int id;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *desiredDate;
@property (nonatomic)Boolean isDriver;
@property (nonatomic)double latitude;
@property (nonatomic)double longitude;
@property (nonatomic, strong)APIUser *user;

-(id)initWithArray:(NSArray *) array;

-(void)JSONData;

+(NSMutableArray *)getRidersForCity:(NSString *)city;

@end
