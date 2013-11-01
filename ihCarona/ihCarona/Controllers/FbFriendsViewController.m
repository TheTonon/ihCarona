//
//  FbFriendsViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "FbFriendsViewController.h"
#import "APIUser.h"

@interface FbFriendsViewController ()

@end

@implementation FbFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSURL *)getImageUrl:(APIUser *)user
{
    //url default para usuario do facebook
    NSString *strUrl =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",user.id];
    
    return [[NSURL alloc]initWithString:strUrl];
}

#pragma mark - TableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    if(!newCell){
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newCell"];
        newCell.backgroundColor = [UIColor clearColor];
        
        UIColor *textColor = [UIColor blackColor];
        NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
        if (selectedIndexPath && [indexPath row] == [selectedIndexPath row]) {
            textColor = [UIColor blackColor];
        }
        newCell.textLabel.textColor = textColor;
        newCell.detailTextLabel.textColor = textColor;
        
        APIUser *user = [self.friendsList objectAtIndex:[indexPath row]];
        
        NSURL *imageUrl = [self getImageUrl:user];
        
        //baixa a imagem da web para a listagem.
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        newCell.imageView.image = image;
        newCell.textLabel.text = user.name;
    }
    return newCell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self segueForRide];
}
#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueForRide"]){
        
    }
}

-(void) segueForRide{
    [self performSegueWithIdentifier:@"segueForRide" sender:self];
}



@end
