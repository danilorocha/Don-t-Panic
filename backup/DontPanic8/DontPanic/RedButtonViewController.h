//
//  RedButtonViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface RedButtonViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {

    UILabel *trakingInfo;
    UIButton *botao;
    
    BOOL apertado;
    BOOL views;
    
}


@property(nonatomic, retain) IBOutlet UILabel *trakingInfo;
@property(nonatomic, retain) IBOutlet UIButton *botao;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)sendInfo:(id)sender;
- (NSMutableArray *)arrayOfPhones;
- (NSMutableArray *)arrayOfEmails;
- (BOOL)loginValidation;
- (void)sendSMS;
- (void)sendEmail;


@end
