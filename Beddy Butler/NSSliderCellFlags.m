//
//  NSSliderCellFlags.m
//  Beddy Butler
//
//  Created by David Garces on 20/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

#import "NSSliderFlags.h"

@implementation NSSliderCell (FlagsAccessor)

- (BOOL)isPressed
{
    return self->_scFlags.isPressed == 1;
}
@end