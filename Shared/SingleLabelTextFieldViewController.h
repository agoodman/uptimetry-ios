//
//  SingleLabelTextFieldViewController.h
//  TourWrist
//
//  Created by Aubrey Goodman on 2/1/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SingleLabelTextFieldDelegate;


@interface SingleLabelTextFieldViewController : UIViewController {

	NSString* _label;
	NSString* _caption;
	NSString* _textField;
	
	IBOutlet UILabel* label;
	IBOutlet UILabel* caption;
	IBOutlet UITextField* textField;
	
	id<SingleLabelTextFieldDelegate> delegate;
	
}

@property (retain) UILabel* label;
@property (retain) UILabel* caption;
@property (retain) UITextField* textField;
@property (assign) id<SingleLabelTextFieldDelegate> delegate;

-(id)initWithTitle:(NSString*)aTitle label:(NSString*)aLabel caption:(NSString*)aCaption text:(NSString*)aText;


@end


@protocol SingleLabelTextFieldDelegate

-(void)singleLabelTextFieldDidCancel:(SingleLabelTextFieldViewController*)controller;
-(void)singleLabelTextField:(SingleLabelTextFieldViewController*)controller didCompleteWithText:(NSString*)text;

@end
