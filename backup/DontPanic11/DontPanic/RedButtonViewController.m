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
@synthesize trackCode;
@synthesize locationManager;
@synthesize startingPoint;

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
                [self setTrackInfo];
                [self queryTrackCode];
                [self startLocate];
               // [self sendSMS];
                [self sendEmailWithTrackCode:trackCode];
                trakingInfo.text = @"Tracking in progress";
                break;
                
            case YES:
                apertado = NO;
                [self stopLocate];
                [self changeStatus];
                trackCode = nil;
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

- (void)sendEmailWithTrackCode:(NSString *)code{
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        NSString *message = [NSString stringWithFormat:@"Hello, you are in my emergency contact list, something happened, please enter the code %@ in www.whatever.com to track me down.\n\n This messenger was sent automatically by DontPanic iPhone app.", code];
        [mailController setSubject:@"Emergency!"];
        [mailController setToRecipients:[self arrayOfEmails]];
        [mailController setMessageBody:message isHTML:NO];
        
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
        [self presentModalViewController:smsController animated:YES];

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
}

- (NSString *)getUserName{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loggeduser.plist"];
    
    NSArray *values = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSLog(@"%@", [values objectAtIndex:0]);
    
    NSString *username = [values objectAtIndex:0];
    
    return username;
}

- (void)setTrackInfo{
    
    NSString *username = [self getUserName];
    
    NSString *url = [NSString stringWithFormat:@"http://localhost:8888/dontpanic/trackController.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"username=%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(response == nil){
        NSLog(@"entrou no else");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to contact server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    
    
}

- (void)changeStatus{
    
    NSString *username = [self getUserName];

    NSString *url = [NSString stringWithFormat:@"http://localhost:8888/dontpanic/setStatus.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"username=%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(response == nil){
        NSLog(@"entrou no else");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to contact server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
}

- (void)queryTrackCode{
    NSString *username = [self getUserName];
    
    NSString *url = [NSString stringWithFormat:@"http://localhost:8888/dontpanic/queryStatusOn.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"username=%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(response == nil){
        NSLog(@"entrou no else");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to contact server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    else{
        [self getTrackCode];
        NSArray *substring = [NSArray arrayWithArray:[trackCode componentsSeparatedByString:@" "]];
        trackCode = [substring objectAtIndex:0];
    }  
    
}

- (void)getTrackCode{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/dontpanic/trackcode.php"];
    trackCode = [NSString stringWithContentsOfURL:url
                                        encoding:NSUTF8StringEncoding error:nil];
    
}

-(void)startLocate{
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    [locationManager startUpdatingLocation];
    
}

-(void)stopLocate{
    [locationManager stopUpdatingLocation];
    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if(startingPoint == nil)
        self.startingPoint = newLocation;
    
    //NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0", newLocation.coordinate.latitude];
    
    
    //NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0", newLocation.coordinate.longitude];
    
    
    
    //CLLocationDistance distance = [newLocation distanceFromLocation:startingPoint];
    
    //NSString *distanceTraveledString = [[NSString alloc] initWithFormat:@"%gm", distance];
    
    
    NSString *url = [NSString stringWithFormat:@"http://localhost:8888/dontpanic/trackcoordinates.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"trackcode=%@&latitude=%g&longitude=%g",trackCode, newLocation.coordinate.latitude, newLocation.coordinate.longitude] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location"
                                                    message:errorType delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
    
    
}


@end
