//
//  Webservice.h
//  MAlarm
//
//  Created by Chen on 5/5/13.
//
//
// Pack class for Server interation
#import <Foundation/Foundation.h>

@interface Webservice : NSObject
+(NSDictionary *)getIncomingTrains:(NSString*)routeID StopName:(NSString*)stopName;
+(NSDictionary *)getServiceStatus;
@end
