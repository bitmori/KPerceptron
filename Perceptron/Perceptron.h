//
//  Perceptron.h
//  Perceptron
//
//  Created by Ke Yang on 2/6/14.
//  Copyright (c) 2014 Pyrus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Perceptron : NSObject

@property(strong, nonatomic) NSMutableArray* header;
@property(strong, nonatomic) NSMutableArray* dataSet1;
@property(strong, nonatomic) NSMutableArray* dataSet2;
@property(strong, nonatomic) NSMutableArray* dataSet3;
@property(strong, nonatomic) NSMutableArray* dataSet1X;
@property(strong, nonatomic) NSMutableArray* dataSet2X;
@property(strong, nonatomic) NSMutableArray* dataSet3X;
@property(strong, nonatomic) NSMutableArray* dataSet4;
@property(strong, nonatomic) NSMutableArray* dataSet5;
@property(strong, nonatomic) NSMutableArray* dataSet6;
@property(strong, nonatomic) NSMutableArray* w;
@property(strong, nonatomic) NSMutableArray* maxElement;
@property(assign, nonatomic) NSInteger learningRate;
@property(assign, nonatomic) float theta;

- (id)initWithHeader:(NSMutableArray*)header DataSetOne:(NSMutableArray*)one Two:(NSMutableArray*)two Three:(NSMutableArray*) three;
- (void)Execute:(NSUInteger)mode;
- (void)doTraining:(NSMutableArray*)DataSet;
- (void)doTesting:(NSMutableArray*)DataSet;
- (void)doApplying:(NSMutableArray*)DataSet;
- (void)findMaxElement;
- (void)normalize;
@end
