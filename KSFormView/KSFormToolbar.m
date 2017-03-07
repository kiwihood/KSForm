//
//  KSFormToolbar.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormToolbar.h"

@implementation KSFormToolbar

+ (instancetype)toolbarWithDelegate:(id)delegate {
    return [[[self class] alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id)delegate {
    if (self = [super initWithFrame:CGRectZero]) {
        // Initialization Code
        self.delegate = delegate;
//        self.tintColor = Color_Key;
//        UIBarButtonItem * itemBack = [[UIBarButtonItem alloc] initWithTitle:Loc(@"Last_One") style:UIBarButtonItemStylePlain target:self action:@selector(btnBackPressed:)];
//        UIBarButtonItem * itemNext = [[UIBarButtonItem alloc] initWithTitle:Loc(@"Next_One") style:UIBarButtonItemStylePlain target:self action:@selector(btnNextPressed:)];
        UIBarButtonItem * itemBack = [[UIBarButtonItem alloc] initWithImage:[self arrowButtonImage:NO] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackPressed:)];
        UIBarButtonItem * itemNext = [[UIBarButtonItem alloc] initWithImage:[self arrowButtonImage:YES] style:UIBarButtonItemStylePlain target:self action:@selector(btnNextPressed:)];
        UIBarButtonItem * itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem * itemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDonePressed:)];
        self.items = @[itemBack, itemNext, itemSpace, itemDone];
    }
    return self;
}

- (void)btnBackPressed:(id)sender {
    [((id<KSFormToolbarDelegate>)self.delegate) formToolbarBackPressed:self];
}
- (void)btnNextPressed:(id)sender {
    [((id<KSFormToolbarDelegate>)self.delegate) formToolbarNextPressed:self];
}
- (void)btnDonePressed:(id)sender {
    [((id<KSFormToolbarDelegate>)self.delegate) formToolbarDonePressed:self];
}

- (UIImage*)arrowButtonImage:(BOOL)forward {
    CGSize sizeMain = CGSizeMake(30, 30);
    CGSize size = CGSizeMake(8, 20);
    CGPoint point = CGPointMake((sizeMain.width - size.width) / 2, (sizeMain.height - size.height) / 2);
    if (!forward) {
        point.x += size.width;
    }
    UIGraphicsBeginImageContextWithOptions(sizeMain, NO, 0.0);
    
    // Draw
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(con, self.tintColor.CGColor);
    CGContextSetLineWidth(con, 2);
    CGContextMoveToPoint(con, point.x, point.y);
    if (forward) {
        CGContextAddLineToPoint(con, point.x + size.width, point.y + size.height / 2);
        CGContextAddLineToPoint(con, point.x, point.y + size.height);
    } else {
        CGContextAddLineToPoint(con, point.x - size.width, point.y + size.height / 2);
        CGContextAddLineToPoint(con, point.x, point.y + size.height);
    }
    CGContextStrokePath(con);
    
    UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
