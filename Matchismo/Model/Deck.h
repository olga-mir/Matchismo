//
//  Deck.h
//  Matchismo
//
//  Created by Olga on 29/05/14.
//  Copyright (c) 2014 Olga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *) card atTop:(BOOL)atTop;
- (void)addCard:(Card *) card;

- (Card *)drawRandomCard;

@end

