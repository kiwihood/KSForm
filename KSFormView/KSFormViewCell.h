//
//  KSFormViewCell.h
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSFormElement.h"

@interface KSFormViewCell : UITableViewCell

@property (nonatomic) KSFormElement * item;
@property (assign, nonatomic) BOOL editingMode;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)setSeparatorLastOne:(BOOL)lastOne leftInset:(CGFloat)left;

@end
