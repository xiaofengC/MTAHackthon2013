//
//  SecondViewController.m
//  MAlarm
//
//  Created by Chen on 5/4/13.
//
//

#import "ScheduleChangeViewController.h"
#import "Webservice.h"
#import "ArrivalAlarmTableCell.h"
#import "NewsViewController.h"
#import "LineSelectionViewController.h"

@interface ScheduleChangeViewController ()

@end

@implementation ScheduleChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Changes", @"Changes");
        self.tabBarItem.image = [UIImage imageNamed:@"serviceicon"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil] ;
    
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"addnew"] forState:UIControlStateNormal];
    [settingBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [settingBtn addTarget:self
                   action:@selector(gotoLinSelection:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Menu_Right=[[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem=Menu_Right;
    
     
    
    UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT)];
    bgImage.image = [UIImage imageNamed:@"stationbg"];
    [self.view addSubview:bgImage];
    scheduleTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEHEIGHT) style:UITableViewStylePlain];
    [scheduleTable setDelegate:self];
    [scheduleTable setDataSource:self];
    [scheduleTable setBackgroundColor:[UIColor clearColor]];;
    scheduleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:scheduleTable];
    
    statusResultList = [[NSMutableArray alloc] init];

	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    dataManager = [ShareDataManager shareDataManager];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [statusResultList removeAllObjects];
        NSDictionary *result = [Webservice getServiceStatus];
        for (NSString* line in [dataManager.schedulerSaveList copy]) {
            if(result[@"lines"][line] != nil) {
                [statusResultList addObject:[NSArray arrayWithArray:result[@"lines"][line]]];
            } else {
                [statusResultList addObject:[[NSArray alloc] init]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [scheduleTable reloadData];
        });
    });
    [scheduleTable reloadData];
}

#pragma Button Method
-(void)gotoLinSelection:(id)sender{
    dataManager.tState = tStateScheduler;
    LineSelectionViewController* lineSelectionViewController =[[LineSelectionViewController alloc] init];
    [self.navigationController pushViewController:lineSelectionViewController animated:YES];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [dataManager.schedulerSaveList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  137.0f/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Load txt!");
    static NSString *cellIdentifier = @"ArrivalAlarmTableCell";
    ArrivalAlarmTableCell *cell = (ArrivalAlarmTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
        cell= [[ArrivalAlarmTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
	}
    
    CGRect  rect = cell.stationNameLabel.frame;
    rect.origin.y = 5;
    cell.stationNameLabel.frame = rect;
    cell.stationNameLabel.text=[lineFullNameList objectAtIndex:indexPath.row];
    cell.lineIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@iconlarge",[dataManager.schedulerSaveList objectAtIndex:indexPath.row]]];
    cell.stationNameLabel.hidden = TRUE;
    cell.northTimeLabel.hidden = TRUE;
    cell.southTimeLabel.hidden = TRUE;
    [cell.contentView addSubview:cell.lineIcon];
    NSString *news = @"";
    NSString *changes = @"";

    if([statusResultList count] > [indexPath row]) {
        NSArray *newsArray = statusResultList[[indexPath row]];
        for(NSDictionary *newsDict in newsArray) {
            changes = [changes stringByAppendingFormat:@"%@\n", newsDict[@"short"]];
            changes = [changes stringByAppendingFormat:@"%@\n", newsDict[@"detail"]];
            NSLog(@"Changes %@", changes);
        }
    }
    
    if([changes length] > 0) {
        news = @"Service Changed";
    }
    else{
        news = @"Good Service";
    }

    
    cell.notice.text = news;
    cell.notice.hidden = FALSE;

    NSString * colorCase = [dataManager.schedulerSaveList objectAtIndex:indexPath.row];
    
    if ([colorCase isEqualToString:@"1"]||[colorCase isEqualToString:@"2"]||[colorCase isEqualToString:@"3"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"4"]||[colorCase isEqualToString:@"5"]||[colorCase isEqualToString:@"6"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:147/255.0 blue:60/255.0 alpha:1]];
    }
    
    
    if ([colorCase isEqualToString:@"7"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:185/255.0 green:51/255.0 blue:173/255.0 alpha:1]];
    }
    
    
    if ([colorCase isEqualToString:@"A"]||[colorCase isEqualToString:@"C"]||[colorCase isEqualToString:@"E"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:40/255.0 green:80/255.0 blue:173/255.0 alpha:1]];
    }
    
    
    if ([colorCase isEqualToString:@"B"]||[colorCase isEqualToString:@"D"]||[colorCase isEqualToString:@"F"]||[colorCase isEqualToString:@"M"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:99/255.0 blue:25/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"G"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:108/255.0 green:190/255.0 blue:69/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"J"]||[colorCase isEqualToString:@"Z"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:153/255.0 green:102/255.0 blue:51/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"L"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:167/255.0 green:169/255.0 blue:172/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"S"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:128/255.0 green:129/255.0 blue:131/255.0 alpha:1]];
    }
    
    if ([colorCase isEqualToString:@"N"]||[colorCase isEqualToString:@"Q"]||[colorCase isEqualToString:@"R"]) {
        [cell.trainColorImageView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:204/255.0 blue:0/255.0 alpha:1]];
    }
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     // Delete the row from the data source
         [dataManager.schedulerSaveList removeObjectAtIndex:[indexPath row]];
         [dataManager saveData:tStateScheduler];
         [scheduleTable reloadData];
         if([statusResultList count]>[indexPath row]) {
             [statusResultList removeObjectAtIndex:[indexPath row]];
         }
     }
 }


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *news = @"";
    if([statusResultList count] > [indexPath row]) {
        NSArray *newsArray = statusResultList[[indexPath row]];
        for(NSDictionary *newsDict in newsArray) {
            news = [news stringByAppendingFormat:@"%@\n", newsDict[@"short"]];
            news = [news stringByAppendingFormat:@"%@\n", newsDict[@"detail"]];
        }
    }
    if ([news isEqualToString:@""]) {
        news = @"Good Service";
    }
    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    newsViewController.news = news;
    [self.navigationController pushViewController:newsViewController animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
