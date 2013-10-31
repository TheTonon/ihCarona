//
//  APIRider.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIRider.h"
#import <RestKit/RestKit.h>

@implementation APIRider
- (id)init
{
    self = [super init];
    return self;
}

-(void)JSONData
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://ihCarona.cloudapp.net"];
    
    RKObjectMapping *dataMapping = [RKObjectMapping requestMapping];
    [dataMapping addAttributeMappingsFromArray:@[@"Id", @"UserId",@"DesiredDate",@"City",@"IsDriver",@"Latitude",@"Longitude"]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:dataMapping objectClass:[APIRider class] rootKeyPath:nil method:RKRequestMethodPOST];
    RKObjectManager *manager =[RKObjectManager managerWithBaseURL:url];
    [manager addRequestDescriptor:requestDescriptor];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[APIRider class]];
    [responseMapping addAttributeMappingsFromArray:@[@"Id", @"UserId",@"DesiredDate",@"City",@"IsDriver",@"Latitude",@"Longitude"]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    [manager addResponseDescriptor:responseDescriptor];

    
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager postObject:[APIRider class] path:@"API/Rider" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
}

@end
