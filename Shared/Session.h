//
//  Session.h
//  verifip
//
//  Created by Aubrey Goodman on 6/1/10.
//  Copyright 2011 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveResource.h"


@interface Session : NSObject {

	NSString* email;
	NSString* password;
	NSString* userId;

}

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* userId;


@end
