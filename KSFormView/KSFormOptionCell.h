//
//  KSFormOptionCell.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSFormOptionsElement.h"

@interface KSFormOptionCell : UITableViewCell {
    UILabel * _textLabel;
}

@property (nonatomic) id <KSFormOptionObject> item;
@property (assign, nonatomic) BOOL checked;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//- (void)setSeparatorLastOne:(BOOL)lastOne leftInset:(CGFloat)left;

@end
