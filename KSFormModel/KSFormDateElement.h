//
//  KSFormDateElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTitledElement.h"

@class KSFormDateElement;
#define KSFormDateStartKey @"KSFormDateStartKey"
#define KSFormDateEndKey @"KSFormDateEndKey"

// For Date To Date Only
@protocol KSFormDateElementDelegate <KSFormElementDelegate>
@optional
- (void)formDateElementSelectDateToDate:(KSFormDateElement*)sender;
@end



@interface KSFormDateElement : KSFormTitledElement

@property (assign, nonatomic) UIDatePickerMode dateMode; /* default value is UIDatePickerModeDate */

// For Date To Date Only
@property (assign, nonatomic) BOOL dateToDate;
@property (strong, nonatomic) NSDate * date;
@property (strong, nonatomic) NSDate * dateStart;
@property (strong, nonatomic) NSDate * dateEnd;

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(id)defaultValue placeholder:(NSString*)placeholder;

@end
