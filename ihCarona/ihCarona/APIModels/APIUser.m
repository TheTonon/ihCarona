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
#import <CoreLocation/CoreLocation.h>

@implementation APIUser

- (id)initWithFBGraphUser:(NSDictionary<FBGraphUser> *)user
{
    self = [super init];
    if (self) {
        self.id = user.id;
        self.name = user.name;
        self.lastName = user.last_name;
        self.firstName = user.first_name;
        self.link = user.link;
    }
    return self;
}
-(id)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self){
        self.id = [array valueForKey:@"Id"];
        self.name = [array valueForKey:@"Name"];
        self.firstName = [array valueForKey:@"FirstName"];
        self.lastName = [array valueForKey:@"LastName"];
        self.link = [array valueForKey:@"Link"];
    }
    
    return self;
}


+(void)insertUser:(APIUser *)user
{
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"Id\":\"%@\",\"Name\":\"%@\",\"FirstName\":\"%@\",\"LastName\":\"%@\",\"Link\":\"%@\"}",
                             user.id,user.name, user.firstName,user.lastName,user.link];
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://ihcarona.cloudapp.net/User"];
    
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
