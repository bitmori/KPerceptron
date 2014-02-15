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
        self.dataSet1X = [[NSMutableArray alloc] init];
        self.dataSet2X = [[NSMutableArray alloc] init];
        self.dataSet3X = [[NSMutableArray alloc] init];
        self.w = [[NSMutableArray alloc] init];
        self.maxElement = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<[header count]-1; ++i) {
            [self.w addObject:[[NSString alloc] initWithFormat:@"%d", 0]];
            [self.maxElement addObject:[[NSString alloc] initWithFormat:@"%d", 0]];
        }
        self.theta = 0;
        //NSLog(@"%d", [self.w count]);
        self.learningRate = 1;
        w_modulus = 0;
    }
    return self;
}

- (void)Execute:(NSUInteger)mode
{
    switch (mode) {
        case 1:
            NSLog(@"Conduct training on DataSet %d now.", 1);
            [self doTraining:self.dataSet1];
            NSLog(@"====================================================================");
            NSLog(@"Conduct testing on DataSet %d now.", 1);
            [self doTesting:self.dataSet1];
            NSLog(@"====================================================================");
            NSLog(@"Conduct testing on DataSet %d now.", 2);
            [self doTesting:self.dataSet2];
            NSLog(@"====================================================================");
            NSLog(@"Applying perceptron on DataSet %d now.", 3);
            [self doApplying:self.dataSet3];
            break;
        case 2:
            NSLog(@"Conduct training on DataSet %d now.", 2);
            [self doTraining:self.dataSet2];
            NSLog(@"====================================================================");
            NSLog(@"Conduct testing on DataSet %d now.", 2);
            [self doTesting:self.dataSet2];
            NSLog(@"====================================================================");
            NSLog(@"Conduct testing on DataSet %d now.", 1);
            [self doTesting:self.dataSet1];
            NSLog(@"====================================================================");
            NSLog(@"Applying perceptron on DataSet %d now.", 3);
            [self doApplying:self.dataSet3];
            break;
    }
}

- (void)doTraining:(NSMutableArray*)DataSet
{
/*
    for <x,y> in training set:
        err = y – percep_w(x);
        delta_w = alpha* err * x ;
        w = w + delta_w
*/

    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    NSInteger err = 0;
    NSMutableArray* delta_w = nil;
    const NSUInteger error_free_count = [DataSet count];
    NSUInteger curr_error_free_count = 0;
    NSUInteger epoch = 0;
    //one epoch is one iteration
    while (curr_error_free_count != error_free_count) {
        curr_error_free_count = 0;
        for (NSMutableArray* record in DataSet) {
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
    [self updateModulusW];
    float margin = [self getMargin:DataSet];
    NSLog(@"The final weights = %@", self.w);
    NSLog(@"The threshold = %f", self.theta);
    NSLog(@"The number of training epochs required = %lu", epoch);
    NSLog(@"The margin = %f", margin);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Training is over. Time Elpased: %f", (end-start));
}

- (void)doTesting:(NSMutableArray*)DataSet
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    NSMutableArray* FalseNegatives = [[NSMutableArray alloc] init];
    NSMutableArray* FalsePositives = [[NSMutableArray alloc] init];
    NSMutableArray* FalseNegativesIndex = [[NSMutableArray alloc] init];
    NSMutableArray* FalsePositivesIndex = [[NSMutableArray alloc] init];
    __block NSUInteger TruePositivesCount = 0;
    __block NSUInteger TrueNegativesCount = 0;
    
    [DataSet enumerateObjectsUsingBlock:^(NSMutableArray* record, NSUInteger idx, BOOL *stop) {
        BOOL label = [[record lastObject] boolValue];
        BOOL percept = [self percepWX:record];
        int err = label - percept;
        switch (err) {
            case -1:
                //FP
                [FalsePositives addObject:record];
                [FalsePositivesIndex addObject:[[NSString alloc] initWithFormat:@"%lu", idx]];
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
                [FalseNegativesIndex addObject:[[NSString alloc] initWithFormat:@"%lu", idx]];
                break;
            default:
                NSLog(@"ERROR: %@", @"err was assigned an illegal value.");
                break;
        }
    }];

    NSLog(@"| True Positives:  %lu | False Negatives: %lu |", (unsigned long)TruePositivesCount, [FalseNegativesIndex count]);
    NSLog(@"| False Positives: %lu | True Negatives:  %lu |", (unsigned long)[FalsePositivesIndex count], TrueNegativesCount);
    NSLog(@"False Negatives = %@", FalseNegativesIndex);
    NSLog(@"False Positives = %@", FalsePositivesIndex);
    float loss = 0;
    for (NSMutableArray* it in FalseNegatives) {
        loss+=[self getLoss:it withErr:1];
    }
    for (NSMutableArray* it in FalsePositives) {
        loss+=[self getLoss:it withErr:-1];
    }
    NSLog(@"The total loss summed over the misclassified examples: %f", loss);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Testing is over. Time Elpased: %f", (end-start));
}


- (void)doApplying:(NSMutableArray*)DataSet
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    BOOL percept = NO;
    for (NSMutableArray* record in DataSet) {
        percept = [self percepWX:record];
        NSString * perceptStr = [[NSString alloc] initWithFormat:@"%d", (int)percept];
        [result addObject:perceptStr];
    }
    NSLog(@"The result after applying perceptron: %@", result);
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"Perceptron is over. Time Elpased: %f", (end-start));
}

- (void)findMaxElement
{
    float elem = 0;
    float rec = 0;
    for (NSMutableArray* record in self.dataSet2) {
        for (NSUInteger i=0; i<[self.maxElement count]; i++) {
            elem = [self.maxElement[i] floatValue];
            rec = ABS([record[i] floatValue]);
            if (elem<rec) {
                self.maxElement[i] = [[NSString alloc] initWithFormat:@"%f", rec];
            }
        }
    }
}

- (void)normalize
{
    float value = 0;
    for (NSMutableArray* record in self.dataSet1) {
        NSMutableArray* nor = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<[self.maxElement count]; i++) {
            value = [record[i] floatValue];
            value /= [self.maxElement[i] floatValue];
            [nor addObject:[[NSString alloc] initWithFormat:@"%f", value]];
        }
        [self.dataSet1X addObject:nor];
    }
    for (NSMutableArray* record in self.dataSet2) {
        NSMutableArray* nor = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<[self.maxElement count]; i++) {
            value = [record[i] floatValue];
            value /= [self.maxElement[i] floatValue];
            [nor addObject:[[NSString alloc] initWithFormat:@"%f", value]];
        }
        [self.dataSet2X addObject:nor];
    }
    for (NSMutableArray* record in self.dataSet3) {
        NSMutableArray* nor = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<[self.maxElement count]; i++) {
            value = [record[i] floatValue];
            value /= [self.maxElement[i] floatValue];
            [nor addObject:[[NSString alloc] initWithFormat:@"%f", value]];
        }
        [self.dataSet3X addObject:nor];
    }
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

- (void)updateModulusW
{
    float r = 0;
    float a = 0;
    for (NSString* it in self.w) {
        a = [it floatValue];
        r += a*a;
    }
    r += self.theta*self.theta;
    w_modulus = ABS(sqrtf(r));
}


- (float)getMargin:(NSMutableArray*)dataSet
{
    float margin = FLT_MAX;
    for (NSMutableArray* x in dataSet) {
        margin = MIN(ABS([self dotProductWX:x])/w_modulus, margin);
    }
    return margin;
}

- (float)getLoss:(NSMutableArray*)x withErr:(NSInteger)err
{
    return ABS([self dotProductWX:x])/w_modulus;
}

@end
