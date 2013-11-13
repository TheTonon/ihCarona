//
//  APIUser.h
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIUser : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *firstName;
@property (nonatomic, strong)NSString *lastName;
@property (nonatomic, strong)NSString *link;

/**
 *  instancia um APIUser de um Usuario do Facebook
 *
 *  @param user o usuario logado no facebook
 *
 *  @return APIUser
 */
-(id)initWithFBGraphUser:(NSDictionary<FBGraphUser> *) user;

/**
 *  instancia um APIUser de um JSONArray
 *
 *  @param array JSONArray retornado do ServidorU
 *
 *  @return APIUser
 */
-(id)initWithArray:(NSArray *)array;

/**
 *  Envia um User para o Servidor
 *
 *  @param user User a ser enviado
 */
+(void)insertUser:(APIUser *)user;
@end
