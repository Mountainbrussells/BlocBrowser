//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Ben Russell on 10/12/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesoneFloatingToolbarDelegate <NSObject>

@optional

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolBar buttonTapped:(UIButton *)button;
-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolBar didtryToPanWithoffset:(CGPoint)offset;
-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolBar didTryToScale:(CGFloat)scale;


@end

@interface AwesomeFloatingToolbar : UIView

-(instancetype) initWithFourTitles:(NSArray *)titles;

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <AwesoneFloatingToolbarDelegate> delegate;

@end
