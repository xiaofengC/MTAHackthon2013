//
//  LineSelectionViewController.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <UIKit/UIKit.h>
@class ArrivalAlarmTableCell;


@interface LineSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UITableView * LineSelectionTable;
    NSMutableArray * lineList;
    ShareDataManager * dataManager;
}

@end
