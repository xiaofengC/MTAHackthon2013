//
//  FirstViewController.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <UIKit/UIKit.h>
@class ArrivalAlarmTableCell;

@interface TripTimeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    ShareDataManager * dataManager;
    UITableView * tripTimeTable;
    NSMutableArray * tripTimeList;
    NSMutableArray *timeResultList;
}

@end
