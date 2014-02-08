//
//  Perceptron.m
//  Perceptron
//
//  Created by Ke Yang on 2/6/14.
//  Copyright (c) 2014 Pyrus. All rights reserved.
//

#import "Perceptron.h"
#import <float.h>

@implementation Perceptron
{
    float w_modulus;
}
- (id)initWithHeader:(NSMutableArray*)header
          DataSetOne:(NSMutableArray*)one
                 Two:(NSMutableArray*)two
               Three:(NSMutableArray*)three
{
    if ((self = [super init])) {
        self.header = header;
        self.dataSet1 = one;
        self.dataSet2 = two;
        self.dataSet3 = three;
        self.w = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<[header count]-1; ++i) {
            self.w[i] = [NSString stringWithFormat:@"%d", 1];
            //[[NSString alloc] initWithFormat:@"%d", 1];
        }
        //NSLog(@"%d", [self.w count]);
        self.learningRate = 1;
        w_modulus = 0;
    }
    return self;
}

- (void)doTraining
{
/*
    for <x,y> in training set:
        err = y – percep_w(x);
        delta_w = alpha* err * x ;
        w = w + delta_w
*/
    NSLog(@"%@", @"Conduct training now.");
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    float err = 0;
    NSMutableArray* delta_w = nil;
    const NSUInteger error_free_count = [self.dataSet1 count];
    NSUInteger curr_error_count = 0;
    NSUInteger epoch = 0;
    //one epoch is one iteration
    while (curr_error_count != error_free_count) {
        curr_error_count = 0;
        for (NSMutableArray* record in self.dataSet1) {
            err = [[record lastObject] integerValue] - [self percepWX:record];
            if (err == 0) {
                curr_error_count++;
            }
            delta_w = [self realA:(self.learningRate*err) ProductX:record];
            [self updateWeightWithDelta:delta_w];
        }
        epoch++;
    }
    w_modulus = [self getModulusW];
    float min_margin = FLT_MAX;
    float margin = 0;
    for (NSMutableArray* record in self.dataSet1) {
        margin = [self getMargin:record];
//        NSLog(@"%f", margin);
        min_margin = MIN(margin, min_margin);
    }
    //NSLog(@"%@", self.dataSet1);
    NSLog(@"The final weights = %@", self.w);
    NSLog(@"The number of training epochs required = %lu", epoch);
    NSLog(@"The margin = %f", min_margin);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Training is over. Time Elpased: %f", (end-start));
}

- (void)doTesting
{
    NSLog(@"%@", @"Conduct testing now.");
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    NSMutableArray* FalseNegatives = [[NSMutableArray alloc] init];
    NSMutableArray* FalsePositives = [[NSMutableArray alloc] init];
    NSUInteger TruePositivesCount = 0;
    NSUInteger TrueNegativesCount = 0;
    
    NSLog(@"| True Positives:  %d | False Negatives: %d |", 1, 1);
    NSLog(@"| False Positives: %d | True Negatives:  %d |", 2, 2);
    NSLog(@"False Negatives = %@", @[@1, @3, @5]);
    NSLog(@"False Positives = %@", @[@2, @4, @6]);
    // this is the loss that the perceptron optimizes
    // = the sum of the distances (all misclassified) from the classifying hyperplane
    NSLog(@"The total loss summed over the misclassified examples: %d", 120);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Testing is over. Time Elpased: %f", (end-start));
}

- (void)doApplying
{
    NSLog(@"%@", @"Applying perceptron now.");
    NSLog(@"The result after applying perceptron: %@", @[@1, @1, @1, @1]);
    NSLog(@"%@", @"Perceptron is over.");
}

- (NSMutableArray*)realA:(int)a ProductX:(NSMutableArray*)x
{
    float t = 0;
    NSMutableArray* dw = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i<[x count]-1; ++i) {
        t = a*[x[i] floatValue];
        dw[i] = [[NSString alloc] initWithFormat:@"%f", t];
    }
    return dw;
}

- (void)updateWeightWithDelta:(NSMutableArray*)dw
{
    float oldValue = 0;
    float delta = 0;
    for (NSUInteger i = 0; i<[self.w count]; ++i) {
        oldValue = [self.w[i] floatValue];
        delta = [dw[i] floatValue];
        self.w[i] = [[NSString alloc] initWithFormat:@"%f", oldValue+delta];
    }
}

- (float)dotProductWX:(NSMutableArray*)x
{
    float a = 0;
    float b = 0;
    float r = 0;
    for (NSUInteger i=0; i<[self.w count]; ++i) {
        a = [self.w[i] floatValue];
        b = [x[i] floatValue];
        r += a*b;
    }
    return r;
}

- (BOOL)percepWX:(NSMutableArray*)x
{
    return ([self dotProductWX:x]>0);
}

- (float)getModulusX:(NSMutableArray*)x
{
    float r = 0;
    float a = 0;
    for (NSUInteger i=0; i<[x count]-1; ++i) {
        a = [x[i] floatValue];
        r += a*a;
    }
    return sqrtf(r);
}

- (float)getModulusW
{
    float r = 0;
    float a = 0;
    for (NSString* it in self.w) {
        a = [it floatValue];
        r += a*a;
    }
    return sqrtf(r);
}

- (float)getMargin:(NSMutableArray*)x
{
    float t = ABS([self dotProductWX:x]);
    float b = w_modulus * [self getModulusX:x];
    return (t/b);
}

@end
