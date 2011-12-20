//
//  UserViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface UserViewController : UIViewController{
    UITextField *userText;
    UITextField *passText;

} 

- (IBAction)removerTeclado:(id)sender;
- (IBAction)login;
- (IBAction)logout;
- (NSString *)saveFilePath;

@property(nonatomic, retain) IBOutlet UITextField *userText;
@property(nonatomic, retain) IBOutlet UITextField *passText;

@end
