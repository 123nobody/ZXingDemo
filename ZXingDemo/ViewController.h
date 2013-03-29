//
//  ViewController.h
//  ZXingDemo
//
//  Created by Wei on 13-3-27.
//  Copyright (c) 2013年 Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import "CustomViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <ZXingDelegate, CustomViewControllerDelegate, DecoderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end
