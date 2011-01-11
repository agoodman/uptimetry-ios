//
//  DoubleLabelTextFieldViewController.h
//  TourWrist
//
//  Created by Aubrey Goodman on 2/1/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DoubleLabelTextFieldDelegate;


@interface DoubleLabelTextFieldViewController : UIViewController {

	NSString* initLabel1;
	NSString* initLabel2;
	NSString* initCaption1;
	NSString* initCaption2;
	NSString* initText1;
	NSString* initText2;
	bool secure1;
	bool secure2;
	
	IBOutlet UILabel* label1;
	IBOutlet UILabel* label2;
	IBOutlet UILabel* caption1;
	IBOutlet UILabel* caption2;
	IBOutlet UITextField* text1;
	IBOutlet UITextField* text2;
	
	id<DoubleLabelTextFieldDelegate> delegate;
	
}

@property (retain) UITextField* text1;
@property (retain) UITextField* text2;
@property bool secure1;
@property bool secure2;
@property (assign) id<DoubleLabelTextFieldDelegate> delegate;

-(id)initWithTitle:(NSString*)aTitle label1:(NSString*)aLabel1 label2:(NSString*)aLabel2 caption1:(NSString*)aCaption1 caption2:(NSString*)aCaption2 text1:(NSString*)aText1 text2:(NSString*)aText2;


@end


@protocol DoubleLabelTextFieldDelegate
-(void)doubleLabelTextFieldDidCancel:(DoubleLabelTextFieldViewController*)src;
-(void)doubleLabelTextField:(DoubleLabelTextFieldViewController*)src didCompleteWithText1:(NSString*)text1 text2:(NSString*)text2;
@end
