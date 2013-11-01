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
