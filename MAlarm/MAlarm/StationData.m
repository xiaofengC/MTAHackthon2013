//
//  StationData.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "StationData.h"

@implementation StationData
@synthesize StopID,StopName,LocLat,LocLon,FromLine,HasLines;

- (id)init {
	if((self = [super init])) {
        StopID=@"0";
	}
	return self;
}

-(NSDictionary *) classToDic:(StationData*)sta{
    NSDictionary *newDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            sta.StopID,@"StopID",
                            sta.StopName,@"StopName",
                            [NSString stringWithFormat:@"%f",sta.LocLat],
                            @"Lat", [NSString stringWithFormat:@"%f", sta.LocLon],@"Lon",
                            sta.FromLine,@"FromLine",
                            sta.HasLines,@"HasLines",
                            nil];
 //nil to signify end of objects and keys.
    

    return newDic;
    
}


@end
