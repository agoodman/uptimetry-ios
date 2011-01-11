//
//  CaptionLabelCell.m
//  Napkin
//
//  Created by Aubrey Goodman on 2/15/10.
//  Copyright 2010 VerifIP LLC. All rights reserved.
//

#import "CaptionLabelCell.h"


@implementation CaptionLabelCell

@synthesize caption, label;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[caption release];
	[label release];
    [super dealloc];
}


@end
