//
//  UITextView+Scalable.m
//  ShowMoreTextView
//
//  Created by Hisen on 2017/2/19.
//  Copyright © 2017年 Hisen. All rights reserved.
//

#import "UITextView+Scalable.h"
#import <objc/runtime.h>

#define LIMITLINECOUNT 3
#define TAIL_WORD @"more"
#define MIN_OFFSET 0.0001

@interface UITextView (ScalablePrivate)

@property (nonatomic, assign) NSInteger sp_limitLineCount;
@property (nonatomic, strong) NSString *sp_tailWord;
@property (nonatomic, strong) NSAttributedString *sp_originAttributedText;

@property (nonatomic, assign) NSInteger sp_currentLine;
@property (nonatomic, assign) NSInteger sp_cuttedIndex;
@property (nonatomic, assign) CGFloat sp_lastCharacterY;
@property (nonatomic, assign) CGFloat sp_expandHeight;
@property (nonatomic, assign) CGFloat sp_foldHeight;
@property (nonatomic, assign) BOOL sp_isFold;

@end

@implementation UITextView (ScalablePrivate)

- (NSString *)sp_tailWord {
    return objc_getAssociatedObject(self.class, _cmd);
}

- (void)setSp_tailWord:(NSString *)sp_tailWord {
    objc_setAssociatedObject(self.class, @selector(sp_tailWord), sp_tailWord, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)sp_limitLineCount {
    return [objc_getAssociatedObject(self.class, _cmd) integerValue];
}

- (void)setSp_limitLineCount:(NSInteger)sp_limitLineCount {
    objc_setAssociatedObject(self.class, @selector(sp_limitLineCount), @(sp_limitLineCount) , OBJC_ASSOCIATION_RETAIN);
}

- (NSAttributedString *)sp_originAttributedText {
    return objc_getAssociatedObject(self.class, _cmd);
}

- (void)setSp_originAttributedText:(NSAttributedString *)sp_originAttributedText {
    objc_setAssociatedObject(self.class, @selector(sp_originAttributedText), sp_originAttributedText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)sp_cuttedIndex {
    return [objc_getAssociatedObject(self.class, _cmd) integerValue];
}

- (void)setSp_cuttedIndex:(NSInteger)sp_cuttedIndex {
    objc_setAssociatedObject(self.class, @selector(sp_cuttedIndex), @(sp_cuttedIndex) , OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)sp_currentLine {
    return [objc_getAssociatedObject(self.class, _cmd) integerValue];
}

- (void)setSp_currentLine:(NSInteger)sp_currentLine {
    objc_setAssociatedObject(self.class, @selector(sp_currentLine), @(sp_currentLine) , OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)sp_lastCharacterY {
    return [objc_getAssociatedObject(self.class, _cmd) floatValue];
}

- (void)setSp_lastCharacterY:(CGFloat)sp_lastCharacterY {
    objc_setAssociatedObject(self.class, @selector(sp_lastCharacterY), @(sp_lastCharacterY), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)sp_expandHeight {
    return [objc_getAssociatedObject(self.class, _cmd) floatValue];
}

- (void)setSp_expandHeight:(CGFloat)sp_expandHeight {
    objc_setAssociatedObject(self.class, @selector(sp_expandHeight), @(sp_expandHeight), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)sp_foldHeight {
    return [objc_getAssociatedObject(self.class, _cmd) floatValue];
}

- (void)setSp_foldHeight:(CGFloat)sp_foldHeight {
    objc_setAssociatedObject(self.class, @selector(sp_foldHeight), @(sp_foldHeight), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)sp_isFold {
    return [objc_getAssociatedObject(self.class, _cmd) boolValue];
}

- (void)setSp_isFold:(BOOL)sp_isFold {
    objc_setAssociatedObject(self.class, @selector(sp_isFold), @(sp_isFold), OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation UITextView (Scalable)

- (HeightDidChangedBlock)sp_heightDidChangedBlock {
    return objc_getAssociatedObject(self.class, _cmd);
}

- (void)setSp_heightDidChangedBlock:(HeightDidChangedBlock)sp_heightDidChangedBlock {
    objc_setAssociatedObject(self.class, @selector(sp_heightDidChangedBlock), sp_heightDidChangedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - public
- (void)initTextViewWithText:(NSMutableAttributedString *)attributedText {
    [self initTextViewWithText:attributedText tailWord:TAIL_WORD limitLineCount:LIMITLINECOUNT];
}

- (void)initTextViewWithText:(NSMutableAttributedString *)attributedText tailWord:(NSString *)tailWord limitLineCount:(NSInteger)limitLineCount {
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    self.textContainerInset = UIEdgeInsetsMake(0, -lineFragmentPadding, 0, -lineFragmentPadding);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
    
    self.layoutManager.delegate = self;
    self.sp_limitLineCount = limitLineCount;
    self.sp_tailWord = tailWord;
    self.sp_originAttributedText = attributedText;
    self.attributedText = attributedText;
    [self layoutIfNeeded];
    
    CGSize expandTextViewSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    
    self.sp_expandHeight = expandTextViewSize.height;
    
    if (self.sp_currentLine > self.sp_limitLineCount) {
        self.sp_isFold = YES;
        self.attributedText = [self generateFoldText];
        [self layoutIfNeeded];
        CGSize foldTextViewSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        self.sp_foldHeight = foldTextViewSize.height;
        self.sp_heightDidChangedBlock(self.sp_foldHeight);
    } else {
        self.sp_isFold = NO;
        self.attributedText = self.sp_originAttributedText;
        self.sp_heightDidChangedBlock(self.sp_expandHeight);
    }
}

#pragma mark - UITapGestureRecognizer Action
- (void)handleTap {
    if (self.sp_foldHeight == 0) {
        return;
    }
    if (self.sp_isFold) {
        self.sp_isFold = NO;
        self.attributedText = self.sp_originAttributedText;
        self.sp_heightDidChangedBlock(self.sp_expandHeight);
    } else {
        self.sp_isFold = YES;
        self.attributedText = [self generateFoldText];
        self.sp_heightDidChangedBlock(self.sp_foldHeight);
    }
}

#pragma mark - private
- (NSMutableAttributedString *)generateFoldText {
    NSMutableAttributedString *cuttedText = [[NSMutableAttributedString alloc] initWithAttributedString:[self.attributedText attributedSubstringFromRange:NSMakeRange(0, self.sp_cuttedIndex)]];
    [cuttedText.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [cuttedText replaceCharactersInRange:NSMakeRange(cuttedText.length - 2 - self.sp_tailWord.length, (2 + self.sp_tailWord.length)) withString:[NSString stringWithFormat:@"..%@", self.sp_tailWord]];
    [cuttedText addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:31/255.0 green:128/255.0 blue:238/255.0 alpha:1.0]} range:NSMakeRange(cuttedText.length - 2 - self.sp_tailWord.length, (2 + self.sp_tailWord.length))];
    return cuttedText;
}

#pragma mark - NSLayoutManagerDelegate
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
    self.sp_cuttedIndex = 0;
    self.sp_currentLine = 1;
    self.sp_lastCharacterY = 0.0;
    NSRange wordRange = NSMakeRange(0, self.textStorage.string.length);
    
    for (NSUInteger glyphIndex = wordRange.location; glyphIndex < wordRange.length + wordRange.location; glyphIndex += 0) {
        
        NSRange glyphRange = NSMakeRange(glyphIndex, 1);
        
        CGRect glyphRect = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
        
        NSRange characterRange = [self.layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
        
        if (self.sp_currentLine <= self.sp_limitLineCount) {
            if (glyphRect.origin.y - self.sp_lastCharacterY  > MIN_OFFSET) {
                self.sp_currentLine += 1;
                if (self.sp_currentLine > self.sp_limitLineCount) {
                    break;
                }
                self.sp_lastCharacterY = glyphRect.origin.y;
            }
            self.sp_cuttedIndex = characterRange.location + characterRange.length;
        }
        
        glyphIndex += characterRange.length;
    }
}

@end
