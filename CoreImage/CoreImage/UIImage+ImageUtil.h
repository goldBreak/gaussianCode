//
//  UIImage+ImageUtil.h
//  CoreImage
//
//  Created by ARGlass on 2017/8/14.
//  Copyright © 2017年 organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtil)


/**
 将图片处理成为灰色的

 @return image
 */
- (UIImage *)handleGray;


/**
 骰子作画

 @return image
 */
- (UIImage *)diceDrawImage;


/**
 高斯模糊

 @return Image
 */
- (UIImage *)gaussiasImage;

@end
