//
//  ViewController.h
//  OtB-Draw
//
//  Created by Katharina Spiel on 09/04/15.
//  Copyright (c) 2015 OutsideTheBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    CGPoint lastPoint;
    CGPoint lastPoint2;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    CGFloat pRed;
    CGFloat pGreen;
    CGFloat pBlue;
    BOOL mouseSwiped;
    BOOL eraserOn;
    NSMutableArray *imageStates;
}


@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UIImageView *drawImage;



@property (weak, nonatomic) IBOutlet UIButton *save;

@property (weak, nonatomic) IBOutlet UIButton *reset;

@property (weak, nonatomic) IBOutlet UIButton *load;



@property (weak, nonatomic) IBOutlet UISlider *brushControl;

@property (weak, nonatomic) IBOutlet UISlider *opacityControl;

@property (weak, nonatomic) IBOutlet UIImageView *opacityPreview;

@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;

@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *opacityValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *eraserLabel;


- (IBAction)pencilPressed:(id)sender;

- (IBAction)eraserPressed:(id)sender;

- (IBAction)sliderChanged:(id)sender;

- (IBAction)undo:(id)sender;

- (IBAction)load:(id)sender;


- (void) updateBrushImage;

- (void) updateOpacityImage;

- (void) updateFeedbackImages;


@end

