//
//  ImageDataUtils.m
//  CoreImage
//
//  Created by ARGlass on 2017/8/14.
//  Copyright © 2017年 organization. All rights reserved.
//

#import "ImageDataUtils.h"


#define F1 0.0947416
#define F2 0.118318
#define F5 0.147761

@implementation ImageDataUtils

+ (void)handleGray:(UInt32 *)data width:(NSInteger)width height:(NSInteger)height {
    
    UInt32 *currentPixel = data;
    
    for (NSUInteger j = 0; j < height; j++)
    {
        for (NSUInteger i = 0; i < width; i++)
        {
            UInt32 gray = 0.299 * R(*currentPixel) + 0.587 * G(*currentPixel) + 0.114 * B(*currentPixel);
            *currentPixel = RGBMAKE(gray, gray, gray, A(*currentPixel));
            currentPixel++;
        }
    }

}


/**
 处理成骰子的样子，由于没有图片，所以用纯色模拟,用图片效果更佳
 只是为了传播思想，not code
 
 颜色范围为0-255, 4等份，255/4= 63.78~64
 取中间偏上的值，第一个取 50
              第二个取 110
              第三个取 170
              第四个取 130
 
 @param data 数据
 @param width 宽
 @param height 高
 */
+ (void)handleDice:(UInt32 *)data width:(NSInteger)width height:(NSInteger)height {
    
    NSInteger widthNumber = width / 16;
    NSInteger heightNumber = height / 16;
    
    for (NSInteger j = 0 ; j < heightNumber; j ++) {
        for (NSInteger i = 0; i < widthNumber; i ++) {
            //获取16*16的像素点，取出其中的数值，然后计算平均值，或者其他算法，我这儿简单的取平均值
            
            UInt32 *px = data + i*16 + j * 16 * width;
            UInt32 totalInt = *px;
            for (NSInteger k = 0; k < 16; k++) {
                for (NSInteger t = 0; t < 16; t++) {
                    totalInt += *(px + k * width + t);
                    totalInt /= 2;
                }
            }
            
            UInt32 resultPix = totalInt;
            UInt32 currentResult = 0;
            UInt32 tempPix = (R(resultPix) + G(resultPix) + B(resultPix)) / 3;
            
            if (tempPix < 64) {
                currentResult = 50;
            } else if(tempPix < 128) {
                currentResult = 110;
            } else if (tempPix < 192) {
                currentResult = 170;
            } else {
                currentResult = 130;
            }
            for (NSInteger k = 0; k < 16; k++) {
                for (NSInteger t = 0; t < 16; t++) {
                   *(px + k * width + t) = RGBMAKE(currentResult, currentResult, currentResult, A(*(px + k * width + t)));
                }
            }
        }
    }
    
    //多余剩下的像素点，总有不被16整除的情况，也顺便处理一下
//    NSInteger lessWidth = width - widthNumber * 16;
//    NSInteger lessHeight = height - heightNumber * 16;
    
}


/**
 高斯模糊效果
 
 模糊原理：
 
 x5 =
 
 F1*x1  +  F2*x2  +  F1*x3   +
 F2*x4  +  F5*x5  +  F2*x6   +
 F1*x7  +  F2*x8  +  F1*x9

 @param data 数据
 @param width 宽
 @param height 高
 */
+ (void)handleSlur:(UInt32 *)data width:(NSInteger)width height:(NSInteger)height {
    
    UInt32 *currentX = data;
    for (NSInteger j = 0; j < height; j ++) {
        for (NSInteger i = 0; i < width; i ++) {
            
            *currentX = [ImageDataUtils calcuteWidth:width height:height x:i y:j currentX:currentX];
            currentX += 1;
        }
    }
}

+ (UInt32)calcuteWidth:(NSInteger)width height:(NSInteger)height x:(NSInteger)x y:(NSInteger)y currentX:(UInt32 *)currentPix {
    
    UInt32 RValue = 0;
    UInt32 GValue = 0;
    UInt32 BValue = 0;
    UInt32 AValue = A(*currentPix);
    
    UInt32 *f0 = currentPix - (y<=0?0:width) - (x<=0?0:1);
    UInt32 *f1 = f0 + 1;
    UInt32 *f2 = x+1>=width ? f1 : f1 + 1;
    UInt32 *f3 = x - 1 > 0? currentPix - 1 : currentPix;
    UInt32 *f4 = currentPix;
    UInt32 *f5 = x+1<width?currentPix + 1:currentPix;
    UInt32 *f6 = currentPix + (y==height-1?0:width) - (x<=0?0:1);
    UInt32 *f7 = f6 + 1;
    UInt32 *f8 = x+1 >= width ? f7 :f7 + 1;
    
    RValue = R(*f0)*F1 + R(*f1) * F2 + R(*f2) * F1 + R(*f3) * F2 + R(*f4) * F5 + R(*f5) * F2 + R(*f6) * F1 + R(*f7) * F2 + R(*f8) * F1;
    
    GValue = G(*f0)*F1 + G(*f1) * F2 + G(*f2) * F1 + G(*f3) * F2 + G(*f4) * F5 + G(*f5) * F2 + G(*f6) * F1 + G(*f7) * F2 + G(*f8) * F1;
    
    BValue = B(*f0)*F1 + B(*f1) * F2 + B(*f2) * F1 + B(*f3) * F2 + B(*f4) * F5 + B(*f5) * F2 + B(*f6) * F1 + B(*f7) * F2 + B(*f8) * F1;
    
    return RGBMAKE(RValue, GValue, BValue, AValue);
}

@end
