//
//  KSFormMultiOptionsController.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSFormMultiOptionsElement;

@interface KSFormMultiOptionsController : UIViewController

- (instancetype)initWithElement:(KSFormMultiOptionsElement*)element complete:(void(^)(NSArray * selectedObjects))completionHandler;

@end
