//
//  SendPhotoViewController.h
//  Loop
//
//  Created by Chandra, Rohan on 7/26/14.
//  Copyright (c) 2014 Chandra, Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SendPhotoViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>
{
    ABPeoplePickerNavigationController *peoplePicker;
}

- (void) displayContactInfo: (ABRecordRef)person;

@end
