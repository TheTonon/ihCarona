//
//  APIRider.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRider : NSObject

@property (nonatomic)int id;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *desiredDate;
@property (nonatomic)NSString *isDriver;
@property (nonatomic)float latitude;
@property (nonatomic)float longitude;

-(id)init;

-(void)insertRider:(APIRider *)rider;

@end
