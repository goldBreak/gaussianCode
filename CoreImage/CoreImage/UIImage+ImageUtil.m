//
//  UIImage+ImageUtil.m
//  CoreImage
//
//  Created by ARGlass on 2017/8/14.
//  Copyright © 2017年 organization. All rights reserved.
//

#import "UIImage+ImageUtil.h"
#import "ImageDataUtils.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (ImageUtil)


/**
 原理就是将一个像素点的R，G，B分量变成他们的平均值，或者利用公式gray = 0.299 * R + 0.587 * G + 0.114 * B,公式是人类眼睛对于R,G,B各个分量的敏感度的不同，而做出来的公式，具体请百度、谷歌
 @return 11
 */
- (UIImage *)handleGray {
    //获取句柄
    CGImageRef  newImage = [self CGImage];
    //获取宽高
    NSUInteger width  = CGImageGetWidth(newImage);
    NSUInteger height = CGImageGetHeight(newImage);
    
    UInt32 * pixs = NULL;
    pixs = (UInt32 *)calloc(width * height, sizeof(UInt32));
    CGColorSpaceRef colospace =  CGColorSpaceCreateDeviceRGB();
    //创建上下文
    CGContextRef context = CGBitmapContextCreate(pixs,
                                                 width,
                                                 height,
                                                 8,
                                                 4 * width,
                                                 colospace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    //上下文绘制
    CGContextDrawImage(context, CGRectMake(0,0, width, height), newImage);
    //处理像素点
    [ImageDataUtils handleGray:pixs width:width height:height];
    
    //根据上下文创建image句柄
    CGImageRef newCGimageREF = CGBitmapContextCreateImage(context);
    //释放内存
    CGColorSpaceRelease(colospace);
    CGContextRelease(context);
    free(pixs);
    
    //获取成为UIimage
    UIImage * outPutImage = [UIImage imageWithCGImage:newCGimageREF];
    
    //返回信息
    return outPutImage;
}


- (UIImage *)diceDrawImage {
    
    CGImageRef imageRef = [self CGImage];
    
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UInt32 *pixs = (UInt32 *)calloc(width * height, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(pixs, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    //处理像素点
    [ImageDataUtils handleDice:pixs width:width height:height];
    
    CGImageRef newCgimage = CGBitmapContextCreateImage(context);
    UIImage *outputImage = [UIImage imageWithCGImage:newCgimage];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return outputImage;
}

- (UIImage *)gaussiasImage {
    CGImageRef imageRef = [self CGImage];
    
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UInt32 *pixs = (UInt32 *)calloc(width * height, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(pixs, width, height, 8, 4*width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    //处理像素点
    [ImageDataUtils handleSlur:pixs width:width height:height];
    
    CGImageRef newCgimage = CGBitmapContextCreateImage(context);
    UIImage *outputImage = [UIImage imageWithCGImage:newCgimage];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return outputImage;
}

@end
