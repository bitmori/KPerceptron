#import <Foundation/Foundation.h>
#import "CHCSVParser/CHCSVParser.h"

@interface CSVParser : NSObject <CHCSVParserDelegate>

@property(strong, nonatomic) NSMutableArray* header;
@property(strong, nonatomic) NSMutableArray* lines;

@end
