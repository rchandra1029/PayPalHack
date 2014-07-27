//
//  SendPhotoViewController.m
//  Loop
//
//  Created by Chandra, Rohan on 7/26/14.
//  Copyright (c) 2014 Chandra, Rohan. All rights reserved.
//

#import "SendPhotoViewController.h"


@implementation SendPhotoViewController : UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    // This is where you pass the selected contact property elsewhere in your program
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    return NO;
}








@end
