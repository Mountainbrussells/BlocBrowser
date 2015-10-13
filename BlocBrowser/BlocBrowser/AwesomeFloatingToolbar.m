//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Ben Russell on 10/12/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentlabel;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) NSInteger colorIndex;


@end

@implementation AwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles
{
    
    self = [super init];
    
    if (self) {
        
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        
        for (NSString *currentTitle in self.currentTitles) {
            
            NSLog(@"%@", currentTitle);
            
            UIButton *label = [[UIButton alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; 
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThislabel = [self.colors objectAtIndex:currentTitleIndex];
            
            
            label.titleLabel.font = [UIFont systemFontOfSize:10];
            [label setTitle:titleForThisLabel forState:UIControlStateNormal];
            label.backgroundColor = colorForThislabel;
            [label addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            label.titleLabel.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        self.colorIndex = 1;
        
        for (UIButton *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressGesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
    
}

-(void) layoutSubviews{
    // set the frames for the 4 labels
    
    for (UIButton *thisLabel in self.labels) {
        
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1 so on top
            labelY = 0;
        } else {
            // 2 or 3 so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) {
            // 0 or 2 , so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        
    }
    
}


#pragma mark - Touch Handling

-(UIButton *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UIButton class]]) {
        return (UIButton *)subview;
    } else {
        return nil;
    }
    
}

-(IBAction)buttonTapped:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:buttonTapped:)]) {
        [self.delegate floatingToolbar:self buttonTapped:button];
    }
}



-(void) panFired:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New Translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didtryToPanWithoffset:)])
        {
            [self.delegate floatingToolbar:self didtryToPanWithoffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}
-(void) pinchFired:(UIPinchGestureRecognizer *)recognizer
{
    
    CGFloat scale = [recognizer scale];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToScale:)])
        {
            [self.delegate floatingToolbar:self didTryToScale:scale];
            
        }
        
        recognizer.scale = 1;
    }
}

-(void) longPressFired:(UILongPressGestureRecognizer *)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long Press Began");
        [self changeLabelColors:self.colorIndex];
    
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long Press Ended");
        self.colorIndex = ((self.colorIndex +1) % 4);
    }
    
    
   
    
    
}

-(void) changeLabelColors:(NSInteger)i
{
    
    for (UIButton* label in self.labels) {
        NSInteger currentColorIndex = (([self.labels indexOfObject:label] + i) % 4);
        label.backgroundColor = self.colors[currentColorIndex];
    }
    
    
}


#pragma mark - Button Enabling

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}


@end
