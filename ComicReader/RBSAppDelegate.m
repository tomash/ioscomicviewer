//
//  RBSAppDelegate.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSIndexController.h"
#import "RBSAppDelegate.h"

#define kAcceptedExtensionsPattern @"cbz|acv"

@implementation RBSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadComicFilesList];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self loadComicFilesList];
    [self.indexController.tableView reloadData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:url.lastPathComponent];
    
    [[NSFileManager defaultManager] copyItemAtPath:url.path toPath:destinationPath error:nil];

    return true;
}

#pragma mark RBSIndexController updates

- (RBSIndexController *)indexController
{
    return (RBSIndexController *)[(UINavigationController *)self.window.rootViewController topViewController];
}

- (void)loadComicFilesList
{
    NSString *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kAcceptedExtensionsPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *comicFiles = [[allFiles select:^BOOL(NSString *filename) {
        NSUInteger numMatches = [regex numberOfMatchesInString:filename.pathExtension options:0 range:NSMakeRange(0, filename.pathExtension.length)];
        return numMatches > 0;
    }] map:^id(NSString *filename) {
        return [documentsDir stringByAppendingPathComponent:filename];
    }];
    
    // topViewController is our comic index
    self.indexController.comicFiles = comicFiles;
}

@end
