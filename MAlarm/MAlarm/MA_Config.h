//
//  MA_Config.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <Foundation/Foundation.h>
#import "ShareDataManager.h"

#pragma Web Service Address

#define API_GETINCOMINGTRAINS @"http://www.fbstyle.us:3610/mta/getincomingtrain?route=%@&stopname=%@"
#define API_GETSERVICESTATUS @"http://www.fbstyle.us:3610/mta/getservicestatus"

#pragma UI Config

#define WINHEIGHT [ [ UIScreen mainScreen ] bounds ].size.height
#define TABLEHEIGHT WINHEIGHT-(49+44+20)
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IP5_SCREEN_DIF 88

#pragma Location Setting

#define DEFAULT_UPDATE_INTERVERAL 30;
#define DEFAULT_SEARCH_RADIUS 500;

@interface MA_Config : NSObject

@end
