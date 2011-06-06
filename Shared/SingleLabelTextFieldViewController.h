//
//  SingleLabelTextFieldViewController.h
//  TourWrist
//
//  Created by Aubrey Goodman on 2/1/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SingleLabelTextFieldCancelBlock)(void);
typedef void(^SingleLabelTextFieldDoneBlock)(NSString*);

@interface SingleLabelTextFieldViewController : UIViewController {

	NSString* _label;
	NSString* _caption;
	NSString* _textField;
	
	IBOutlet UILabel* label;
	IBOutlet UILabel* caption;
	IBOutlet UITextField* textField;
	
	SingleLabelTextFieldCancelBlock cancelBlock;
	SingleLabelTextFieldDoneBlock doneBlock;
	
}

@property (retain) UILabel* label;
@property (retain) UILabel* caption;
@property (retain) UITextField* textField;
@property (copy) SingleLabelTextFieldCancelBlock cancelBlock;
@property (copy) SingleLabelTextFieldDoneBlock doneBlock;

-(id)initWithTitle:(NSString*)aTitle label:(NSString*)aLabel caption:(NSString*)aCaption text:(NSString*)aText;


@end
