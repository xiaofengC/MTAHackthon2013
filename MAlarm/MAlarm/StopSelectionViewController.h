//
//  StopSelectionViewController.h
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import <UIKit/UIKit.h>
@class StationData;


@interface StopSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UITableView * StopTableView;
    
    NSMutableArray * stopList;
    
    ShareDataManager * dataManager;
}

@property (strong,nonatomic)  NSString * selectedLine;

@end
