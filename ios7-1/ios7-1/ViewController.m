//
//  ViewController.m
//  ios7-1
//
//  Created by Swapnil Ratnaparkhi on 01/10/13.
//  Copyright (c) 2013 Swapnil Ratnaparkhi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@end

@implementation ViewController


UIDynamicAnimator* _animator;
UIGravityBehavior* _gravity;
UICollisionBehavior* _collision;
BOOL _firstContact;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIView* square = [[UIView alloc] initWithFrame:
                      CGRectMake(100, 50, 100, 50)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    
    UIView* barrier = [[UIView alloc]
                       initWithFrame:CGRectMake(0, 200, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    
    UIView* barrier1 = [[UIView alloc]
                       initWithFrame:CGRectMake(200, 400, 130, 20)];
    barrier1.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier1];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[square]]; [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[square]];
    _collision.translatesReferenceBoundsIntoBoundary = YES; [_animator addBehavior:_collision];
    
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x + barrier.frame.size.width,
                                    barrier.frame.origin.y);
    CGPoint leftEdge = CGPointMake(barrier1.frame.origin.x + barrier1.frame.size.width,
                                    barrier1.frame.origin.y);
    
    [_collision addBoundaryWithIdentifier:@"barrier"fromPoint:barrier.frame.origin toPoint:rightEdge];
    [_collision addBoundaryWithIdentifier:@"barrier1"fromPoint:barrier1.frame.origin toPoint:leftEdge];
    
    _collision.collisionDelegate = self;
    
    UIDynamicItemBehavior* itemBehaviour =
    [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
    itemBehaviour.elasticity = 0.6;
    [_animator addBehavior:itemBehaviour];
    
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    UIView* view = (UIView*)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3
                     animations:^{ view.backgroundColor = [UIColor grayColor];
    }];
    
    if (!_firstContact) {
        _firstContact = YES;
        UIView* square = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 100, 100)];
        square.backgroundColor = [UIColor grayColor];
        [self.view addSubview:square];
        [_collision addItem:square];
        [_gravity addItem:square];
        UIAttachmentBehavior* attach = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:square];
        [_animator addBehavior:attach];
                                        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
