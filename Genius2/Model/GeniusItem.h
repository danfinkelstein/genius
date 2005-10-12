//
//  GeniusItem.h
//  Genius2
//
//  Created by John R Chang on 2005-09-23.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


extern NSString * GeniusItemIsEnabledKey;
extern NSString * GeniusItemMyGroupKey;
extern NSString * GeniusItemMyTypeKey;
extern NSString * GeniusItemMyNotesKey;
extern NSString * GeniusItemMyRatingKey;
extern NSString * GeniusItemLastTestedDateKey;
extern NSString * GeniusItemLastModifiedDateKey;


@interface GeniusItem :  NSManagedObject  
{
	NSString * _displayGrade;
}

+ (NSArray *) allAtomKeys;

- (void) touchLastModifiedDate;
- (void) touchLastTestedDate;

- (NSString *) displayGrade;

- (void) resetAssociations;

- (void) flushCache;

@end


// exported only for GeniusV1FileImporter
extern NSString * GeniusItemAtomAKey;
extern NSString * GeniusItemAtomBKey;

extern NSString * GeniusItemAssociationsKey;
extern NSString * GeniusItemAssociationABKey;
extern NSString * GeniusItemAssociationBAKey;