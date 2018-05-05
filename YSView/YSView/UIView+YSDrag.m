//
//  UIView+YSDrag.m
//  YSView
//
//  Created by 杨森 on 2018/5/5.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "UIView+YSDrag.h"
#import <objc/runtime.h>

#define kYSDragPanGestureName @"kYSDragPanGesture"
#define kYSDragKey_adsorb @"kYSDragKey_adsorb"

@implementation UIView (YSDrag)

- (void)setAdsorb:(BOOL)adsorb{
    objc_setAssociatedObject(self, kYSDragKey_adsorb, @(adsorb), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isAdsorb{
    return [objc_getAssociatedObject(self, kYSDragKey_adsorb) boolValue];
}

//MARK:拖动逻辑
- (void)ys_dragAdsorb:(BOOL)isAdsorb{
    [self setAdsorb:isAdsorb];
    
    UIGestureRecognizer *pan = [self ys_gestureRecognierWithName:kYSDragPanGestureName];
    if (!pan) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ys_dragAction:)];
        pan.name = kYSDragPanGestureName;
        [self addGestureRecognizer:pan];
    }
    [self ys_setGestureRecoginzerEnable:NO exceptName:kYSDragPanGestureName];
}

- (void)ys_noDrag{
    UIGestureRecognizer *pan = [self ys_gestureRecognierWithName:kYSDragPanGestureName];
    if (pan) {
        [self removeGestureRecognizer:pan];
    }
    [self ys_setGestureRecoginzerEnable:YES exceptName:kYSDragPanGestureName];
}

- (void)ys_dragAction:(UIPanGestureRecognizer *)sender{

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self ys_willDrag];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint last_pt = [sender translationInView:self];
        CGFloat pt_x    = last_pt.x + self.frame.origin.x;
        CGFloat pt_y    = last_pt.y + self.frame.origin.y;
        self.frame = CGRectMake(pt_x, pt_y, self.frame.size.width, self.frame.size.height);
    }else{
        self.transform = CGAffineTransformMakeScale(1, 1);
        if (self.isAdsorb) {
            [self adsotbEffect];
        }
    }
    [sender setTranslation:CGPointZero inView:self];
}

- (void)adsotbEffect{
    CGFloat pt_x    = self.frame.origin.x;
    CGFloat pt_y    = self.frame.origin.y;
    CGFloat view_W  = self.frame.size.width;
    CGFloat view_H  = self.frame.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat space_E = 60;
    if (pt_x < space_E) {
        pt_x = 0;
    }else if(pt_x > screenW-view_W-space_E){
        pt_x = screenW-view_W;
    }
    if (pt_y < space_E) {
        pt_y = 0;
    }else if (pt_y > screenH-view_H-space_E){
        pt_y = screenH-view_H;
    }else{
        if (pt_x < (screenW-view_W)/2) {
            pt_x = 0;
        }else{
            pt_x = screenW-view_W;
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(pt_x, pt_y, view_W, view_H);
    }];
}

/** 将要拖动 */
- (void)ys_willDrag{
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
}

/** 结束拖动 */
- (void)ys_endDrag{
    self.transform = CGAffineTransformMakeScale(1, 1);
}

//MARK: 杂项
/** 根据name获取手势 */
- (UIGestureRecognizer *)ys_gestureRecognierWithName:(NSString *)name{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture.name isEqualToString:name]) {
            return gesture;
        }
    }
    return nil;
}

- (void)ys_setGestureRecoginzerEnable:(BOOL)isEnable exceptName:(NSString *)name{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture.name isEqualToString:name]) {
            [gesture setEnabled:!isEnable];
        }else{
            [gesture setEnabled:isEnable];
        }
    }
}

@end


