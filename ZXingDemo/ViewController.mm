//
//  ViewController.m
//  ZXingDemo
//
//  Created by Wei on 13-3-27.
//  Copyright (c) 2013年 Wei. All rights reserved.
//

#import "ViewController.h"

#import <QRCodeReader.h>
//自定义需要用到
#import <Decoder.h>
#import <TwoDDecoderResult.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Scan - 简单" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(60.f, 240.f, 200.f, 50.f)];
    [button1 addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Scan - 自定义" forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(60.f, 310.f, 200.f, 50.f)];
    [button2 addTarget:self action:@selector(pressButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"Scan - 相册" forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(60.f, 380.f, 200.f, 50.f)];
    [button3 addTarget:self action:@selector(pressButton3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 20.f, 300.f, 200.f)];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.label];
}

- (void)pressButton1:(UIButton *)button
{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    widController.readers = readers;
    [self presentViewController:widController animated:YES completion:^{}];
}

- (void)pressButton2:(UIButton *)button
{
    
}

- (void)pressButton3:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)decodeImage:(UIImage *)image
{
    NSMutableSet *qrReader = [[NSMutableSet alloc] init];
    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
    [qrReader addObject:qrcoderReader];
    
    Decoder *decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    [decoder decodeImage:image];
}

- (void)outPutResult:(NSString *)result
{
    NSLog(@"result:%@", result);
    self.label.text = result;
}

#pragma mark - DecoderDelegate

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    [self outPutResult:result.text];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    [self outPutResult:[NSString stringWithFormat:@"解码失败！"]];
}

#pragma mark - ZXingDelegate

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    [self outPutResult:result];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    NSLog(@"cancel!");
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self decodeImage:image];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"output!");
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
