//
//  APIUser.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIUser.h"
#import <RestKit/RestKit.h>
#import "APIResultado.h"

@implementation APIUser

- (id)initWithFBGraphUser:(NSDictionary<FBGraphUser> *)user
{
    self = [super init];
    if (self) {
        self.Id = user.id;
        self.Name = user.name;
        self.LastName = user.last_name;
        self.FirstName = user.first_name;
        self.Link = user.link;
    }
    return self;
}

+(void)insertUser:(APIUser *)user
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[APIResultado class]];
    [responseMapping addAttributeMappingsFromArray:@[@"Result"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:nil];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"Id", @"Name", @"LastName",@"FirstName",@"Link"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[APIUser class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://ihcarona.cloudapp.com/"]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [manager postObject:user path:@"User" parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         NSLog(@"SUUUUUUUUUUUUUUUUUUUUCEEEEEEEEESSSSSSSSSOOOOO");
     }
                failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@ ERRRRRRRO");
     }];
    /*
    
    NSString *jsonRequest = @"{\"Id\":\"user\",\"password\":\"letmein\"}";
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"https://mydomain.com/Method/"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];

    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"https://xxxxxxx.com/questions"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [[NSMutableData data] retain];
    }
*/
    
    
}
@end
