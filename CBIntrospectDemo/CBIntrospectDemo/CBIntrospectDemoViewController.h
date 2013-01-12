//
//  CBIntrospectDemoViewController.h
//  CBIntrospectDemo
//
//  Created by Domestic Cat on 29/04/11.
//  Copyright 2011 Domestic Cat Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBIntrospectDemoViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (IBAction)buttonTapped:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
