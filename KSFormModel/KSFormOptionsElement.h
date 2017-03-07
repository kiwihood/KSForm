//
//  KSFormOptionsElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTitledElement.h"
#import <MapKit/MapKit.h>

@class KSFormOptionsElement;

const static short KSFormOptionDefaultSelection = 9999;



@protocol KSFormOptionObject <NSObject>
@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) NSArray * subOptions;
@property (nonatomic, readonly) BOOL isDefaultOption;
@optional
@property (nonatomic, readonly) BOOL isOpened;
@end



@protocol KSFormOptionsElementDelegate <KSFormElementDelegate>
@optional
- (void)formOptionsElementRequiredData:(KSFormOptionsElement*)sender complete:(void(^)(NSArray * options))completionHandler;
@end



@interface KSFormOptionsElement : KSFormTitledElement {
    short * _selections;
    NSInteger _numberOfComponents;
}

@property (strong, nonatomic) UITextField * textField;
@property (strong, nonatomic) NSArray * options;

@property (readonly) NSInteger numberOfComponents;

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title placeholder:(NSString*)placeholder;

- (NSInteger)selectionAtIndex:(NSInteger)index;
- (void)setSelection:(NSInteger)selection atIndex:(NSInteger)index;

- (id <KSFormOptionObject>)selectedItem;
- (void)updateValue;

@end
