//
//  UITextView+Scalable.h
//  ShowMoreTextView
//
//  Created by Hisen on 2017/2/19.
//  Copyright © 2017年 Hisen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HeightDidChangedBlock)(CGFloat);

@interface UITextView (Scalable) <NSLayoutManagerDelegate>

@property (nonatomic, copy) HeightDidChangedBlock sp_heightDidChangedBlock;

- (void)initTextViewWithText:(NSMutableAttributedString *)attributedText;
- (void)initTextViewWithText:(NSMutableAttributedString *)attributedText tailWord:(NSString *)tailWord limitLineCount:(NSInteger)limitLineCount;

@end
