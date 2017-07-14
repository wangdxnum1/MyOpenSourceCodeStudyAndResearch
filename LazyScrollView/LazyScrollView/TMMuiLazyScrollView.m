//
//  TMMuiLazyScrollView.m
//  LazyScrollView
//
//  Copyright (c) 2015 tmall. All rights reserved.
//

#define RenderBufferWindow              20.f

#import "TMMuiLazyScrollView.h"
#import <objc/runtime.h>

@implementation TMMuiRectModel

@end


//Here is a category implementation required by LazyScrollView.
@implementation UIView(TMMui)

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    objc_setAssociatedObject(self, @"reuseIdentifier", reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)reuseIdentifier
{
    NSString *reuseIdentifier = objc_getAssociatedObject(self, @"reuseIdentifier");
    return reuseIdentifier;
}

- (NSString *)muiID
{
    return objc_getAssociatedObject(self, @"muiID");
}

- (void)setMuiID:(NSString *)muiID
{
    objc_setAssociatedObject(self, @"muiID", muiID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@interface TMMuiLazyScrollViewObserver: NSObject
@property (nonatomic, weak) TMMuiLazyScrollView *lazyScrollView;
@end


@interface TMMuiLazyScrollView()<UIScrollViewDelegate>

// Store Visible Views
@property (nonatomic, strong, readwrite) NSMutableSet *visibleItems;

// Store reuseable cells by reuseIdentifier. The key is reuseIdentifier of views , value is an array that contains reuseable cells.
@property (nonatomic,strong)NSMutableDictionary *recycledIdentifierItemsDic;

// Store view models (TMMuiRectModel).
@property (nonatomic, strong) NSMutableArray *itemsFrames;

// ScrollView delegate,store outer scrollDelegate here.
// Because of lazyscrollview need calculate what views should be shown in scrollDidScroll.
@property (nonatomic,weak) id <TMMuiLazyScrollViewDelegate> lazyScrollViewDelegate;

// View Model sorted by Top Edge.
@property (nonatomic, strong) NSArray *modelsSortedByTop;

// View Model sorted by Bottom Edge.
@property (nonatomic, strong) NSArray *modelsSortedByBottom;

// Store view models below contentOffset of ScrollView
@property (nonatomic, strong) NSMutableSet *firstSet;

// Store view models above contentOffset + ScrollView.height of ScrollView
@property (nonatomic, strong)  NSMutableSet *secondSet;

// record contentOffset of scrollview in previous time that calculate views to show
@property (nonatomic, assign) CGPoint     lastScrollOffset;

// record current muiID of visible view for calculate.
@property (nonatomic, strong) NSString    *currentVisibleItemMuiID;

// It is used to store views need to assign new value after reload.
@property (nonatomic, strong) NSMutableSet    *shouldReloadItems;

// Record in screen visible muiID
@property (nonatomic, strong) NSSet *muiIDOfVisibleViews;
// Store the times of view entered the screen , the key is muiiD
@property (nonatomic, strong) NSMutableDictionary *enterDict;
// Store last time visible muiID
@property (nonatomic, strong) NSMutableSet *lastVisiblemuiID;

@end


@implementation TMMuiLazyScrollView

-(NSMutableDictionary *)enterDict
{
    if (nil == _enterDict) {
        _enterDict = [[NSMutableDictionary alloc]init];
    }
    return _enterDict;
}

- (NSMutableSet *)shouldReloadItems
{
    if (nil == _shouldReloadItems) {
        _shouldReloadItems = [[NSMutableSet alloc] init];
    }
    return _shouldReloadItems;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, self.frame))
    {
        [super setFrame:frame];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.autoresizesSubviews = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _recycledIdentifierItemsDic = [[NSMutableDictionary alloc] init];
        _visibleItems = [[NSMutableSet alloc] init];
        _itemsFrames = [[NSMutableArray alloc] init];
        _firstSet = [[NSMutableSet alloc] initWithCapacity:30];
        _secondSet = [[NSMutableSet alloc] initWithCapacity:30];
        super.delegate = self;
        
    }
    return self;
}

