//
//  ShareDataManager.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "ShareDataManager.h"
@implementation ShareDataManager

static  ShareDataManager *shareDataManager = nil;
@synthesize schedulerSaveList,arrivalSaveList,tripTImeSaveList,tState;

#pragma mark SINGLETON SETUP

+ (ShareDataManager *) shareDataManager {
	
	@synchronized(self) {
		if(shareDataManager == nil) {
			[[self alloc] init];
		}
	}
	return shareDataManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (shareDataManager == nil) {
            shareDataManager = [super allocWithZone:zone];
            return shareDataManager;  // assignment and return on first allocation
        }
    }
    return shareDataManager; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)init {
	if((self = [super init])) {
        arrivalSaveList=[[NSMutableArray alloc] init];
        tripTImeSaveList=[[NSMutableArray alloc] init];
        schedulerSaveList=[[NSMutableArray alloc] init];
		
	}
	return self;
}


-(void)saveData:(TabViewState)state{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *saveFile;
    NSMutableArray * saveArray =[NSMutableArray array];
    NSDictionary * saveDic;
    
    switch (state) {
        case tStateTripTime:
        
            saveFile = [documentsDirectory stringByAppendingPathComponent:@"tripTimeSaveList"];
            for (StationData* objectInstance in tripTImeSaveList){
                
                [saveArray addObject:[objectInstance classToDic:objectInstance]];
                saveDic= [NSDictionary dictionaryWithObject:saveArray forKey:@"tripTimeSaveList"];
            }
        
            break;
            
        case tStateScheduler:
            saveFile = [documentsDirectory stringByAppendingPathComponent:@"schedulerSaveList"];
            for (NSString* objectInstance in schedulerSaveList){
                
                [saveArray addObject:objectInstance];
                saveDic= [NSDictionary dictionaryWithObject:saveArray forKey:@"schedulerSaveList"];
            }
            break;
            
        case tStateArrival:
            saveFile = [documentsDirectory stringByAppendingPathComponent:@"arrivalSaveList"];
            for (StationData* objectInstance in arrivalSaveList){
                
                [saveArray addObject:[objectInstance classToDic:objectInstance]];
                saveDic= [NSDictionary dictionaryWithObject:saveArray forKey:@"arrivalSaveList"];
            }
            break;
            
        default:
            break;
    }

    NSLog(@"Array %@",saveArray);
    
    
    
    //NSDictionary * saveDic = [self indexKeyedDictionaryFromArray:saveArray];
    [saveDic writeToFile:saveFile atomically:YES];
    NSLog(@"LOC %@",saveFile);
}

-(void)loadData:(TabViewState)state{
    if(!shareDataManager)
        [ShareDataManager shareDataManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file;
    Boolean saveFileExists;
    
    switch (state) {
        case tStateTripTime:
        {
            file = [documentsDirectory stringByAppendingPathComponent:@"tripTimeSaveList"];

             saveFileExists = [[NSFileManager defaultManager] fileExistsAtPath:file];
            
            if(saveFileExists) {
                // don't need to set the result to anything here since we're just getting initwithCoder to be called.
                // if you try to overwrite sharedGameState here, an assert will be thrown.
                NSDictionary * getDic = [[NSDictionary alloc] initWithContentsOfFile:file];
                NSMutableArray * getArray =getDic[@"tripTimeSaveList"];
                for (NSDictionary * result in getArray) {
                    StationData * sta=[[StationData alloc] init];
                    sta.StopID=result[@"StopID"];
                    sta.StopName=result[@"StopName"];
                    sta.FromLine=result[@"FromLine"];
                    sta.HasLines=result[@"HasLines"];
                    sta.LocLat=[result [@"Lat"] floatValue];
                    sta.LocLon=[result [@"Lon"] floatValue];
                    
                    [tripTImeSaveList addObject:sta];
                    
                }
            }
            NSLog(@" data count %d",[tripTImeSaveList count]);
        }
            break;
            
        case tStateScheduler:
        {
            file = [documentsDirectory stringByAppendingPathComponent:@"schedulerSaveList"];
                 saveFileExists = [[NSFileManager defaultManager] fileExistsAtPath:file];
                
                if(saveFileExists) {
                    // don't need to set the result to anything here since we're just getting initwithCoder to be called.
                    // if you try to overwrite sharedGameState here, an assert will be thrown.
                    NSDictionary * getDic = [[NSDictionary alloc] initWithContentsOfFile:file];
                    NSMutableArray * getArray =getDic[@"schedulerSaveList"];
                    for (NSString * result in getArray)
                        [schedulerSaveList addObject:result];
                        
                    
                }
        }
            break;
            
        case tStateArrival:
        {
            file = [documentsDirectory stringByAppendingPathComponent:@"arrivalSaveList"];

                 saveFileExists = [[NSFileManager defaultManager] fileExistsAtPath:file];
                
                if(saveFileExists) {
                    // don't need to set the result to anything here since we're just getting initwithCoder to be called.
                    // if you try to overwrite sharedGameState here, an assert will be thrown.
                    NSDictionary * getDic = [[NSDictionary alloc] initWithContentsOfFile:file];
                    NSMutableArray * getArray =getDic[@"arrivalSaveList"];
                    for (NSDictionary * result in getArray) {
                        StationData * sta=[[StationData alloc] init];
                        sta.StopID=result[@"StopID"];
                        sta.StopName=result[@"StopName"];
                        sta.HasLines=result[@"HasLines"];
                        sta.LocLat=[result[@"Lat"] floatValue];
                        sta.LocLon=[result[@"Lon"] floatValue];
                        [arrivalSaveList addObject:sta];
                        
                        
                    }

                }
        }
            break;
            
        default:
            break;
    }
    
        
}

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSMutableArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return mutableDictionary;
}
-(BOOL)stationAlreadySavedinList:(NSString*)data List:(NSMutableArray *)list{
    for (StationData * line in list) {
        if ([[line StopName] isEqualToString:data]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)lineAlreadySavedinList:(NSString*)data List:(NSMutableArray *)list{
    for (NSString * line in list) {
        if ([line isEqualToString:data]) {
            return YES;
        }
    }
    
    return NO;
    
}




@end
