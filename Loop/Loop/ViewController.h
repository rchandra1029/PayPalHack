//
//  ViewController.h
//  Loop
//
//  Created by Chandra, Rohan on 7/26/14.
//  Copyright (c) 2014 Chandra, Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, ABPersonViewControllerDelegate> {

    ABPeoplePickerNavigationController *_picker;

}

@property(strong,nonatomic) ABPeoplePickerNavigationController *picker;

@end
