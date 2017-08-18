//
//  ImageDataUtils.h
//  CoreImage
//
//  Created by ARGlass on 2017/8/14.
//  Copyright © 2017年 organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataUtils : NSObject


/**
 处理成灰色图片

 @param data 数据
 @param width 宽
 @param height 高
 */
+ (void)handleGray:(UInt32 *)data width:(NSInteger)width height:(NSInteger)height;


/**
 骰子作画

 @param data 数据
 @param width 宽
 @param height 高
 */
+ (void)handleDice:(UInt32 *)data width:(NSInteger)width height:(NSInteger)height;


/**
 高斯模糊

 @param data 数据
 @param width 宽
 @param height 高
 */
+ (void)handleSlur:(UInt32 *)data width:(NSInteger)width height:(NSInteger)height;

@end
