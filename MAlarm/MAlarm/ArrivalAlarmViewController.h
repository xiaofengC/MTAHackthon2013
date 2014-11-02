//
//  ArrivalAlarmViewController.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <UIKit/UIKit.h>
@class ArrivalAlarmTableCell;

@interface ArrivalAlarmViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
     ShareDataManager * dataManager;
    UITableView * arrivalTable;
}

@end
