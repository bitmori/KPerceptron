//
//  Perceptron.m
//  Perceptron
//
//  Created by Ke Yang on 2/6/14.
//  Copyright (c) 2014 Pyrus. All rights reserved.
//

#import "Perceptron.h"

@implementation Perceptron

- (id)initWithHeader:(NSMutableArray*)header DataSetOne:(NSMutableArray*)one Two:(NSMutableArray*)two Three:(NSMutableArray*) three
{
    if ((self = [super init])) {
        self.header = header;
        self.dataSet1 = one;
        self.dataSet2 = two;
        self.dataSet3 = three;
    }
    return self;
}

- (void)doTraining
{
    NSLog(@"%@", self.dataSet1);
}

- (void)doTesting
{
    NSLog(@"%@", self.dataSet1);
    NSLog(@"%@", self.dataSet2);
}

- (void)doApplying
{
    NSLog(@"%@", self.dataSet3);
}

@end
