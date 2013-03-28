//
//  ViewController.h
//  ZXingDemo
//
//  Created by Wei on 13-3-27.
//  Copyright (c) 2013年 Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <ZXingDelegate, DecoderDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *label;

@end
