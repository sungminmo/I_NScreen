//
//  CMColor.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 9. 19..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMColor.h"
#import "UIColor+ColorString.h"

@implementation CMColor

+(UIColor*)colorWhite {
    return [UIColor colorWithHexString:@"ffffff"];
}

+(UIColor*)colorLightViolet {
    return [UIColor colorWithHexString:@"947bb5"];
}

+(UIColor*)colorLightViolet2 {
    return [UIColor colorWithHexString:@"C5B4DE"];
}

+(UIColor*)colorViolet {
    return [UIColor colorWithHexString:@"7b5aa3"];
}

+(UIColor*)colorGray {
    return [UIColor colorWithHexString:@"9b9c9e"];
}

+(UIColor*)colorHighlightedGray {
    return [UIColor colorWithHexString:@"8b8c8e"];
}

+(UIColor*)colorTableSeparator {
    return [UIColor colorWithHexString:@"C4C5C6"];
}

+(UIColor*)colorPlaceHolderColor {
    return [UIColor colorWithHexString:@"666666"];
}

+(UIColor*)colorHighlightedFontColor {
    return [UIColor colorWithHexString:@"553977"];
}

@end
