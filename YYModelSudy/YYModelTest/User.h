//
//  User.h
//  YYModelTest
//
//  Created by HaKim on 16/9/27.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Author;
@interface User : NSObject

//@property UInt64 uid;
//@property NSString *name;
//@property NSDate *created;

//@property NSString *name;
//@property NSInteger page;
//@property NSString *desc;
//@property NSString *bookID;
//@property NSString *hehename;
//@property (nonatomic, strong) NSArray *books;

@property NSString *bookName;
@property NSString *name;

@property Author *author;

- (void)doWork:(NSString*)content;

@end