- (void)dealloc
{
    _dataSource = nil;
    self.delegate = nil;
    [_recycledIdentifierItemsDic removeAllObjects],_recycledIdentifierItemsDic = nil;
    [_visibleItems removeAllObjects],_visibleItems = nil;
    [_itemsFrames removeAllObjects],_itemsFrames = nil;
    [_firstSet removeAllObjects],_firstSet = nil;
    [_secondSet removeAllObjects],_secondSet = nil;
    _modelsSortedByTop = nil;
    _modelsSortedByBottom = nil;

}

//replace UIScrollDelegate to TMMuiLazyScrollViewDelegate for insert code in scrollDidScroll .
-(void)setDelegate:(id<TMMuiLazyScrollViewDelegate>)delegate
{
    if (!delegate)
    {
        [super setDelegate:nil];
        _lazyScrollViewDelegate = nil;
    }
    else
    {
        [super setDelegate:self];
        _lazyScrollViewDelegate = delegate;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Scroll can trigger LazyScrollView calculate which views should be shown.
    // Calcuting Action will cost some time , so here is a butter for reducing times of calculating.
    //Scroll会触发重新计算那些views需要被显示
    CGFloat currentY = scrollView.contentOffset.y;
    CGFloat buffer = RenderBufferWindow / 2;
    
    
    // 当前的contentOffset.y，上一次的self.lastScrollOffset.y
    // buffer = 10
    // 如果上一次是10，往上移动，移动距离超过10才需要计算
    if (buffer < ABS(currentY - self.lastScrollOffset.y)) {
        self.lastScrollOffset = scrollView.contentOffset;
        
        // 不需要强制加载
        [self assembleSubviews];
        
        //
        [self findViewsInVisibleRect];

    }
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidScroll:self];
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2)
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidZoom:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillEndDragging:self withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillBeginDecelerating:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndDecelerating:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndScrollingAnimation:self];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
    {
        return [self.lazyScrollViewDelegate viewForZoomingInScrollView:self];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
    {
        [self.lazyScrollViewDelegate scrollViewWillBeginZooming:self withView:view];
    }
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidEndZooming:self withView:view atScale:scale];
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    {
        return [self.lazyScrollViewDelegate scrollViewShouldScrollToTop:self];
    }
    return self.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (self.lazyScrollViewDelegate && [self.lazyScrollViewDelegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.lazyScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
    {
        [self.lazyScrollViewDelegate scrollViewDidScrollToTop:self];
    }
}
// Do Binary search here to find index in view model array.
// 二分查找找到符合要求的id，1.rect ：y + height >=baseline,下一个又小于baseline的那个index  降序的数组
// 2.y <= bseline,下一个又要大于baseline ，升序的数组
-(NSUInteger) binarySearchForIndex:(NSArray *)frameArray baseLine:(CGFloat)baseLine isFromTop:(BOOL)fromTop
{
    NSInteger min = 0 ;
    NSInteger max = frameArray.count -1;
    NSInteger mid = ceilf((CGFloat)(min + max) / 2.f);
    while (mid > min && mid < max) {
        CGRect rect = [(TMMuiRectModel *)[frameArray objectAtIndex:mid] absoluteRect];
        // For top
        if(fromTop) {
            CGFloat itemTop = CGRectGetMinY(rect);
            if (itemTop <= baseLine) {
                CGRect nextItemRect = [(TMMuiRectModel *)[frameArray objectAtIndex:mid + 1] absoluteRect];
                CGFloat nextTop = CGRectGetMinY(nextItemRect);
                if (nextTop > baseLine) {
                    mid ++;
                    break;
                }
                min = mid;
            }
            else {
                max = mid;
            }
        }
        // For bottom
        else {
            CGFloat itemBottom = CGRectGetMaxY(rect);
            if (itemBottom >= baseLine) {
                CGRect nextItemRect = [(TMMuiRectModel *)[frameArray objectAtIndex:mid + 1] absoluteRect];
                CGFloat nextBottom = CGRectGetMaxY(nextItemRect);
                if (nextBottom < baseLine) {
                    mid ++;
                    break;
                }
                min = mid;
            }
            else {
                max = mid;
            }
        }
        mid = ceilf((CGFloat)(min + max) / 2.f);
    }
    
    return mid;
}

// Get which views should be shown in LazyScrollView.
// The kind of Inner Elements In NSSet is NSNumber , containing index of view model array;

// 找出符合区间内要显示的rectModels，两个数组的交集
-(NSSet *)showingItemIndexSetFrom :(CGFloat)startY to:(CGFloat)endY
{
    if ( !self.modelsSortedByBottom  || !self.modelsSortedByTop ) {
        [self creatScrollViewIndex];
    }
    NSUInteger endBottomIndex = [self binarySearchForIndex:self.modelsSortedByBottom baseLine:startY isFromTop:NO];
    [self.firstSet removeAllObjects];
    if (self.modelsSortedByBottom && self.modelsSortedByBottom.count > 0) {
        for (NSUInteger i = 0; i <= endBottomIndex; i++) {
            TMMuiRectModel *model = [self.modelsSortedByBottom objectAtIndex:i];
            if (model != nil) {
                [self.firstSet addObject:model.muiID];
            }
        }
    }
    NSUInteger endTopIndex = [self binarySearchForIndex:self.modelsSortedByTop baseLine:endY isFromTop:YES];
    [self.secondSet removeAllObjects];
    if (self.modelsSortedByTop && self.modelsSortedByTop.count > 0) {
        for (NSInteger i = 0; i <= endTopIndex; i++) {
            TMMuiRectModel *model = [self.modelsSortedByTop objectAtIndex:i];
            if (model != nil) {
                [self.secondSet addObject:model.muiID];
            }
        }
    }
    [self.firstSet intersectSet:self.secondSet];
    return [self.firstSet copy];
}

// 按y排序的 升序
-(NSArray *)modelsSortedByTop
{
    if (!_modelsSortedByTop){
        _modelsSortedByTop = [[NSArray alloc] init];
    }
    return _modelsSortedByTop;
}


// y + height 降序的
-(NSArray *)modelsSortedByBottom
{
    if (!_modelsSortedByBottom) {
        _modelsSortedByBottom = [[NSArray alloc]init];
    }
    return _modelsSortedByBottom;
}

// Get view models from delegate . Create to indexes for sorting.
// 获取rectModels，并给两个数组排好序，modelsSortedByTop升序，modelsSortedByBottom降序
- (void)creatScrollViewIndex
{
    NSUInteger count = 0;
    [self.itemsFrames removeAllObjects];
    if(self.dataSource && [self.dataSource conformsToProtocol:@protocol(TMMuiLazyScrollViewDataSource)] &&
       [self.dataSource respondsToSelector:@selector(numberOfItemInScrollView:)]) {
        count = [self.dataSource numberOfItemInScrollView:self];
    }
    
    for (NSUInteger i = 0 ; i< count ; i++) {
        TMMuiRectModel *rectmodel;
        if(self.dataSource
           &&[self.dataSource conformsToProtocol:@protocol(TMMuiLazyScrollViewDataSource)]
           &&[self.dataSource respondsToSelector:@selector(scrollView: rectModelAtIndex:)])
        {
            rectmodel = [self.dataSource scrollView:self rectModelAtIndex:i];
            if (rectmodel.muiID.length == 0)
            {
                rectmodel.muiID = [NSString stringWithFormat:@"%lu",(unsigned long)i];
            }
        }
        
        [self.itemsFrames addObject:rectmodel];
    }
    self.modelsSortedByTop = [self.itemsFrames sortedArrayUsingComparator:^NSComparisonResult(id obj1 ,id obj2)
                              {
                                  CGRect rect1 = [(TMMuiRectModel *) obj1 absoluteRect];
                                  CGRect rect2 = [(TMMuiRectModel *) obj2 absoluteRect];
                                  
                                  if (rect1.origin.y < rect2.origin.y) {
                                      return NSOrderedAscending;
                                  }
                                  else if (rect1.origin.y > rect2.origin.y) {
                                      return NSOrderedDescending;
                                  }
                                  else {
                                      return NSOrderedSame;
                                  }
                              }];
    
    self.modelsSortedByBottom = [self.itemsFrames sortedArrayUsingComparator:^NSComparisonResult(id obj1 ,id obj2)
                                 {
                                     CGRect rect1 = [(TMMuiRectModel *) obj1 absoluteRect];
                                     CGRect rect2 = [(TMMuiRectModel *) obj2 absoluteRect];
                                     CGFloat bottom1 = CGRectGetMaxY(rect1);
                                     CGFloat bottom2 = CGRectGetMaxY(rect2);
                                     
                                     if (bottom1 > bottom2) {
                                         return NSOrderedAscending ;
                                     }
                                     else if (bottom1 < bottom2) {
                                         return  NSOrderedDescending;
                                     }
                                     else {
                                         return NSOrderedSame;
                                     }
                                 }];
}

// 找到需要显示的views；通知代理muiID显示的次数
- (void)findViewsInVisibleRect
{
    // 当前屏幕上要显示的item
    NSMutableSet *itemViewSet = [self.muiIDOfVisibleViews mutableCopy];
    // self.lastVisiblemuiID 是上次屏幕上显示的item
    
    // 当前已经显示，下次还是需要显示的减去，剩下的view还没有加载到scrollview中去
    [itemViewSet minusSet:self.lastVisiblemuiID];
    
    // 下次屏幕上先显示的view，或者说需要加入到scrollview中去的
    for (UIView *view in self.visibleItems) {
        // 是需要显示，而且上次没有显示在scrollview中的
        if (view && [itemViewSet containsObject:view.muiID]) {
            if ([view conformsToProtocol:@protocol(TMMuiLazyScrollViewCellProtocol)] && [view respondsToSelector:@selector(mui_didEnterWithTimes:)]) {
                NSUInteger times = 0;
                if ([self.enterDict objectForKey:view.muiID] != nil) {
                    times = [[self.enterDict objectForKey:view.muiID] unsignedIntegerValue] + 1;
                }
                NSNumber *showTimes = [NSNumber numberWithUnsignedInteger:times];
                [self.enterDict setObject:showTimes forKey:view.muiID];
                // 记录muiID显示的次数
                // 通知代理
                [(UIView<TMMuiLazyScrollViewCellProtocol> *)view mui_didEnterWithTimes:times];
            }
        }
    }
    self.lastVisiblemuiID = [self.muiIDOfVisibleViews copy];
}
// A simple method to make view that should be shown show in LazyScrollView
- (void)assembleSubviews
{
     CGRect visibleBounds = self.bounds;
     // self.bounds 其中（x,y）的坐标会被改变
     // Visible area adding buffer to form a area that need to calculate which view should be shown.
     CGFloat minY = CGRectGetMinY(visibleBounds) - RenderBufferWindow;
     CGFloat maxY = CGRectGetMaxY(visibleBounds) + RenderBufferWindow;
     [self assembleSubviewsForReload:NO minY:minY maxY:maxY];
}

// 1.获取下次需要显示的views
// 2.
- (void)assembleSubviewsForReload:(BOOL)isReload minY:(CGFloat)minY maxY:(CGFloat)maxY
{
    // 上下边扩大20的范围内，需要显示的item
    NSSet *itemShouldShowSet = [self showingItemIndexSetFrom:minY to:maxY];
    
    // 正在显示的item，或者说scrollview 边界内显示的view
    self.muiIDOfVisibleViews = [self showingItemIndexSetFrom:CGRectGetMinY(self.bounds) to:CGRectGetMaxY(self.bounds)];

    // 循环利用的view记录
    NSMutableSet  *recycledItems = [[NSMutableSet alloc] init];
    //For recycling . Find which views should not in visible area.
    // 可见的视图，当前正在显示的视图。第一次加载，self.visibleItems应该是空的
    NSSet *visibles = [self.visibleItems copy];
    for (UIView *view in visibles)
    {
        //Make sure whether the view should be shown.
        // itemShouldShowSet需要显示的items 是否包含 正在显示的view.muiID
        BOOL isToShow  = [itemShouldShowSet containsObject:view.muiID];
        //If this view should be recycled and the length of its reuseidentifier over 0
        // 当前正在显示，下次刷新不需要显示额，放入缓存池
        if (!isToShow && view.reuseIdentifier.length > 0)
        {
            //Then recycle the view.
            // 获取标识符对应的set，用来存放view
            NSMutableSet *recycledIdentifierSet = [self recycledIdentifierSet:view.reuseIdentifier];
            // 先添加
            [recycledIdentifierSet addObject:view];
            // 再从父view上移除
            [view removeFromSuperview];
            // 记录循环利用的view
            [recycledItems addObject:view];
        }
        else if (isReload && view.muiID) {
            // 首先是是强制加载的，当前显示，下次刷新还需要显示的，shouldReloadItems记录muiID
            // 滚动的时候，isReload为NO，是不会进来的
            [self.shouldReloadItems addObject:view.muiID];
        }
    }
    
    // 从当前可见的视图中 减去，删除 下次不显示的视图（放入循环利用的缓存池中）
    [self.visibleItems minusSet:recycledItems];
    
    // 清空记录循环利用的容器，没什么用了
    [recycledItems removeAllObjects];
    
    
    //For creare new view.
    for (NSString *muiID in itemShouldShowSet)
    {
        // 是否需要强制加载
        // 1.isReload为YES
        // 2.shouldReloadItems包含这个muiID
        // 当调用reloadData的时候，就是强制全部加载
        // 滚动的时候isReload为NO
        BOOL shouldReload = isReload || [self.shouldReloadItems containsObject:muiID];
        
        // 1.不可见，即将显示的view，在当前屏幕上还没显示，或者说还没加载创建，但是下次是需要显示的 2.已经在屏幕上，但是还是需要显示的
        // (1)第一次加载的时候self.shouldReloadItems为空，看不见
        // (2)第一次已经显示好之后，调用reloadData，强制刷新，可见，但是在shouldReloadItems中，所以也会新生成view
        // (3)滚动的时候a.muiID之前是没有的，那需要新生成 b.之前可见的，shouldReloadItems肯定也不会包含，不会重新生成
        if(![self isCellVisible:muiID] || [self.shouldReloadItems containsObject:muiID])
        {
            if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(TMMuiLazyScrollViewDataSource)] &&
                [self.dataSource respondsToSelector:@selector(scrollView: itemByMuiID:)])
            {
                if (shouldReload) {
                    self.currentVisibleItemMuiID = muiID;
                }
                else {
                    self.currentVisibleItemMuiID = nil;
                }
                // Create view by delegate.
                // 通过代理方法获取view
                UIView *viewToShow = [self.dataSource scrollView:self itemByMuiID:muiID];
                
                // Call afterGetView
                // 触发代理方法，通知代理
                if ([viewToShow conformsToProtocol:@protocol(TMMuiLazyScrollViewCellProtocol)] &&
                    [viewToShow respondsToSelector:@selector(mui_afterGetView)]) {
                    [(UIView<TMMuiLazyScrollViewCellProtocol> *)viewToShow mui_afterGetView];
                }
                
                if (viewToShow)
                {
                    // 给view绑定muiID
                    viewToShow.muiID = muiID;
                    if (![self.visibleItems containsObject:viewToShow]) {
                        // 添加到可显示的view中
                        [self.visibleItems addObject:viewToShow];
                    }
                }
            }
            // 删除当前已经显示在屏幕上，下次还是需要显示的那个muiID
            // 第一次加载好之后，调用reloadData时self.shouldReloadItems才会有值
            [self.shouldReloadItems removeObject:muiID];
        }
    }
}

