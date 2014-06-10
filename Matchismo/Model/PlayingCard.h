//
//  PlayingCard.h
//  Matchismo
//
//  Created by Olga on 10/06/14.
//  Copyright (c) 2014 Olga. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSUInteger)maxRank;
+ (NSArray *)validSuits;

@end