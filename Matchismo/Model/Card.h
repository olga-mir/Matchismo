//
//  Card.h
//  Matchismo
//
//  Created by Olga on 10/06/14.
//  Copyright (c) 2014 Olga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;


@end