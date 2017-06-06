//
//  ViewController.m
//  ShowMoreTextView
//
//  Created by Hisen on 2017/2/19.
//  Copyright © 2017年 Hisen. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+Scalable.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textView.sp_heightDidChangedBlock = ^(CGFloat height) {
        self.textViewHeight.constant = height;
    };
    NSString *string = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
    [self.textView initTextViewWithText:attributedString];
//    [self.textView initTextViewWithText:attributedString tailWord:@"展开" limitLineCount:5];
}


@end
