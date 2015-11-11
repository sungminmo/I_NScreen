//
//  CMTabMenuView.m
//  I_NScreen
//
//  Created by bjm on 2015. 9. 20..
//  Copyright © 2015년 STVN. All rights reserved.
//

#import "CMTabMenuView.h"
#import "UIImage+Color.h"
#import "UIColor+ColorString.h"

static const CGFloat tabHeight = 42;
static const CGFloat fontSize = 18;
static const CGFloat padding = 21;

@interface CMTabMenuView ()

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray* menuTitleArray;
@property (nonatomic, strong) NSMutableArray* menuButtonArray;

@end

@implementation CMTabMenuView

#pragma mark - Life Cycle

- (instancetype)initWithMenuArray:(NSArray*)menuArray posY:(float)posY delegate:(id<CMTabMenuViewDelegate>)delegate {
    
    self = [super init];
    if (self) {
        
        CGRect frame = [[UIApplication sharedApplication] keyWindow].frame;
        self.frame = CGRectMake(0, posY, frame.size.width, tabHeight);
        
        self.selectedIndex = 0;
        self.menuButtonArray = [@[] mutableCopy];
        
        self.menuTitleArray = menuArray;
        self.delegate = delegate;
        
        [self loadUI];
    }
    
    return self;
}

#pragma mark - Privates

- (void)loadUI {
    
    CGFloat buttonWidth = (self.frame.size.width - padding*2) / self.menuTitleArray.count;
    
    for (int i = 0; i < self.menuTitleArray.count; i++) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth * i + padding, 0, buttonWidth, tabHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:self.menuTitleArray[i] forState:UIControlStateNormal];
        [self.menuButtonArray addObject:button];
        
        [self setTabButtonAttribute:button];
        
        [self addSubview:button];
    }
    
    [self selectTabMenu:self.selectedIndex];
}

- (void)setTabButtonAttribute:(UIButton*)button {
    
    UIColor* normalColor = [UIColor colorWithHexString:@"D3C6E1"];
    UIColor* selectedColor = [CMColor colorLightViolet];
    
    UIImage* defaultImage = [UIImage clearImageSize:button.frame.size];
    defaultImage = [UIImage setOuterLine:defaultImage direction:HMOuterLineDirectionBottom lineWeight:1 lineColor:normalColor];
    
    UIImage* selectedImage = [UIImage clearImageSize:button.frame.size];;
    selectedImage = [UIImage setOuterLine:selectedImage direction:HMOuterLineDirectionBottom lineWeight:4 lineColor:selectedColor];
    
    [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    [button setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedColor forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(buttonWasTouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Publics

- (void)selectTabMenu:(NSInteger)index {

    for (int i = 0; i < self.menuButtonArray.count; i++) {
        UIButton* button = self.menuButtonArray[i];
        
        if (i == index) {
            button.selected = true;
            
            button.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        } else {
            button.selected = false;
            
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
    }
}

- (NSInteger)getTabMenuIndex {

    return self.selectedIndex;
}

#pragma mark - Event

- (void)buttonWasTouchUpInside:(id)sender withEvent:(UIEvent*)event {

    NSInteger index = 0;
    for (int i = 0; i < self.menuButtonArray.count; i++) {
        UIButton* button = self.menuButtonArray[i];
        if (button == sender) {
            index = i;
            break;
        }
    }
    
    if (self.selectedIndex == index) {
        return;
    } else {
        self.selectedIndex = index;
    }
    
    [self selectTabMenu:self.selectedIndex];
    
    if ([self.delegate respondsToSelector:@selector(tabMenu:didSelectedTab:)]) {
        [self.delegate tabMenu:self didSelectedTab:self.selectedIndex];
    }
}

@end

