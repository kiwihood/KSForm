//
//  KSFormDateToDateController.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormViewController.h"

@class KSFormDateElement;

@interface KSFormDateToDateController : KSFormViewController

- (instancetype)initWithElement:(KSFormDateElement*)element complete:(void(^)(NSDate * dateStart, NSDate * dateEnd))completionHandler;

@end
