//
//  FriendFinderViewController.m
//  ihCarona
//
//  Created by Vinicius Tonon on 11/12/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "FriendFinderViewController.h"
#import "FbFriendsViewController.h"
#import "APIRider.h"
#import "APIUserSettings.h"

@interface FriendFinderViewController ()

@end

@implementation FriendFinderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *route = [self.userRoute componentsJoinedByString:@","];
    NSLog(route);
	// Do any additional setup after loading the view.
}

-(void)getFriendsForRoute
{
    FbFriendsViewController *friendsController;
    
    //friendsController.friendsList = [APIUserSettings getRouteFrom: toDestination:];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
