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
 *  Dicionario de amigos do facebook
 */
@property (nonatomic, strong) NSMutableDictionary *fbFriends;

/**
 *  define se o usuário é motorista ou nao
 */
@property (nonatomic,strong ,getter = isDriver) NSString *driver;


/**
 *  Usuario atual logado
 */
@property (nonatomic, strong)NSDictionary<FBGraphUser> *user;


/**
 *  caronistas selecionados pelo motorista
 */
@property (nonatomic, strong)NSMutableArray *selectedRides;

/**
 *  aloca um unico repositorio para toda a aplicacao
 *
 *  @return instancia singleton de Repository
 */
+ (Repository *) instance;

/**
 *  limpa todas as propriedades do Repository
 */
- (void) reset;

@end
