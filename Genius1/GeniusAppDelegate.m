/*
	Genius
	Copyright (C) 2003-2006 John R Chang
	Copyright (C) 2007-2008 Chris Miner

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.	

	http://www.gnu.org/licenses/gpl.txt
*/

#import <Foundation/Foundation.h>
#import "GeniusAppDelegate.h"

#import "GeniusHelpWindowController.h"
#import "GeniusItem.h"
#import "GeniusDocument.h"
#import "GeniusDocumentFile.h"

#import "GeniusPreferencesController.h"

//! Standard Cocoa Application delegate.
@implementation GeniusAppDelegate

//! Initializes application with factory defaults.
+ (void) initialize
{
    if (self == [GeniusAppDelegate class])
    {
        // Register defaults
        NSDictionary * defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                   
                                   [NSNumber numberWithBool:YES], GeniusPreferencesUseSoundEffectsKey,
                                   [NSNumber numberWithBool:YES], GeniusPreferencesQuizUseFullScreenKey,
                                   [NSNumber numberWithBool:YES], GeniusPreferencesQuizUseVisualErrorsKey,
                                   [NSNumber numberWithInt:GeniusPreferencesQuizSimilarMatchingMode], GeniusPreferencesQuizMatchingModeKey,
                                   
                                   [NSNumber numberWithInt:10], GeniusPreferencesQuizNumItemsKey,
                                   [NSNumber numberWithInt:20], GeniusPreferencesQuizFixedTimeMinKey,
                                   [NSNumber numberWithFloat:50.0], GeniusPreferencesQuizReviewLearnFloatKey,
                                   
                                   NULL];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
}

//! Releases @a preferencesController and frees memory.
- (void) dealloc {
    [preferencesController release];
    [helpController release];
    [super dealloc];
}

//! Instanciates a GeniusPreferencesController if needed and displays it.
- (IBAction) showPreferences:(id)sender
{
    if (!preferencesController) {
        preferencesController = [[GeniusPreferencesController alloc] init];        
    }
    [preferencesController showWindow:self];
}


//! Opens Source Forge project website via finder.
- (IBAction) showWebSite:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"http://sourceforge.net/projects/genius"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

//! Opens the yahoo genius talk website via finder.
- (IBAction) showSupportSite:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"http://groups.yahoo.com/group/genius-talk"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

//! Empty method to ensure that our sound toggle menu stays active.
/*!
  The state of the toggle menu is bound directly(through a binding) to the use sound effects user preference.
  However without a target and action it wouldn't remain enabled.
*/
- (IBAction) toggleSoundEffects:(id)sender
{

}

//! Presents basic help window @see GeniusHelpWindowController#showWindow
- (IBAction) showHelpWindow:(id)sender
{
    if (!helpController) {
        helpController = [[GeniusHelpWindowController alloc] init];
    }
    
    [[helpController window] center];
    [helpController showWindow:self];
}

//! Wraps call to GeniusDocument(FileFormat)::importFile:
- (IBAction)importFile:(id)sender
{
    [GeniusDocument importFile:sender];
    //I converted +(IBAction)importFile:sender to -(IBAction)importFile:sender somewhere else....Where?
}

@end


@implementation GeniusAppDelegate(NSApplicationDelegate)

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    srandom(time(NULL));
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// OpenFiles
    NSArray * openFiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenFiles"];
	if (openFiles)
	{
		NSString * path;
		NSEnumerator * pathEnumerator = [openFiles objectEnumerator];
		while ((path = [pathEnumerator nextObject]))
			[self application:NSApp openFile:path];
	}
}

/*
    This is a hack to suppress new window creation in the case where an empty window already exists.
*/
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSDocumentController * dc = [NSDocumentController sharedDocumentController];
    GeniusDocument * doc = (GeniusDocument *)[dc currentDocument];

    NSArray * documents = [dc documents];
    if (doc && [documents count] == 1 && [[doc pairs] count] == 0 && [doc isDocumentEdited] == NO)
    {
        NSError *error=error;
        NSURL * bundle = [[NSBundle mainBundle] bundleURL];
        NSURL * file = [NSURL URLWithString:@"..filename" relativeToURL:bundle];
        NSURL * absoluteFile = [file absoluteURL];

        BOOL succeed = [doc readFromURL:absoluteFile ofType:@"Genius Document" error:&error];
        //That used to be just:  BOOL succeed = [doc readFromFile:filename ofType:@"Genius Document"];
        if (!succeed)
            return NO;

        [doc reloadInterfaceFromModel];
        return YES;
    }
    else
    {
        doc = [dc openDocumentWithContentsOfFile:filename display:YES];
        return (doc != nil);
        /*
         Tried to make this:
         NSError *error=error;
         NSURL * bundle = [[NSBundle mainBundle] bundleURL];
         NSURL * file = [NSURL URLWithString:@"..filename" relativeToURL:bundle]; //should that be @"../Data/filename"?
         NSURL * absoluteFile = [file absoluteURL];
         doc = [dc openDocumentWithContentsOfURL:absoluteFile display:YES completionHandler:nil];
         //"nil" above used to be ^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error)     }
         return (doc != nil);
         But produces an error--probably have to figure out what to use for completionHandler.  Or WTF completionHandler is.
         */
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	// Get all document paths
	NSMutableArray * documentPaths = [NSMutableArray array];
	NSArray * documents = [NSApp orderedDocuments];
	NSEnumerator * documentEnumerator = [documents reverseObjectEnumerator];
	NSDocument * document;
	while ((document = [documentEnumerator nextObject]))
	{
		NSString * path = [[document fileURL] absoluteString];
		if (path)
			[documentPaths addObject:path];
	}

    [[NSUserDefaults standardUserDefaults] setObject:documentPaths forKey:@"OpenFiles"];
}

@end
