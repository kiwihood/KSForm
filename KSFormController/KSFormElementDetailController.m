//
//  KSFormElementDetailController.m
//  EweiHelp
//
//  Created by Kiwi on 2016/12/14.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormElementDetailController.h"

@interface KSFormElementDetailController ()

@property (strong, nonatomic) NSString * elementTitle;
@property (strong, nonatomic) NSString * elementContent;

@end

@implementation KSFormElementDetailController

- (instancetype)initWithTitle:(NSString*)title content:(NSString*)content {
    if (self = [super init]) {
        // Initialization Code
        self.elementTitle = title;
        self.elementContent = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.elementTitle;
    
    UITextView * textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:16];
    textView.editable = NO;
    textView.contentInset = UIEdgeInsetsMake(16, 16, 16, 16);
    textView.text = self.elementContent;
    [self.view addSubview:textView];
}

@end
