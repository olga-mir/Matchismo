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

// game is not in progress after the cards had been successfully dealt and before the first flip occurs
@property (nonatomic) BOOL gameInProgress;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numOfCardsModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation CardGameViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
      self.gameInProgress = NO;
    }
    return self;
}

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

- (IBAction)touchNumOfCardsSwitch:(UISegmentedControl *)sender
{
  switch ([sender selectedSegmentIndex]) {
    case 0:
      self.game.numOfCardsToMatch = 2;
      break;
    case 1:
      self.game.numOfCardsToMatch = 3;
      break;
    default:
      self.game.numOfCardsToMatch = 2;
      break;
  }
}

// at this stage the deal button doesn't prompt the user if he does intend to drop current game
- (IBAction)touchDealButton:(id)sender
{
  NSLog(@"DEAL");
  [self.game restartGameUsingDeck:[self createDeck]];
  self.gameInProgress = NO;
  [self updateUI];
}


- (IBAction)touchCardButton:(id)sender
{
  int chosenCardButtonIndex = [self.cardButtons indexOfObject:sender];
  [self.game choseCardAtIndex:chosenCardButtonIndex];
  self.gameInProgress = YES;
  [self updateUI];
}


- (void) updateUI
{
  for (UIButton *cardButton in self.cardButtons) {
    int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.numOfCardsModeSwitch.enabled = !self.gameInProgress;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

    // message to the user.
    NSMutableArray *cardsInCurMatch = [[NSMutableArray alloc] init]; // of NSStrings, representing contents of the card in current macth
    for (Card *card in self.game.lastChosenCards) {
      [cardsInCurMatch addObject:card.contents];
    }
    NSString *cardsContents = [cardsInCurMatch componentsJoinedByString:@" "];

    if ([self.game.lastChosenCards count] == 0) {
      self.messageLabel.text = @"";
    } else if ([self.game.lastChosenCards count] == self.game.numOfCardsToMatch) {
      if (self.game.scoreForLastMatch > 0) {
        self.messageLabel.text = [NSString stringWithFormat:@"%@ matched for %d", cardsContents, self.game.scoreForLastMatch];
      } else {
        self.messageLabel.text = [NSString stringWithFormat:@"%@ didn't match. %d penalty", cardsContents, self.game.scoreForLastMatch];
      }
    } else {
      self.messageLabel.text = [NSString stringWithFormat:@"%@. Keep chosing", cardsContents];
    }
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




