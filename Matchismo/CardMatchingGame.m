//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Olga on 2/06/14.
//  Copyright (c) 2014 Olga. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Cards

@end


@implementation CardMatchingGame

- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

// auxilary function used to fill the _cards array from the given deck
// used in initializer and re-deal operation.
- (BOOL)dealCards:(NSUInteger)count fromDeck:(Deck *)deck
{
  for (int i = 0; i < count ; i++) {
    Card *card = [deck drawRandomCard];
    if (card) {
      [self.cards addObject:card];
    } else { // there was not enough cards in the deck
      return NO;
    }
  }
  return YES; // successfully dealt the cards
}

// The class designated inittializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
  self = [super init];
  
  if (self) {
    if (![self dealCards:count fromDeck:deck]) {
      // there was not enough cards, so the deal failed
      self = nil;
    }
    
    self.numOfCardsToMatch = 2; // TODO - replace
  }
  
  return self;
}

// reset the game logic. The number of cards is defined only once in the beggining of the game
// i.e. it is set once in the CardMatchingGame initializer
-(void)restartGameUsingDeck:(Deck *)deck
{
  int cardsInGame = [self.cards count];
  [self.cards removeAllObjects];
  [self dealCards:cardsInGame fromDeck:deck];
  self.score = 0;
}


- (Card *)cardAtIndex:(NSUInteger)index
{
  return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOSE = 1;

- (void)choseCardAtIndex:(NSUInteger)index
{
  Card *card = [self cardAtIndex:index];
 
  if (card.isChosen) {
    // if the card was already chosen, then toggle it back to unchosen state.
    // if the user clicked on a card that was previously chosen (face up), this
    // card now should flip over to face down, unchosen state
    card.chosen = NO;
    
  } else {

    NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
    
    // first we need to find all the cards that are face up, but has not yet been withdrawn from game
    // by being matched to other cards.
    for (Card *otherCard in self.cards) {
      if (otherCard.isChosen && !otherCard.isMatched) {
        
        [cardsToMatch addObject:otherCard];
        
        // only when exact number of cards to current game mode is chosen we can match them
        if ([cardsToMatch count] + 1 == self.numOfCardsToMatch) {
  
          int matchScore = [card match:cardsToMatch];
          
          if (matchScore) {
            self.score += matchScore * MATCH_BONUS;
            for (Card *c in cardsToMatch) {
              c.matched = YES;
            }
            card.matched = YES;
            
          } else { // the cards didn't match in any way - return them all to the game.
            
            self.score -= MISMATCH_PENALTY;
            for (Card *c in cardsToMatch) {
              c.chosen = NO;
            }
          }

          
        } else {
          // there is currently not enough cards selected
          // there is nothing to do in this case, only wait until user selects additional cards
        }
      }
    }
    self.score -= COST_TO_CHOSE;
    card.chosen = YES;
  }
}

@end



//} else {
//  // match the current card against other cards
//  for (Card *otherCard in self.cards) {
//    if (otherCard.isChosen && !otherCard.isMatched) {
//      int matchScore = [card match:@[otherCard]];
//      if (matchScore) {
//        self.score += matchScore * MATCH_BONUS;
//        otherCard.matched = YES;
//        card.matched = YES;
//      } else {
//        self.score -= MISMATCH_PENALTY;
//        otherCard.chosen = NO;
//      }
//      break; // only for 2 cards now
//    }
//  }
//  self.score -= COST_TO_CHOSE;
//  card.chosen = YES;
//}

