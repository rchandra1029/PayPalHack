//
//  ContactsNavigationController.m
//  Loop
//
//  Created by Chandra, Rohan on 7/26/14.
//  Copyright (c) 2014 Chandra, Rohan. All rights reserved.
//

#import "ContactsNavigationController.h"

@implementation ContactsNavigationController : ABPeoplePickerNavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIView *custom = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,0.0f,0.0f)];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:custom];
    //UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
}

@end
