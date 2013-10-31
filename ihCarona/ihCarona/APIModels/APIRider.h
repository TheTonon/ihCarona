//
//  APIRider.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRider : NSObject

@property (nonatomic)int Id;
@property (nonatomic, strong)NSString *UserId;
@property (nonatomic, strong)NSString *City;
@property (nonatomic, strong)NSString *DesiredDate;
@property (nonatomic)Boolean IsDriver;
@property (nonatomic)NSDecimal Latitude;
@property (nonatomic)NSDecimal Longitude;

-(id)init;
@end
