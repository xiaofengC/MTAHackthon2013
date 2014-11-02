//
//  ArrivalAlarmTableCell.m
//  MAlarm
//
//  Created by Chen on 5/5/13.
//
//

#import "ArrivalAlarmTableCell.h"

@implementation ArrivalAlarmTableCell
@synthesize trainColorImageView,lineIcon,hasLines,stationNameLabel,fromLineName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
        
        CGRect contentRect = self.contentView.bounds;
        
        trainColorImageView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 62/2, 138/2)];
        trainColorImageView.backgroundColor=[UIColor colorWithRed:114/255.0 green:74/255.0 blue:27/255.0 alpha:1];
        [self.contentView addSubview:trainColorImageView];
        
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self.contentView setAlpha:0.7];
        
        self.notice = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 50)];
        self.notice.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        self.notice.numberOfLines=1;
        [self.notice setBackgroundColor:[UIColor clearColor]];
        self.notice.hidden = TRUE;
        [self.contentView addSubview:self.notice];
        
        lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 79/2, 79/2)];
        //lineIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",fromLineName]];
        
        stationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 220, 50)];
        stationNameLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        stationNameLabel.numberOfLines=2;
        [stationNameLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:stationNameLabel];
        
        self.southTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 20, 60, 50)];
        self.southTimeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
        self.southTimeLabel.numberOfLines=1;
        self.southTimeLabel.text = @"S";
        [self.southTimeLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.southTimeLabel];
        
        self.northTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 80, 50)];
        self.northTimeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
        self.northTimeLabel.numberOfLines=1;
        self.northTimeLabel.text = @"N";
        [self.northTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.northTimeLabel];
        
        [self.contentView.layer setBorderColor:(__bridge CGColorRef)([UIColor colorWithRed:1 green:1 blue:1 alpha:1])];
        [self.contentView.layer setBorderWidth:1];
        //NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[hasLines length]];

        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
