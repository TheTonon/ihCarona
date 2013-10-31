//
//  APIUser.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIUser : NSObject

@property (nonatomic, strong)NSString *Id;
@property (nonatomic, strong)NSString *Name;
@property (nonatomic, strong)NSString *FirstName;
@property (nonatomic, strong)NSString *LastName;
@property (nonatomic, strong)NSString *Link;

-(id)initWithFBGraphUser:(NSDictionary<FBGraphUser> *) user;

+(void)insertUser:(APIUser *)user;
@end
