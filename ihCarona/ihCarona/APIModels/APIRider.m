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
- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self){
        self.id = [[array valueForKey:@"Id"]integerValue];
        self.userId = [array valueForKey:@"UserId"];
        self.city = [array valueForKey:@"City"];
        self.isDriver = [[array valueForKey:@"IsDriver"]boolValue];
        self.latitude = [[array valueForKey:@"Latitude"]doubleValue];
        self.longitude = [[array valueForKey:@"Longitude"] doubleValue];
        self.desiredDate = [array valueForKey:@"DesiredDate"];
        
    }
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



+(NSMutableArray *) getRidersForCity:(NSString *)city;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ihcarona.cloudapp.net/rider?city=%@",city]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Convert to JSON object:
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[ret dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for( NSArray *array in jsonObject)
    {
        APIRider * rider = [[APIRider alloc]initWithArray:array];
        
        [array setValue:rider forKey:[NSString stringWithFormat:@"%i",rider.id]];
        
        NSLog(@"%@",[array valueForKey:@"User"]);
    }
    
    return array;
}




@end
