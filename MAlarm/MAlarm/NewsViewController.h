//
//  NewsViewController.h
//  MAlarm
//
//  Created by Chen on 5/5/13.
//
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
@property(nonatomic, strong) NSString *news;
@property(nonatomic, weak) IBOutlet UITextView *textView;
@end
