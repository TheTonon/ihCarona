//
//  APIRider.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 31/10/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIRider.h"
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@implementation APIRider
- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self){
        self.id = [[array valueForKey:@"Id"]integerValue];
        self.userId = [array valueForKey:@"UserId"];
        self.city = [array valueForKey:@"City"];
        self.isDriver = [array valueForKey:@"IsDriver"];
        self.latitude = [[array valueForKey:@"Latitude"]floatValue];
        self.longitude = [[array valueForKey:@"Longitude"]floatValue];
        self.desiredDate = [array valueForKey:@"DesiredDate"];
        self.user = [[APIUser alloc] initWithArray:[array valueForKey:@"User"]];
        self.txtAdress = [array valueForKey:@"ActualLocation"];
    }
    return self;
}

+(void)insertRider:(APIRider *)rider
{
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"Id\":\"%d\",\"UserID\":\"%@\",\"City\":\"%@\",\"Date\":\"%@\",\"isDriver\":\"%@\", \"Latitude\":\"%f\",\"Longitude\":\"%f\",\"ActualLocation\":\"%@\"}",
                             rider.id,rider.userId, rider.city,rider.desiredDate,rider.isDriver,rider.latitude,rider.longitude,rider.txtAdress];
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

+(NSMutableArray *) getRidersForCity:(NSString *)city;
{
    NSString * unencodedString = [NSString stringWithFormat:@"http://ihcarona.cloudapp.net/rider?city=%@",city];
    NSString * encodedString =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL,
                                                                          (CFStringRef)unencodedString,
                                                                          NULL,
                                                                          (CFStringRef)@" ",
                                                                          kCFStringEncodingUTF8 ));
    
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Convert to JSON object:
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[ret dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    for( NSArray *array in jsonObject)
    {
        APIRider *rider = [[APIRider alloc]initWithArray:array];
        
        [mArray addObject:rider];
    }
    
    return mArray;
}

@end
