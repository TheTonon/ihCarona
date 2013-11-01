//
//  LandPageViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "LandPageViewController.h"

@interface LandPageViewController ()

@end

@implementation LandPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)motoristaPressed:(id)sender
{
    [Repository instance].driver = @"true";
    [self performSegueWithIdentifier:@"segueToHiking" sender:self];
}

-(IBAction)caronaPressed:(id)sender
{
    [Repository instance].driver =@"false";
    [self performSegueWithIdentifier:@"segueToHiking" sender:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
