#import <Foundation/Foundation.h>
#import "CSVParser.h"
#import "Perceptron.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSMutableArray* datasets = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i=1; i<4; ++i) {
            NSString *file = @(__FILE__);
            NSString *filename = [NSString stringWithFormat:@"DataSet%d.csv", i];
            file = [[file stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
            
            NSStringEncoding encoding = 0;
            NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
            CHCSVParser * p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
            [p setRecognizesBackslashesAsEscapes:YES];
            [p setSanitizesFields:YES];
            
            NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
            
            CSVParser* parserDelegate = [[CSVParser alloc] init];
            [p setDelegate:parserDelegate];
            
            NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
            [p parse];
            NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
            
            NSLog(@"raw difference: %f", (end-start));
            NSLog(@"%lu records have been parsed successfully.", [parserDelegate.lines count]);
            if (i==1) {
                datasets[0] = parserDelegate.header;
            }
            datasets[i] = parserDelegate.lines;
        }
        Perceptron* perceptron = [[Perceptron alloc] initWithHeader:(NSMutableArray*)datasets[0] DataSetOne:(NSMutableArray*)datasets[1] Two:(NSMutableArray*)datasets[2] Three:(NSMutableArray*)datasets[3]];
        [perceptron doTraining];
    }
    return 0;
}

