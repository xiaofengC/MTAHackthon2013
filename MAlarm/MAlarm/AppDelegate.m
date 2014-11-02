//
//  AppDelegate.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "AppDelegate.h"
#import "TripTimeViewController.h"
#import "ScheduleChangeViewController.h"
#import "ArrivalAlarmViewController.h"
#import "ShareDataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    dataManager=[ShareDataManager shareDataManager];
    [dataManager loadData:tStateTripTime];
    [dataManager loadData:tStateScheduler];
    [dataManager loadData:tStateArrival];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *tripTimeViewController = [[TripTimeViewController alloc] init];
    UIViewController *scheduleChangeViewController = [[ScheduleChangeViewController alloc] init];
    UIViewController *arrivalAlarmViewController = [[ArrivalAlarmViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:tripTimeViewController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:scheduleChangeViewController];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:arrivalAlarmViewController];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0
                                                               green:0/255.0
                                                                blue:0/255.0
                                                               alpha:1.0]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0], UITextAttributeFont, nil]];
    
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[nav1, nav2, nav3];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    
    [self getUserLocation];

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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//register the delegate and start update
-(void)getUserLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    
    CLLocation *location = [self.locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSLog(@"dLatitude : %@", latitude);
    NSLog(@"dLong : %@", longitude);
    

}

// check if the station is nearby
-(void)checkArrivalAlarm:(CLLocation*)userLocation{
    for (int i = 0 ; i<[dataManager.arrivalSaveList count];i++) {
        CLLocationDegrees lat =[[dataManager.arrivalSaveList objectAtIndex:i] LocLat] ;
        CLLocationDegrees lon =[[dataManager.arrivalSaveList objectAtIndex:i] LocLon] ;
              
        CLLocation *StopLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLLocationDistance distance = [userLocation distanceFromLocation:StopLocation];
        // test for distance 500
        if (distance < 500) {
            // send background notification
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            //notif.fireDate = nil;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.fireDate = nil;
            notif.alertBody =[NSString stringWithFormat:@"The train is appoarching %@!",[[dataManager.arrivalSaveList objectAtIndex:i] StopName]];
            notif.alertAction = @"Alert me";
            notif.soundName = UILocalNotificationDefaultSoundName;
            notif.applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication]  presentLocalNotificationNow:notif];
            
            //send alert
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Arrival!" message:[NSString stringWithFormat:@"The train is appoarching %@!",[[dataManager.arrivalSaveList objectAtIndex:i] StopName]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            SystemSoundID bell;
            
            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"message"
                                                        withExtension: @"mp3"];
            
            AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)tapSound, &bell);
            AudioServicesPlaySystemSound (bell);
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            
        }
    }

}
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [self checkArrivalAlarm:newLocation];
  /*
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        
        lastLocationUpdateTiemstamp = [userDefaults objectForKey:kLastLocationUpdateTimestamp];
        
        if ([newLocationTimestamp timeIntervalSinceDate:lastLocationUpdateTiemstamp] > DEFAULT_UPDATE_INTERVERAL) {
            //NSLog(@"New Location: %@", newLocation);
            [(AppDelegate*)[UIApplication sharedApplication].delegate didUpdateToLocation:newLocation];
            [userDefaults setObject:newLocationTimestamp forKey:kLastLocationUpdateTimestamp];
        }
    }
   */
    
}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
