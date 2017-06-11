//
//  Animaition.h
//  CarApp
//
//  Created by 管理员 on 2017/6/4.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^AnimationFinisnedBlock)(BOOL isFinished);

@interface Animaition : NSObject
+(instancetype)shareTool;


- (void)startAnimationandView:(UIView *)animationView finishBlock:(AnimationFinisnedBlock)completion;
@end
