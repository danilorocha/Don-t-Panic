//
//  RedButtonViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>

@interface RedButtonViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate> {

    UILabel *trakingInfo;
    UIButton *botao;
    
    BOOL apertado;
    BOOL views;
    NSString * trackCode;
    
    CLLocationManager *locationManager;
    CLLocation *startingPoint;
    
}


@property(nonatomic, retain) IBOutlet UILabel *trakingInfo;
@property(nonatomic, retain) IBOutlet UIButton *botao;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *trackCode;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;


- (IBAction)sendInfo:(id)sender;
- (NSMutableArray *)arrayOfPhones;
- (NSMutableArray *)arrayOfEmails;
- (BOOL)loginValidation;
- (void)sendSMS;
- (void)sendEmailWithTrackCode:(NSString *)code;
- (void)setTrackInfo;
- (void)changeStatus;
- (NSString *)getUserName;
- (void)getTrackCode;
- (void)queryTrackCode;
- (void)startLocate;
- (void)stopLocate;


@end
