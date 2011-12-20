//
//  RedButtonViewController.m
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import "RedButtonViewController.h"
#import "ContactViewController.h"

@implementation RedButtonViewController

@synthesize trakingInfo;
@synthesize botao;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    apertado = NO;
    trakingInfo.text = @"Tracking disabled";
    
    if (views == YES) {
        [self sendSMS];
    }

    [super viewDidLoad];
    
}

- (NSMutableArray *)arrayOfPhones{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSUInteger count = [objects count];
    NSUInteger i;
    
    NSMutableArray *phoneList = [[NSMutableArray alloc] init];
    
    for (i =0; i<count ; i++) {
        [phoneList addObject:[[objects objectAtIndex:i] valueForKey:@"phone"]];
    }
    
    for (i = 0; i<count; i++) {
        NSLog(@"%@", [phoneList objectAtIndex:i]);
    }
        
    return phoneList;
}

- (NSMutableArray *)arrayOfEmails{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSUInteger count = [objects count];
    NSUInteger i;
    
    NSMutableArray *emailList = [[NSMutableArray alloc] init];
    
    for (i =0; i<count ; i++) {
        [emailList addObject:[[objects objectAtIndex:i] valueForKey:@"email"]];
    }
    
    for (i = 0; i<count; i++) {
        NSLog(@"%@", [emailList objectAtIndex:i]);
    }
    
    return emailList;
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)showConfirmAlert
{
	UIAlertView *alert = [[UIAlertView alloc] init];
    if (apertado == NO) {
        [alert setTitle:@"DON'T PANIC!"];
        [alert setMessage:@"Do you want to begin the tracking?"];
    }
    if (apertado == YES) {
        [alert setTitle:@"Already safe?"];
        [alert setMessage:@"Do you want to stop the tracking?"];
    }
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        switch (apertado) {
            case NO:
                apertado = YES;
                
                [self sendSMS];
                [self sendEmail];
                trakingInfo.text = @"Tracking in progress";
                break;
                
            case YES:
                apertado = NO;
                trakingInfo.text = @"Tracking disabled";
                break;
                
            default:
                break;
        }
                
		NSLog(@"Apertou Sim");
	}
	else if (buttonIndex == 1)
	{
		NSLog(@"apertou NO");
	}
}



- (IBAction)sendInfo:(id)sender{
    
    if (![self loginValidation]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are not logged in!" message:@"Please log in!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    if ([self loginValidation]) {
        NSArray *contactList = [self arrayOfPhones];
        if([contactList count] != 0){
            [self showConfirmAlert];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Contact List is empty!" message:@"Add some friends!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        
    }
}

- (BOOL)loginValidation{
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loggeduser.plist"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (fileExists) {
        return YES;
    }    
    else
        return NO;
}

- (void)sendEmail{
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Emergency!"];
        [mailController setToRecipients:[self arrayOfEmails]];
        [mailController setMessageBody:@"Hello, you are in my emergency contact list, something happened, please enter the code 1234 in www.whatever.com to track me down.\n\n This messenger was sent automatically by DontPanic iPhone app." isHTML:NO];
        
        [self presentModalViewController:mailController animated:YES];

    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to send E-Mail" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }

    
    
    
}

- (void)sendSMS{
    NSLog(@"entrou no sms");
    MFMessageComposeViewController *smsController =[[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]){
        smsController.body = @"Hello, you are in my emergency contact list, something happened, please enter the code 1234 in www.whatever.com to track me down.\n\n This messenger was sent automatically by DontPanic iPhone app.";
        smsController.recipients = [self arrayOfPhones];
        smsController.messageComposeDelegate = self;
        NSLog(@"chegou ate aqui");
        [self presentModalViewController:smsController animated:YES];
        NSLog(@"nao saiu");
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to send SMS" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
            
        case MessageComposeResultFailed:
            break;
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"mail dispensado");
    [self sendSMS];
}


@end
