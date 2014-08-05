//
//  ContactUsVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsVC : UIViewController<UITextViewDelegate>
- (IBAction)btnSend:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *contactForm;
@property (strong,nonatomic) NSString *userID;

@end
