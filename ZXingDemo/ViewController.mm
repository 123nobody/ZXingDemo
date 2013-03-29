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

#import "AVCamViewController.h"

//生成二维码
#import "QREncoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10.f, 10.f, 300.f, 200.f)];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:self.textView];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"ZXing扫描器" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(10.f, 240.f, 140.f, 50.f)];
    [button1 addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"自定义扫描器" forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(170.f, 240.f, 140.f, 50.f)];
    [button2 addTarget:self action:@selector(pressButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"从相册选择" forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(10.f, 310.f, 140.f, 50.f)];
    [button3 addTarget:self action:@selector(pressButton3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setTitle:@"生成二维码" forState:UIControlStateNormal];
    [button4 setFrame:CGRectMake(170.f, 310.f, 140.f, 50.f)];
    [button4 addTarget:self action:@selector(pressButton4:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *transparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transparentButton addTarget:self action:@selector(prassTransparentButton:) forControlEvents:UIControlEventTouchUpInside];
    [transparentButton setFrame:self.view.bounds];
    transparentButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transparentButton];
    [self.view sendSubviewToBack:transparentButton];
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
    CustomViewController *vc = [[CustomViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)pressButton3:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)pressButton4:(UIButton *)button
{
    int qrcodeImageDimension = 250;
    
    //the string can be very long
    NSString *aVeryLongURL = self.textView.text;
    
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:aVeryLongURL];
    
    //then render the matrix
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    
    //put the image into the view
    UIImageView* qrcodeImageView = [[UIImageView alloc] initWithImage:qrcodeImage];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressBackButton:)];
    [vc.navigationItem setRightBarButtonItem:rightButton];
    [vc.view addSubview:qrcodeImageView];
    [qrcodeImageView setCenter:vc.view.center];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)pressBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)prassTransparentButton:(UIButton *)button
{
    [self.textView resignFirstResponder];
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
    self.textView.text = result;
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

#pragma mark - CustomViewControllerDelegate

- (void)customViewController:(CustomViewController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{[self outPutResult:result];}];
    
}

- (void)customViewControllerDidCancel:(CustomViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"取消扫描！退出扫描器！");}];    
}

#pragma mark - ZXingDelegate

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{[self outPutResult:result];}];    
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"cancel!");}];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{[self decodeImage:image];}];    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
