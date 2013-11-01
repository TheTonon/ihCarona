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

-(void)insertRider:(APIRider *)rider
{
    
    /*
     @property (nonatomic)int id;
     @property (nonatomic, strong)NSString *userId;
     @property (nonatomic, strong)NSString *city;
     @property (nonatomic, strong)NSString *desiredDate;
     @property (nonatomic)Boolean isDriver;
     @property (nonatomic)double latitude;
     @property (nonatomic)double longitude;

     */
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"Id\":\"%d\",\"UserID\":\"%@\",\"City\":\"%@\",\"desiredDate\":\"%@\",\"isDriver\":\"%@\", \"Latitude\":\"%f\",\"Longitude\":\"%f\"}",
                             rider.id,rider.userId, rider.city,rider.desiredDate,rider.isDriver,rider.latitude,rider.longitude];
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://ihcarona.cloudapp.net/Rider"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [connection start];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection) {
        NSLog(@"%@",data);
        NSLog(@"##########Sucesso!");
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

@end
