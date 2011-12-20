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



-(IBAction)sendInfo:(id)sender{
   
    [self showConfirmAlert];
    /*
    if (apertado == YES){
        apertado = NO;
        trakingInfo.text = @"Tracking disabled";
    }        
    else{
        [self showConfirmAlert];
    }  */  
}





@end
