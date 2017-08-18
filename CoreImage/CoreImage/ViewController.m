//
//  ViewController.m
//  CoreImage
//
//  Created by ARGlass on 2017/8/14.
//  Copyright © 2017年 organization. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageUtil.h"

#define Screen_width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    UIImage *image = [UIImage imageNamed:@"boot.jpg"];
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    UIImage *handleImage = [image gaussiasImage];
    
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    if (frame.size.width > Screen_width || frame.size.height > Screen_height) {
        
        CGFloat scale = frame.size.width / frame.size.height;
        
        if (frame.size.width > Screen_width ) {
            frame.size.width = Screen_width;
            frame.size.height = Screen_width / scale;
            
        } else if ( frame.size.height > Screen_height) {
            frame.size.height = Screen_height;
            frame.size.width = Screen_height * scale;
        }
    }
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:frame];
    imageV.image = handleImage;
    [self.view addSubview:imageV];
    
}


@end
