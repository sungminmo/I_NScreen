//
//  CMDateScrollView.m
//  aaaaaaa
//
//  Created by kimts on 2015. 10. 31..
//  Copyright © 2015년 kimteaksoo. All rights reserved.
//

#import "CMDateScrollView.h"
#import "UIColor+ColorString.h"
#import "CMColor.h"

static const CGFloat defaultFontSize = 15;
static const CGFloat selectedFontSize = 15;

@interface CMDateItemView ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* dotView;
@property (nonatomic, strong) UIButton* backgroundButton;

@property (nonatomic, copy) void (^selectionHandler)(CMDateItemView* dateItemView);

@end

@implementation CMDateItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.dotView = [[UIView alloc] init];
        [self addSubview:self.dotView];
        
        CGFloat dotSize = 3;
        
        self.dotView.layer.cornerRadius = dotSize/2;
        CGRect rect = CGRectMake(CGRectGetMidX(self.bounds) - dotSize/2, self.bounds.size.height - 16, dotSize, dotSize);
        self.dotView.frame = rect;
        
        self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundButton.frame = self.bounds;
        self.backgroundButton.backgroundColor = [UIColor clearColor];
        [self.backgroundButton addTarget:self action:@selector(buttonWasTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundButton];

        [self setSelection:false];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString*)title {
    self = [self initWithFrame:frame];

    if (self) {
        
        self.titleLabel.text = title;
    }
    
    return self;
}

#pragma mark - Publics

/**
 *  선택여부에 따라 날짜 항목의 UI를 상태에 맞게 변경한다.
 *
 *  @param selection 선택여부
 */
- (void)setSelection:(BOOL)selection {
    _selection = selection;
    
    if (self.selection) {
        UIColor* color = [CMColor colorHighlightedFontColor];
        
        self.dotView.backgroundColor = color;
        self.titleLabel.textColor = color;
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:selectedFontSize];
    } else {
        UIColor* color = [UIColor whiteColor];
        
        self.dotView.backgroundColor = color;
        self.titleLabel.textColor = color;
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:defaultFontSize];
    }
}

- (void)addTouchUpInsideEvent:(void (^)(id sender))handler
{
    self.selectionHandler = handler;
}

#pragma mark - Event

- (void)buttonWasTouchUpInside:(id)sender
{
    if (self.selectionHandler) {
        self.selectionHandler(self);
    }
}

@end

#pragma mark -
#pragma mark -

@interface CMDateScrollView ()

@property (nonatomic, assign) CGFloat dateWidth;
@property (nonatomic, strong) NSArray* dateArray;
@property (nonatomic, strong) NSMutableArray* itemViewArray;

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* decorationView;
@property (nonatomic, strong) UIImageView * rightArrowView;

@end

@implementation CMDateScrollView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [CMColor colorLightViolet2];
        
        self.itemViewArray = [@[] mutableCopy];
        
        self.dateWidth = 74;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.decorationView = [[UIView alloc] initWithFrame:self.bounds];
        self.decorationView.userInteractionEnabled = false;
        [self addSubview:self.decorationView];
        
//        UIImageView* gradationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradation.png"]];
//        gradationImageView.frame = self.bounds;
//        [self.decorationView addSubview:gradationImageView];
        
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectindicator.png"]];
        [arrowImageView sizeToFit];
        [self.decorationView addSubview:arrowImageView];
        
        CGRect rect = arrowImageView.frame;
        arrowImageView.frame = CGRectMake(/*CGRectGetMidX(self.bounds) - rect.size.width/2*/ (self.dateWidth - rect.size.width)/2, 13, rect.size.width, rect.size.height);
        
        
        self.rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moreindicator.png"]];
        [self.rightArrowView sizeToFit];
        rect = self.rightArrowView.frame;
        self.rightArrowView.frame = CGRectMake(self.bounds.size.width - rect.size.width - 10, (self.bounds.size.height - rect.size.height)/2, rect.size.width, rect.size.height);
        [self.decorationView addSubview:self.rightArrowView];

        
