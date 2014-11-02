//
//  SecondViewController.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <UIKit/UIKit.h>


@interface ScheduleChangeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView * scheduleTable;
    ShareDataManager * dataManager;
    NSMutableArray * lineFullNameList;
    NSMutableArray *statusResultList;
}

@end
