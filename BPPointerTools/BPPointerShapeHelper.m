//
//  BPPointerShapeHelper.m
//  ButtonPointerShapeCrash
//
//  Created by Bruno Philipe on 12.05.20.
//  Copyright © 2020 Bruno Philipe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "BPPointerShapeHelper.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, BPPointerShapeOption) {
    BPPointerShapeRoundedRect, BPPointerShapeBezierPath
};

@interface BPPointerShapeHelper ()

@property (nonatomic) BPPointerShapeOption pointerShapeOption;

@property (nonatomic, copy, nullable) void (^roundedRectPointerShapeProvider)(CGRect * _Nonnull, CGFloat * _Nonnull);
@property (nonatomic, copy, nullable) void (^bezierPathPointerShapeProvider)(UIBezierPath **);

@end

@implementation BPPointerShapeHelper

+ (void)setRoundedRectPointerShapeProviderForView:(UIView * _Nonnull)view
                                    usingProvider:(void (^)(CGRect * _Nonnull, CGFloat * _Nonnull))provider;
{
    BPPointerShapeHelper *helper = [[BPPointerShapeHelper alloc] init];
    [helper setRoundedRectPointerShapeProvider:provider];
    [helper setPointerShapeOption:BPPointerShapeRoundedRect];

    [view addInteraction:[[UIPointerInteraction alloc] initWithDelegate:helper]];

    objc_setAssociatedObject(view, "BPPointerShapeHelper", helper, OBJC_ASSOCIATION_RETAIN);
}

+ (void)setBezierPathPointerShapeProviderForView:(UIView * _Nonnull)view
                                   usingProvider:(void (^)(UIBezierPath **))provider;
{
    BPPointerShapeHelper *helper = [[BPPointerShapeHelper alloc] init];
    [helper setBezierPathPointerShapeProvider:provider];
    [helper setPointerShapeOption:BPPointerShapeBezierPath];

    [view addInteraction:[[UIPointerInteraction alloc] initWithDelegate:helper]];

    objc_setAssociatedObject(view, "BPPointerShapeHelper", helper, OBJC_ASSOCIATION_RETAIN);
}

- (UIPointerStyle *)pointerInteraction:(UIPointerInteraction *)interaction styleForRegion:(UIPointerRegion *)region
{
    switch (_pointerShapeOption) {
        case BPPointerShapeRoundedRect: {
            if (_roundedRectPointerShapeProvider != nil) {
                CGRect rect = CGRectZero;
                CGFloat radius = 0;

                _roundedRectPointerShapeProvider(&rect, &radius);

                return [UIPointerStyle styleWithShape:[UIPointerShape shapeWithRoundedRect:rect cornerRadius:radius]
                                      constrainedAxes:UIAxisNeither];
            }
            break;
        }

        case BPPointerShapeBezierPath: {
            if (_bezierPathPointerShapeProvider != nil) {
                UIBezierPath *path = nil;

                _bezierPathPointerShapeProvider(&path);

                if (path == nil) { return nil; }

                return [UIPointerStyle styleWithShape:[UIPointerShape shapeWithPath:path]
                                      constrainedAxes:UIAxisNeither];
            }
        }
    }

    return nil;
}

@end
