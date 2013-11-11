//
//  APIUserSettings.m
//  ihCarona
//
//  Created by Guilherme Titschkoski on 11/11/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "APIUserSettings.h"

@implementation APIUserSettings

- (id)init
{
    self = [super init];
    if (self) {
        //init instructions
        self.instructions = [[NSMutableArray alloc] init];
    }
    return self;
}

+(void)insertSettings:(APIUserSettings *)settings
{
    NSString *instructionsJson = @"[";
    for(NSString *instruction in settings.instructions)
    {
        NSString *instructionJson =[NSString stringWithFormat:@"{\"UserId\":\"%@\",\"Instruction\":\"%@\"}",
                                  settings.userId,instruction];
        
        //se for a ultima instrucao nao coloca virgula
        if([settings.instructions indexOfObject:instruction] == settings.instructions.count -1){
            instructionsJson = [NSString stringWithFormat:@"%@ %@",instructionsJson, instructionJson];
        }else{
            instructionsJson = [NSString stringWithFormat:@"%@ %@ %@",instructionsJson, instructionJson, @","];
        }
        
        instructionsJson = [NSString stringWithFormat:@"%@ %@",instructionsJson, @"]"];
    }
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"UserId\":\"%@\",\"DepartureAddress\":\"%@\",\"DestinationAddress\":\"%@\",\"Schedule\":\"%@\",\"Instructions\":\"%@\"}",settings.userId,settings.departureAddress, settings.destinationAddress,settings.schedule,instructionsJson];
    NSLog(@"Request: %@", jsonRequest);
    NSURL *url = [NSURL URLWithString:@"http://ihcarona.cloudapp.net/UserSettings"];
    
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
