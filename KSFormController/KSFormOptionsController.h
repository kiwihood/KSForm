//
//  KSFormOptionsController.h
//  EweiHelp
//
//  Created by Kiwi on 16/7/1.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSFormOptionsElement;

@interface KSFormOptionsController : UIViewController

- (instancetype)initWithElement:(KSFormOptionsElement*)element complete:(void(^)(NSArray * selectedObjects))completionHandler;

@end
