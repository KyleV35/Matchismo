//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipsCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescriptionLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSelector;

/* This mutable array holds the label for each card flip to allow the user to 
   view their flip history */
@property (strong, nonatomic) NSMutableArray* flipHistory;
// This slider allows the user to view their flip history
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    /* The +2 for the number of cards is there because the UIsegementedControl begins at index 0, which needs to translate to a 2 card matching game. */
    if (!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] numberOfCardsToMatch:self.gameTypeSelector.selectedSegmentIndex+2];
    return _game;
}

- (NSMutableArray*)flipHistory
{
    if (!_flipHistory) {
        _flipHistory = [[NSMutableArray alloc] init];
        //Add a empty string for the start of the game
        [_flipHistory addObject:@""];
    }
    return _flipHistory;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI
{
    // Only create this image once (outside the loop) to be efficient
    UIImage *cardBackImage = [UIImage imageNamed:@"Matchismo.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //If card is face up, display contents
        if (card.isFaceUp) {
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
            //Need to set image to nil in order to display title properly
            [cardButton setImage:nil forState:UIControlStateNormal];
        } else { //If card is face down, display image
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            [cardButton setTitle:nil forState:UIControlStateNormal];
        }
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3f : 1.0f;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    // Grab the text description of the flip from the model right when it is needed
    self.flipDescriptionLabel.text = self.game.flipDescription;
    self.flipDescriptionLabel.alpha = 1.0f;
}

- (void)setFlipsCount:(NSUInteger)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipsCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    self.gameTypeSelector.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipsCount++;
    // Add the flip description to flipHistory
    [self.flipHistory addObject:self.game.flipDescription];
    
    //Update the slider to reflect an additional flip
    self.historySlider.maximumValue = self.flipsCount;
    self.historySlider.value = self.historySlider.maximumValue;
    [self updateUI];
}

- (IBAction)dealButtonPressed {
    
    //Reset the game, description for the +2 can be found in the comment on the getter for self.game
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] numberOfCardsToMatch:self.gameTypeSelector.selectedSegmentIndex+2];
    
    //Reset the history
    self.flipHistory = [[NSMutableArray alloc] init];
    [self.flipHistory addObject:@""];
    
    self.flipsCount = 0;
    
    //Reset UI
    self.historySlider.maximumValue = 0;
    self.gameTypeSelector.enabled = YES;
    [self updateUI];
}

- (IBAction)gameTypeValueChanged:(UISegmentedControl *)sender {
    [self.game setNumberOfCardsToMatch:sender.selectedSegmentIndex+2];
}

- (IBAction)historySliderValueChanged:(UISlider *)sender {
    int flipToDisplay = floor(sender.value);
    // If we move to present, set alpha back to 1.0
    if (flipToDisplay == sender.maximumValue) {
        self.flipDescriptionLabel.alpha = 1.0f;
        self.flipDescriptionLabel.text = [self.flipHistory lastObject];
    } else {
        // If we move into history, turn alpha down
        self.flipDescriptionLabel.alpha = .3f;
        self.flipDescriptionLabel.text = [self.flipHistory objectAtIndex:flipToDisplay];
    }
}
@end