// Find NSSet accroding to reuse identifier , if not , then create one.
// 根据缓存重用，获取存放view的容易，没有，则新建一个
- (NSMutableSet *)recycledIdentifierSet:(NSString *)reuseIdentifier;
{
    if (reuseIdentifier.length == 0)
    {
        return nil;
    }
    
    NSMutableSet *result = [self.recycledIdentifierItemsDic objectForKey:reuseIdentifier];
    if (result == nil) {
        result = [[NSMutableSet alloc] init];
        [self.recycledIdentifierItemsDic setObject:result forKey:reuseIdentifier];
    }
    return result;
}

//reloads everything and redisplays visible views.
// 重新加载数据
- (void)reloadData
{
    // 加载reactModel,并且两个数组排序
    [self creatScrollViewIndex];
    
    if (self.itemsFrames.count > 0) {
        CGRect visibleBounds = self.bounds;
        //Add buffer for rendering
        CGFloat minY = CGRectGetMinY(visibleBounds) - RenderBufferWindow;
        CGFloat maxY = CGRectGetMaxY(visibleBounds) + RenderBufferWindow;
        // 在加载的区间，计算出将要显示的rectModel，已经将需要显示的view放到了self.visibleItems中
        [self assembleSubviewsForReload:YES minY:minY maxY:maxY];
        
        [self findViewsInVisibleRect];
    }
}

