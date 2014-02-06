#import "CSVParser.h"

@implementation CSVParser
{
    NSMutableArray* m_currLine;
}

- (id)init
{
    if ((self=[super init])) {
        self.lines = [[NSMutableArray alloc] init];
        self.header = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    [self.lines removeAllObjects];
    [self.header removeAllObjects];
}
//- (void)parserDidEndDocument:(CHCSVParser *)parser;

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    m_currLine = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if (recordNumber == 1) {
        self.header = m_currLine;
        //NSLog(@"%@", self.header);
    } else {
        if ([m_currLine count] < [self.header count]) {
            NSLog(@"Length of line %lu is %lu, which is too short and won't be considered as a line of record.", recordNumber, [m_currLine count]);
        } else {
            [self.lines addObject:m_currLine];
        }
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    if ([field hasPrefix:@" "]) {
        NSString* text = [field substringFromIndex:1];
        //NSString* text = [field stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [m_currLine addObject:text];
    } else {
        [m_currLine addObject:field];
    }
}

//- (void)parser:(CHCSVParser *)parser didReadComment:(NSString *)comment;
//
//- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error;


@end
