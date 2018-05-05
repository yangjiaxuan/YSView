//
//  ViewController.m
//  YSView
//
//  Created by 杨森 on 2018/5/5.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YSDrag.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIView *view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    view.backgroundColor = [UIColor blueColor];
    view.layer.cornerRadius = 5;
    [self.view addSubview:view];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
    [view addGestureRecognizer:pan];
    
    [view ys_dragAdsorb:NO];
}

- (void)panAction{
    NSLog(@"=== pan ===");
}

- (void)tap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"=== tap B ===");
    }
}


@end
