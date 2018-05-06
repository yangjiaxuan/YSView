//
//  UIView+YSDrag.h
//  YSView
//
//  Created by 杨森 on 2018/5/5.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YSDrag)

/** 是否有吸附效果 */
@property(assign, nonatomic, readonly)BOOL isAdsorb;

/** 准备拖动
 * isAdsorb:是否有吸附效果
 */
- (void)ys_dragAdsorb:(BOOL)isAdsorb;
/** 禁止拖动 */
- (void)ys_noDrag;

@end
