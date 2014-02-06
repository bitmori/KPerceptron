#import <Foundation/Foundation.h>
#import "CSVParser.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSString *file = @(__FILE__);
        file = [[file stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"DataSet1.csv"];
        
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
        //NSLog(@"%@", parserDelegate.lines);
    }
    return 0;
}

