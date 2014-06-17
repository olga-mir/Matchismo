//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Olga on 2/06/14.
//  Copyright (c) 2014 Olga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// the card game mode - match 2 or 3 cards at a time.
@property (nonatomic) NSUInteger numOfCardsToMatch;

// keep the last chosen cardset and the score for the last match for the ViewController needs.
// since this information is not avaibale and not restoreable in the view controller it is built in the model
// it is also UI independent, so there is no problem to save it in the model
@property (nonatomic, strong) NSMutableArray *lastChosenCards; // of Cards
@property (nonatomic) int scoreForLastMatch;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

// purge the current cards and deal new set
- (void)restartGameUsingDeck:(Deck *)deck;

- (void)setNumOfCardsToMatch:(NSUInteger)num;

- (void)choseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;

@end
