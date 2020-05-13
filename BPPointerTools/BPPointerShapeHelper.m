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

#define var __auto_type

typedef NS_ENUM(NSUInteger, BPPointerShapeOption) {
    BPPointerShapeNoShape,
    BPPointerShapeRoundedRect,
    BPPointerShapeBezierPath
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
    BPPointerShapeHelper *helper = [[BPPointerShapeHelper alloc] initWithView:view
                                                          roundedRectProvider:provider];

    [view addInteraction:[[UIPointerInteraction alloc] initWithDelegate:helper]];

    objc_setAssociatedObject(view, "BPPointerShapeHelper", helper, OBJC_ASSOCIATION_RETAIN);
}

+ (void)setBezierPathPointerShapeProviderForView:(UIView * _Nonnull)view
                                   usingProvider:(void (^)(UIBezierPath **))provider;
{
    BPPointerShapeHelper *helper = [[BPPointerShapeHelper alloc] initWithView:view
                                                           bezierPathProvider:provider];

    [view addInteraction:[[UIPointerInteraction alloc] initWithDelegate:helper]];

    objc_setAssociatedObject(view, "BPPointerShapeHelper", helper, OBJC_ASSOCIATION_RETAIN);
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setPointerShapeOption:BPPointerShapeNoShape];
    }
    return self;
}

- (id)initWithView:(UIView * _Nonnull)view bezierPathProvider:(void (^)(UIBezierPath * _Nullable * _Nullable))provider
{
    self = [super init];
    if (self) {
        [self setBezierPathPointerShapeProvider:provider];
        [self setPointerShapeOption:BPPointerShapeBezierPath];
    }
    return self;
}

- (id)initWithView:(UIView * _Nonnull)view roundedRectProvider:(void (^)(CGRect * _Nonnull, CGFloat * _Nonnull))provider
{
	self = [super init];
    if (self) {
        [self setRoundedRectPointerShapeProvider:provider];
        [self setPointerShapeOption:BPPointerShapeRoundedRect];
    }
    return self;
}

- (UIPointerStyle *)pointerInteraction:(UIPointerInteraction *)interaction styleForRegion:(UIPointerRegion *)region
{
    switch (_pointerShapeOption) {
        case BPPointerShapeRoundedRect: {
            if (_roundedRectPointerShapeProvider != nil) {
                CGRect rect = CGRectZero;
                CGFloat radius = 0;

                _roundedRectPointerShapeProvider(&rect, &radius);

                return [self pointerStyleWithShape:[UIPointerShape shapeWithRoundedRect:rect cornerRadius:radius]
								   interactionView:[interaction view]];
            }
            break;
        }

        case BPPointerShapeBezierPath: {
            if (_bezierPathPointerShapeProvider != nil) {
                UIBezierPath *path = nil;

                _bezierPathPointerShapeProvider(&path);

                if (path == nil) { return nil; }

                return [self pointerStyleWithShape:[UIPointerShape shapeWithPath:path]
								   interactionView:[interaction view]];
            }
            break;
        }

        default: {
            return [self pointerStyleWithShape:nil interactionView:[interaction view]];
        }
    }

    return nil;
}

- (UIPointerStyle *)pointerStyleWithShape:(UIPointerShape * _Nullable)shape interactionView:(UIView *)interactionView
{
    UITargetedPreview *liftPreview = [self liftPointerEffectPreviewWithInteractionView:interactionView];
    if (liftPreview != nil) {
        var effect = [UIPointerLiftEffect effectWithPreview:liftPreview];
        return [UIPointerStyle styleWithEffect:effect shape:shape];
    }

    UITargetedPreview *highlightPreview = [self highlightPointerEffectPreviewWithInteractionView:interactionView];
    if (highlightPreview != nil) {
        var effect = [UIPointerHighlightEffect effectWithPreview:highlightPreview];
        return [UIPointerStyle styleWithEffect:effect shape:shape];
    }

    if (shape != nil) {
        return [UIPointerStyle styleWithShape:shape constrainedAxes:UIAxisNeither];
    }

    return nil;
}

- (UITargetedPreview *)highlightPointerEffectPreviewWithInteractionView:(UIView *)interactionView
{
    return nil;
}

- (UITargetedPreview *)liftPointerEffectPreviewWithInteractionView:(UIView *)interactionView
{
    return nil;
}

@end
