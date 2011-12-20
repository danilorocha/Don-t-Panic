//
//  UserViewController.m
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import "UserViewController.h"

@implementation UserViewController

@synthesize passText;
@synthesize userText;
@synthesize userName;



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


- (void)viewDidLoad
{
    NSString *path = [self saveFilePath];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (fileExists) {
        NSArray *values = [[NSArray alloc] initWithContentsOfFile:path];
            userText.text = [values objectAtIndex:0];
            passText.text = [values objectAtIndex:1];
        
        //NSLog(@"%@, %@", [values objectAtIndex:0], [values objectAtIndex:1]);
    }
    
    [super viewDidLoad];
    
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

-(IBAction)removerTeclado:(id)sender{
    [userText resignFirstResponder];
    [passText resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    [textField resignFirstResponder];
    
    return TRUE;
}
 

- (IBAction)login{
    
    NSArray *values = [[NSArray alloc] initWithObjects:userText.text, passText.text, nil];
    
    if ((userText.text.length != 0) && (passText.text.length != 0)) {
        [self sendUserWithName:userText.text andPassword:passText.text];
        
         NSLog(@"pegou %@", userName);
        
        [values writeToFile:[self saveFilePath] atomically:YES];
        [userText resignFirstResponder];
        [passText resignFirstResponder];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot something?" message:@"You must fill all fields!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    //TODO: Fazer a validacao pelo servidor
    
}

- (IBAction)logout{
    NSString *path = [self saveFilePath];
    
    NSError *error;
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    userText.text = @"";
    passText.text = @"";
    
    
}



- (NSString *)saveFilePath{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"loggeduser.plist"];
}

- (void)sendUserWithName:(NSString *)user andPassword:(NSString *)password {  
       
    NSString *url = [NSString stringWithFormat:@"http://localhost:8888/dontpanic/userController.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"user=%@&password=%@", user, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[NSError alloc] init];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [self getUserData];

    

        
}

-(void)getUserData{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/dontpanic/teste.php"];
    userName = [NSString stringWithContentsOfURL:url
                                             encoding:NSUTF8StringEncoding error:nil];
}




@end
