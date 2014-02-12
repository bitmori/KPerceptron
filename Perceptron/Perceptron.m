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
            [self.w addObject:[[NSString alloc] initWithFormat:@"%d", 1]];
        }
        self.theta = 1;
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
    NSInteger err = 0;
    NSMutableArray* delta_w = nil;
    const NSUInteger error_free_count = [self.dataSet1 count];
    NSUInteger curr_error_free_count = 0;
    NSUInteger epoch = 0;
    //one epoch is one iteration
    while (curr_error_free_count != error_free_count) {
        curr_error_free_count = 0;
        for (NSMutableArray* record in self.dataSet1) {
            err = [[record lastObject] integerValue] - [self percepWX:record];
            if (err == 0) {
                curr_error_free_count++;
            }
            delta_w = [self realA:(self.learningRate*err) ProductX:record];
            [self updateThresholdWithErr:err];
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
    NSLog(@"The final weights = %@", self.w);
    NSLog(@"The threshold = %f", self.theta);
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
    int err = 0;
    BOOL label = 0;
    BOOL percept = 0;
    
    // testing using ds1
    for (NSMutableArray* record in self.dataSet1) {
        label = [[record lastObject] boolValue];
        percept = [self percepWX:record];
        err = label - percept;
        switch (err) {
            case -1:
                //FP
                [FalsePositives addObject:record];
                break;
            case 0:
                if (label) {
                    //+
                    TruePositivesCount++;
                } else {
                    //-
                    TrueNegativesCount++;
                }
                break;
            case 1:
                //FN
                [FalseNegatives addObject:record];
                break;
            default:
                NSLog(@"ERROR: %@", @"err was assigned an illegal value.");
                break;
        }
    }
    // testing using ds2
    for (NSMutableArray* record in self.dataSet2) {
        label = [[record lastObject] boolValue];
        percept = [self percepWX:record];
        err = label - percept;
        switch (err) {
            case -1:
                //FP
                [FalsePositives addObject:record];
                break;
            case 0:
                if (label) {
                    //+
                    TruePositivesCount++;
                } else {
                    //-
                    TrueNegativesCount++;
                }
                break;
            case 1:
                //FN
                [FalseNegatives addObject:record];
                break;
            default:
                NSLog(@"ERROR: %@", @"err was assigned an illegal value.");
                break;
        }
    }

    NSLog(@"| True Positives:  %lu | False Negatives: %lu |", (unsigned long)TruePositivesCount, [FalseNegatives count]);
    NSLog(@"| False Positives: %lu | True Negatives:  %lu |", (unsigned long)[FalsePositives count], TrueNegativesCount);
    NSLog(@"False Negatives = %@", FalseNegatives);
    NSLog(@"False Positives = %@", FalsePositives);
    float loss = 0;
    for (NSMutableArray* it in FalseNegatives) {
        loss+=[self getLoss:it withErr:1];
    }
    for (NSMutableArray* it in FalsePositives) {
        loss+=[self getLoss:it withErr:-1];
    }
    // this is the loss that the perceptron optimizes
    // = the sum of the distances (all misclassified) from the classifying hyperplane
    NSLog(@"The total loss summed over the misclassified examples: %f", loss);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Testing is over. Time Elpased: %f", (end-start));
}

- (void)doApplying
{
    NSLog(@"%@", @"Applying perceptron now.");
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];

    NSMutableArray* result = [[NSMutableArray alloc] init];
    BOOL percept = NO;
    for (NSMutableArray* record in self.dataSet3) {
        percept = [self percepWX:record];
        NSString * perceptStr = [[NSString alloc] initWithFormat:@"%d", (int)percept];
        [result addObject:perceptStr];
    }
    //The result after applying perceptron: (0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0);
    NSLog(@"The result after applying perceptron: %@", result);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Perceptron is over. Time Elpased: %f", (end-start));
}

- (NSMutableArray*)realA:(NSInteger)a ProductX:(NSMutableArray*)x
{
    float t = 0;
    NSMutableArray* dw = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i<[x count]-1; ++i) {
        t = a*[x[i] floatValue];
        [dw addObject:[[NSString alloc] initWithFormat:@"%f", t]];
    }
    return dw;
}

- (void)updateThresholdWithErr:(NSInteger)err
{
    self.theta += self.learningRate*err*(-1);
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
    r -= self.theta;
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
    r += self.theta*self.theta;
    return sqrtf(r);
}

- (float)getMargin:(NSMutableArray*)x
{
    float t = ABS([self dotProductWX:x]);
    float b = w_modulus;// * [self getModulusX:x];
    return (t/b);
}

- (float)getLoss:(NSMutableArray*)x withErr:(NSInteger)err
{
    float loss = ABS([self dotProductWX:x]);
    loss*=err;
    loss*=-1;
    return loss;
}

@end
