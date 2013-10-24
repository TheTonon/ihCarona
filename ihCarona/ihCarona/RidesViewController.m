//
//  RidesViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "RidesViewController.h"

@interface RidesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ridesTable;
@property (strong, nonatomic) NSMutableDictionary *ridesDictionary;


@end

@implementation RidesViewController

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
	// Do any additional setup after loading the view.
    self.ridesDictionary = [NSMutableDictionary dictionary];
    [self.rideName setString:@"Nome Testes"];
    [self.rideLocation setString: @"Rua lalala, valinhos"];
    
    [self.ridesDictionary setObject:self.rideName forKey:self.rideLocation];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView DataSource
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ridesDictionary count];
}

#pragma mark - TableView Delegate
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
}

@end
