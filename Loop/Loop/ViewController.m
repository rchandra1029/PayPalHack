//
//  ViewController.m
//  Loop
//
//  Created by Chandra, Rohan on 7/26/14.
//  Copyright (c) 2014 Chandra, Rohan. All rights reserved.
//

#import "ViewController.h"
#import "ContactsNavigationController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSMutableArray* recipients;

@end

@implementation ViewController: UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];

        [myAlertView show];

    }

    self.recipients = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    self.takePhotoButton.hidden = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)sendPhoto:(id)sender {
        ContactsNavigationController *picker = [[ContactsNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    //set up the ABPeoplePicker controls here to get rid of he forced cacnel button on the right hand side but you also then have to
    // the other views it pcuhes on to ensure they have to correct buttons shown at the correct time.

    if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]]){
        navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(sendMessage:)];

        navigationController.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    }
}



//+ (NSString *)uuid
//{
//    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
//    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
//    CFRelease(uuidRef);
//    return [(__bridge NSString *)uuidStringRef];
//}


- (IBAction)sendMessage:(id)sender {



    if(![MFMessageComposeViewController canSendText]) {

        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

        [warningAlert show];

        return;

    }


    [self performSelector:@selector(presentMessageViewController) withObject:nil afterDelay:0.0];



}




- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result

{

    switch (result) {

        case MessageComposeResultCancelled:

            break;



        case MessageComposeResultFailed:

        {

            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

            [warningAlert show];

            break;

        }

            
            
        case MessageComposeResultSent:
            
            break;
            
            
            
        default:
            
            break;
            
    }
    
    NSString *sms = controller.body;
    NSLog(@"sms: %@", sms);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)presentMessageViewController
{





    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];

    NSString *message = [NSString stringWithFormat:@"I would like to get your feedback on this item from eBay!"];



    UIImage *img = self.imageView.image;
    NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);

    [messageController addAttachmentData:dataObj typeIdentifier:@"image/jpeg" filename:@"Photo.jpeg"];


    messageController.messageComposeDelegate = self;
    messageController.delegate = self;

    NSLog(@"recipients: %@", self.recipients);

    [messageController setRecipients:self.recipients];
    [messageController setBody:message];



    UIViewController* presentingVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if (presentingVC.presentedViewController) {
        [presentingVC.presentedViewController presentViewController:messageController animated:YES completion:nil];
    } else {
        [presentingVC presentViewController:messageController animated:YES completion:nil];
    }
//    [self presentViewController:messageController animated:YES completion:nil];
}



-(IBAction)cancelAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {



    UIView *view = peoplePicker.topViewController.view;
    UITableView *tableView = nil;
    for(UIView *uv in view.subviews)
    {
        if([uv isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView*)uv;
            break;
        }
    }
    if(tableView != nil)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
        if(cell.accessoryType == UITableViewCellAccessoryNone){

            cell.accessoryType = UITableViewCellAccessoryCheckmark;


            // Select phone number
            NSMutableString* name = [[NSMutableString alloc] initWithString: (__bridge NSString *)ABRecordCopyValue(person,
                                                                                                                    kABPersonFirstNameProperty)];
            [name appendString:@" "];
            [name appendString:(__bridge NSString *)ABRecordCopyValue(person,
                                                                      kABPersonLastNameProperty)];

            NSLog(@"name: %@", name);

            ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
            NSString* mobile=@"";
            NSString* mobileLabel;
            for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
                mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel] || [mobileLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel])
                {
                    mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                }
            }
            [self.recipients addObject:mobile];

            
            // Do whatever you want with the phone numbers
            NSLog(@"Mobile number = %@", mobile);
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
            NSString* mobile=@"";
            NSString* mobileLabel;
            for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
                mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel] || [mobileLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel])
                {
                    mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                }
            }

            [self.recipients removeObject:mobile];
        }
        [cell setSelected:NO animated:YES];
    }


    //    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}



//- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]]) {
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(peoplePickerNavigationControllerDidCancel:)];
//        navigationController.topViewController.navigationItem.rightBarButtonItem = bbi;
//    }
//}


//- (BOOL)peoplePickerNavigationController:
//(ABPeoplePickerNavigationController *)peoplePicker
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person
//                                property:(ABPropertyID)property
//                              identifier:(ABMultiValueIdentifier)identifier{
//    return NO;
//}



- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
