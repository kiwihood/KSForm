//
//  KSFormMultiOptionsElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormOptionsElement.h"

@protocol KSFormMultiOptionsElementDelegate <KSFormOptionsElementDelegate>
@optional
- (void)formMultiOptionsElementTriggered:(KSFormOptionsElement*)sender;
@end



@interface KSFormMultiOptionsElement : KSFormOptionsElement

- (BOOL)getCheckedForIndex:(int)index;
- (void)setChecked:(BOOL)checked forIndex:(int)index;

@end