// To acquire an already allocated view that can be reused by reuse identifier.
// If can't find one , here will return nil.
- (nullable UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier
{
    UIView *view = nil;
    // 这一段逻辑主要用在，如果已经加载好了，而且是代码调用了reloadData，但是实际当前显示在屏幕上的view，就符合要求了，就不需要从缓存中取了
    // 1.如果是滚动的话，self.currentVisibleItemMuiID为nil，不会进这段代码
    // 2.如果一开始加载的话，self.visibleItems为空，也找不到，不会进入这段逻辑
    if (self.currentVisibleItemMuiID) {
        NSSet *visibles = self.visibleItems;
        for (UIView *v in visibles) {
            if ([v.muiID isEqualToString:self.currentVisibleItemMuiID]) {
                view = v;
                break;
            }
        }
    }
    
    // 这段可以理解，从缓存中查找view
    if (nil == view) {
        NSMutableSet *recycledIdentifierSet = [self recycledIdentifierSet:identifier];
        view = [recycledIdentifierSet anyObject];
        if (view)
        {
            //if exist reusable view , remove it from recycledSet.
            // 如果存在，就从缓存中删除
            [recycledIdentifierSet removeObject:view];
            //Then remove all gesture recognizers of it.
            // 手势置为nil
            view.gestureRecognizers = nil;
        }
    }
    // 告诉代理view即将被重用
    if ([view conformsToProtocol:@protocol(TMMuiLazyScrollViewCellProtocol)] && [view respondsToSelector:@selector(mui_prepareForReuse)]) {
        [(UIView<TMMuiLazyScrollViewCellProtocol> *)view mui_prepareForReuse];
    }
    return view;
}

//Make sure whether the view is visible accroding to muiID.
//muiID对应的rect是否可见，感觉像是是否已经显示在屏幕上了
-(BOOL)isCellVisible: (NSString *)muiID {
    
    BOOL result = NO;
    // 遍历当前可见的而试图
    NSSet *visibles = [self.visibleItems copy];
    for (UIView *view in visibles)
    {
        if ([view.muiID isEqualToString:muiID])
        {
            result = YES;
            break;
        }
    }
    return result;
}

// Remove all subviews and reuseable views.
- (void)removeAllLayouts
{
    NSSet *visibles = self.visibleItems;
    for (UIView *view in visibles) {
        NSMutableSet *recycledIdentifierSet = [self recycledIdentifierSet:view.reuseIdentifier];
        [recycledIdentifierSet addObject:view];
        [view removeFromSuperview];
    }
    [_visibleItems removeAllObjects];
    [_recycledIdentifierItemsDic removeAllObjects];
}

-(void)resetViewEnterTimes
{
    [self.enterDict removeAllObjects];
    self.lastVisiblemuiID = nil;
}
@end


