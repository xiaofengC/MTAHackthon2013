//
//  ShareDataManager.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//
// Singleton for saving data locally
#import <Foundation/Foundation.h>
#import "StationData.h"
#import "LineData.h"

typedef enum  {
    tStateTripTime,
    tStateScheduler,
    tStateArrival
} TabViewState;

@interface ShareDataManager : NSObject

+ (ShareDataManager *) shareDataManager;
-(void)saveData:(TabViewState)state;
-(void)loadData:(TabViewState)state;

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSMutableArray *)array;
-(BOOL)lineAlreadySavedinList:(NSString*)data List:(NSMutableArray *)list;
-(BOOL)stationAlreadySavedinList:(NSString*)data List:(NSMutableArray *)list;


@property (nonatomic,readwrite) TabViewState tState;
/*
@property (nonatomic,strong)  NSDictionary * tripTImeSaveDic;
@property (nonatomic,strong)  NSDictionary * schedulerSaveDic;
@property (nonatomic,strong)  NSDictionary * arrivalSaveDic;
 */
@property (nonatomic,strong)  NSMutableArray  * tripTImeSaveList;
@property (nonatomic,strong) NSMutableArray * schedulerSaveList;
@property (nonatomic,strong) NSMutableArray * arrivalSaveList;

@end
