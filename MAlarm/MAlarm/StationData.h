//
//  StationData.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <Foundation/Foundation.h>

@interface StationData : NSObject 

-(NSDictionary *) classToDic:(StationData*)sta;
//-(StationData*) dicToClass:(NSDictionary*)dic;

@property(strong,nonatomic)NSString *StopID;
@property(strong,nonatomic)NSString *StopName;
@property(strong,nonatomic)NSString *FromLine;
@property(strong,nonatomic)NSString *HasLines;
@property(readwrite,nonatomic) float LocLat;
@property(readwrite,nonatomic) float LocLon;

@end
