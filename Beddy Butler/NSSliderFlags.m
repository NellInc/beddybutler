//
//  NSSliderFlags.m
//  Beddy Butler
//
//  Created by David Garces on 20/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

#import "NSSliderFlags.h"

@interface NSSliderCell (FlagsAccessor)

@property (nonatomic) BOOL isPressed;
//@synthesize isPressed = _isPressed;

@end

@implementation NSSlider (FlagsAccessor)

- (BOOL)isPressed
{
    NSSliderCell *cell = self.cell;
    
    return cell.isPressed;
}

- (void)setIsPressed:(BOOL)newValue
{
    NSSliderCell *cell = self.cell;
    cell.isPressed = newValue;

}

@end

@implementation NSSliderCell (FlagsAccessor)

- (BOOL)isPressed
{
    return self->_scFlags.isPressed == 1;
}

- (void)setIsPressed:(BOOL)newValue
{
    self->_scFlags.isPressed = newValue;
}

@end

