//
//  AppDelegate.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,CLLocationManagerDelegate>{
    ShareDataManager * dataManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong,nonatomic) CLLocationManager *locationManager;
@end
