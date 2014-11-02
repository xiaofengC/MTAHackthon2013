//
//  ArrivalAlarmTableCell.h
//  MAlarm
//
//  Created by Chen on 5/5/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ArrivalAlarmTableCell : UITableViewCell

@property (nonatomic , strong) UIView * trainColorImageView;
@property (nonatomic , strong) UILabel * stationNameLabel;
@property (nonatomic , strong) UILabel * southTimeLabel;
@property (nonatomic , strong) UILabel * northTimeLabel;
@property (nonatomic , strong) NSString * fromLineName;
@property (nonatomic , strong) NSString * hasLines;
@property (nonatomic , strong) UIImageView * lineIcon;
@property (nonatomic, strong) NSString *southTime;
@property (nonatomic, strong) NSString *northTime;
@property (nonatomic, strong) UILabel *notice;
@end
