//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Olga on 10/06/14.
//  Copyright (c) 2014 Olga. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;

@end


@implementation CardGameViewController

- (CardMatchingGame *)game
{
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                        usingDeck:[self createDeck]];
  return _game;
}

-(Deck *)createDeck
{
  return [[PlayingCardDeck alloc] init];
}

// at this stage the deal button doesn't prompt the user if he does intend to drop current game
- (IBAction)touchDealButton:(id)sender
{
  NSLog(@"---------------- DEAL -------------------");
  [self.game restartGameUsingDeck:[self createDeck]];
  [self updateUI];
}



- (IBAction)touchCardButton:(id)sender
{
  int chosenCardButtonIndex = [self.cardButtons indexOfObject:sender];
  NSLog(@"touched card button. index: %d", chosenCardButtonIndex);
  [self.game choseCardAtIndex:chosenCardButtonIndex];
  [self updateUI];
}

- (void) updateUI
{
  NSLog(@"UpdateUI, cards count: %d", [self.cardButtons count]);
  
  for (UIButton *cardButton in self.cardButtons) {
    int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    NSLog(@"currentInd: %d, card.chosen: %d, card.matched: %d", cardButtonIndex, card.isChosen, card.isMatched);
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
  }
}

- (NSString *)titleForCard:(Card *)card
{
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}





@end
