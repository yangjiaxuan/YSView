//
//  UIView+YSDebug.m
//  YSView
//
//  Created by 杨森 on 2018/5/6.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "UIView+YSDebug.h"
#import <objc/runtime.h>

@implementation UIView (YSDebug)

#define kYSDebug_infoLabelTag 99999999

+ (void)ysDebug{
    [[[self alloc]init] ysDebug_swizzingFunction];
}

- (void)ysDebug_swizzingFunction{
    static dispatch_once_t onceToken_swizzing;
    dispatch_once(&onceToken_swizzing, ^{
        SEL originalSEL = @selector(layoutSubviews);
        SEL swizzledSEL = @selector(ysDebug_layoutSubviews);
        Method originalMethod = class_getInstanceMethod([self class], originalSEL);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSEL);
        BOOL didAddMethod = class_addMethod([self class], @selector(willMoveToSuperview:), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod([self class], swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)layoutSubviews{}

- (void)ysDebug_layoutSubviews{
    if (self.tag == kYSDebug_infoLabelTag ||
        [self isKindOfClass:[UIWindow class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
//            if (timestamp-[self lastTimestamp]>250) {
                [self resetInfo];
//                [self setLastTimestamp:timestamp];
//            }
        });
    });
    [self ysDebug_layoutSubviews];
}

- (void)resetInfo{
    UIColor *borderColor   = [UIColor redColor];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 2;
    [self infoLabel].text  = [NSString stringWithFormat:@" X:%.0f\r\n Y:%.0f\r\n W:%.0f\r\n H:%.0f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height];
    [self infoLabel].textColor = borderColor;
}

#define kYSDebug_Key_lastTimestamp @"kYSDebug_Key_lastTimestamp"
- (void)setLastTimestamp:(NSInteger)lastTimestamp{
    objc_setAssociatedObject(self, kYSDebug_Key_lastTimestamp, @(lastTimestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)lastTimestamp{
    return [objc_getAssociatedObject(self, kYSDebug_Key_lastTimestamp) integerValue];
}

#define kYSDebug_Key_infoLabel @"kYSDebug_Key_infoLabel"
- (void)setInfoLabel:(UILabel *)infoLabel{
    objc_setAssociatedObject(self, kYSDebug_Key_infoLabel, infoLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)infoLabel{
    UILabel *infoLabel = objc_getAssociatedObject(self, kYSDebug_Key_infoLabel);
    if (!infoLabel) {
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        infoLabel.font = [UIFont systemFontOfSize:8];
        infoLabel.tag  = kYSDebug_infoLabelTag;
        infoLabel.numberOfLines = 0;
        [self addSubview:infoLabel];
        [self setInfoLabel:infoLabel];
    }
    return infoLabel;
}

@end