//        UIView* vLineView = [[UIView alloc] init];
//        vLineView.backgroundColor = [CMColor colorHighlightedFontColor];
//        
//        CGFloat height = self.bounds.size.height * 0.3;
//        vLineView.frame = CGRectMake(CGRectGetMidX(self.bounds) - self.dateWidth/2 + 1, (self.bounds.size.height - height)/2, 1, height);
//        
//        [self.decorationView addSubview:vLineView];
//        
//        vLineView = [[UIView alloc] init];
//        vLineView.backgroundColor = [CMColor colorHighlightedFontColor];
//        
//        vLineView.frame = CGRectMake(CGRectGetMidX(self.bounds) + self.dateWidth/2 - 2, (self.bounds.size.height - height)/2, 1, height);
//        
//        [self.decorationView addSubview:vLineView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dateArray:(NSArray*)dateArray {
    self = [self initWithFrame:frame];
    
    if (self) {
        [self setDateArray:dateArray];
    }
    
    return self;
}

#pragma mark - Publics

/**
 *  날짜정보를 표출한다.
 *
 *  @param dateArray 표출된 날짜 정보 목록
 */
- (void)setDateArray:(NSArray*)dateArray {
    
    _dateArray = [NSArray arrayWithArray:dateArray];
    
    [self.itemViewArray removeAllObjects];
    
    CGFloat posX = 0;
    for (int i = 0; i < dateArray.count; i++) {
        
        CGRect frame = CGRectMake(posX, 0, self.dateWidth, self.bounds.size.height);
        CMDateItemView* itemView = [[CMDateItemView alloc] initWithFrame:frame title:self.dateArray[i]];
        
        __weak __typeof(self) weakSelf = self;
        [itemView addTouchUpInsideEvent:^(id sender) {
            
            NSInteger index = [weakSelf.itemViewArray indexOfObject:sender];
            [weakSelf setSelectedIndex:index animated:YES];
            
            if ([weakSelf.delegate respondsToSelector:@selector(dateScrollView:selectedIndex:)]) {
                [weakSelf.delegate dateScrollView:weakSelf selectedIndex:weakSelf.selectedIndex];
            }
        }];
        
        [self.scrollView addSubview:itemView];
        
        [self.itemViewArray addObject:itemView];
        
        posX += self.dateWidth;
    }
    
    self.selectedIndex = 0;
    
    self.scrollView.contentSize = CGSizeMake(posX, self.bounds.size.height);
    
    __unused CGFloat hInset = (self.bounds.size.width - self.dateWidth) / 2;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width - self.dateWidth);
    self.scrollView.contentOffset = CGPointZero;//CGPointMake(-hInset, 0);
}

/**
 *  넘겨받은 인덱스에 해당하는 날짜를 선택한다.
 *
 *  @param selectedIndex 선택될 날짜 항목의 인덱스
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

/**
 *  넘겨받은 인덱스에 해당하는 날짜를 선택한다.
 *
 *  @param selectedIndex 선택될 날짜 항목의 인덱스
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    
    if (selectedIndex >= self.itemViewArray.count) {
        return;
    }
    
    CMDateItemView* itemView = self.itemViewArray[_selectedIndex];
    itemView.selection = NO;
    
    _selectedIndex = selectedIndex;
    itemView = self.itemViewArray[_selectedIndex];
    itemView.selection = YES;
    
    [self moveContentOffset:animated];
}

- (void)moveContentOffset:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointMake(_selectedIndex * self.dateWidth - self.scrollView.contentInset.left, 0) animated:animated];
    
    [self refreshArrows];
}

- (void)refreshArrows
{
    CGFloat maxIndex = self.dateArray.count - 1;
    CGFloat maxPosX = maxIndex*self.dateWidth;
    CGFloat offset = self.scrollView.bounds.size.width + (_selectedIndex*self.dateWidth - self.dateWidth);
    if (offset >= maxPosX) {
        self.rightArrowView.hidden = YES;
    } else {
        self.rightArrowView.hidden = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    CGFloat maxIndex = self.dateArray.count - 1;
    CGFloat targetX = scrollView.contentOffset.x + scrollView.contentInset.left + velocity.x * 60.0;

    CGFloat targetIndex = round(targetX / self.dateWidth);
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > maxIndex)
        targetIndex = maxIndex;

    [self refreshArrows];
    
    targetContentOffset->x = targetIndex * self.dateWidth - scrollView.contentInset.left;
    
    if (targetIndex != self.selectedIndex) {
        self.selectedIndex = targetIndex;
        
        if ([self.delegate respondsToSelector:@selector(dateScrollView:selectedIndex:)]) {
            [self.delegate dateScrollView:self selectedIndex:self.selectedIndex];
        }
    }
}

@end
