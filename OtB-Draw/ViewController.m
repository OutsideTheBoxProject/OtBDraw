//
//  ViewController.m
//  OtB-Draw
//
//  Created by Katharina Spiel on 09/04/15.
//  Copyright (c) 2015 OutsideTheBox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    eraserOn = false;
    
    [self updateFeedbackImages];
    
    imageStates = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pencilPressed:(id)sender {
    
    self.eraserLabel.text = @"";
    
    UIButton * PressedButton = (UIButton*)sender;
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 153.0/255.0;
            green = 153.0/255.0;
            blue = 153.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 0.0/255.0;
            green = 128.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 153.0/255.0;
            green = 225.0/255.0;
            blue = 85.0/255.0;
            break;
        case 6:
            red = 128.0/255.0;
            green = 229.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 212.0/255.0;
            green = 85.0/255.0;
            blue = 0.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
    
    [self updateFeedbackImages];
}


- (void) updateBrushImage {
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),25, 25);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 25, 25);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void) updateOpacityImage {
    UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),20.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),25, 25);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),25, 25);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void) updateFeedbackImages{
    [self updateBrushImage];
    [self updateOpacityImage];
}

- (IBAction)eraserPressed:(id)sender {
    
    if (eraserOn) {
        self.eraserLabel.text = @"";
        eraserOn = FALSE;
        
        red = pRed;
        green = pGreen;
        blue = pBlue;
        
    }
    else{
        pRed = red;
        pGreen = green;
        pBlue = blue;
    
        red = 255.0/255.0;
        green = 255.0/255.0;
        blue = 255.0/255.0;
        //opacity = 1.0;
    
        self.eraserLabel.text = @"On";
        eraserOn = true;
    }
}

- (IBAction)sliderChanged:(id)sender {
    
    UISlider * changedSlider = (UISlider*)sender;
    
    if(changedSlider == self.brushControl) {
        
        int sliderValue;
        sliderValue = lroundf(self.brushControl.value);
        [self.brushControl setValue:sliderValue animated:YES];
        
        brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", brush];
        
        [self updateBrushImage];
        
    } else if(changedSlider == self.opacityControl) {
        
        opacity = self.opacityControl.value;
        self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", opacity];
        
        [self updateOpacityImage];
    
    }
    
}

- (IBAction)undo:(id)sender {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    [imageStates removeLastObject];
    self.mainImage.image = imageStates.lastObject;
    //[imageStates addObject:self.mainImage.image.copy];
    UIGraphicsEndImageContext();
}

- (IBAction)load:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)save:(id)sender {

    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"In Bildergalerie Speichern", @"Abbrechen", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];

}

- (IBAction)reset:(id)sender {
    
    self.mainImage.image = nil;
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    
}
 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
  
    @autoreleasepool {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    
    
    //smoothing attempts
    
    float x = (currentPoint.x + lastPoint.x)/2;
    float y = (currentPoint.y + lastPoint.y)/2;

    CGPoint dir = currentPoint;
    dir.x -= lastPoint.x;
    dir.y -= lastPoint.y;
    
    float length = sqrt((float)(dir.x*dir.x) + (float)(dir.y*dir.y));
    x += (dir.x*3)/length;
    y += (dir.y*3)/length;
    
    
    CGContextAddCurveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y, lastPoint.x, lastPoint.y, x, y );
    
    //end of smoothing attempts
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    }
    
    
    lastPoint2 = lastPoint;
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawImage.image = nil;
    [imageStates addObject:self.mainImage.image.copy];
    if (imageStates.count > 20){
        [imageStates removeObjectAtIndex:0];
    }
    UIGraphicsEndImageContext();
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0)
        {
            UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO,0.0);
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
            UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Bild konnte nicht gespeichert werden.  Bitte versuche es noch einmal."  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Schliessen", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erfolg" message:@"Das Bild wurde erfolgreich in der Bildergalerie gespeichert"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Schliessen", nil];
        [alert show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.mainImage.image = image;
    [imageStates addObject:self.mainImage.image.copy];
    if (imageStates.count > 20){
        [imageStates removeObjectAtIndex:0];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

}

@end
