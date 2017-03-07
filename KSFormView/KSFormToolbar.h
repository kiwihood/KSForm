//
//  KSFormToolbar.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSFormToolbarDelegate <UIToolbarDelegate>
@optional
- (void)formToolbarBackPressed:(id)sender;
- (void)formToolbarNextPressed:(id)sender;
- (void)formToolbarDonePressed:(id)sender;
@end

@interface KSFormToolbar : UIToolbar

+ (instancetype)toolbarWithDelegate:(id)delegate;

@end
