//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

#define NUMBER_OF_CARDS_TO_MATCH 3

- (Deck*)getAppropriateDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    return NUMBER_OF_CARDS_TO_MATCH;
}

- (void) updateUI
{
    [super updateUI];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if (card.isUnplayable) {
            cardButton.alpha = 0.0f;
        }
        if ([card isKindOfClass:[SetCard class]]) {
            //If card is face up, display contents
            if (card.isFaceUp) {
                
                [cardButton setAttributedTitle:[SetCardGameViewController convertSetCardToAttributedString:(SetCard*)card] forState:UIControlStateNormal];
                cardButton.backgroundColor = [UIColor colorWithRed:255 green:215 blue:0 alpha:0.5f];
            } else { //If card is face down, display image
                [cardButton setAttributedTitle:[SetCardGameViewController convertSetCardToAttributedString:(SetCard*)card] forState:UIControlStateNormal];
                cardButton.backgroundColor = [UIColor clearColor];
                
            }
        } else {
            NSLog(@"Card Provided was not a Set Card!");
        }
       
    }

}

+ (NSAttributedString*)convertSetCardToAttributedString:(SetCard*)card
{
    NSString* baseString = [SetCardGameViewController baseStringWithSetCard:card];
    NSString* fullLengthString = baseString;
    for (int i=0; i < card.number; i++) {
        fullLengthString = [fullLengthString stringByAppendingString:baseString];
    }
    UIColor *color = [SetCardGameViewController colorWithSetCard:card];
    CGFloat shading = [SetCardGameViewController shadingWithSetCard:card];
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:fullLengthString];
    [attString addAttribute:NSStrokeColorAttributeName value:color range:[fullLengthString rangeOfString:fullLengthString]];
    [attString addAttribute:NSStrokeWidthAttributeName value:@-5 range:[fullLengthString rangeOfString:fullLengthString]];
    [attString addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:shading]  range:[fullLengthString rangeOfString:fullLengthString]];
    
    
    return attString;
}

+ (NSString*)baseStringWithSetCard:(SetCard*)card
{
    NSString* baseString = @"";
    switch (card.shape)
    {
        case 0:
            baseString = @"▲";
            break;
        case 1:
            baseString = @"●";
            break;
        case 2:
            baseString = @"■";
            break;
        default:
            NSLog(@"Unknown shape! Value: %u",card.shape);
            break;
    }
    return baseString;
}

+ (UIColor*)colorWithSetCard:(SetCard*)card
{
    UIColor* color = nil;
    switch (card.color)
    {
        case 0:
            color = [UIColor greenColor];
            break;
        case 1:
            color = [UIColor blueColor];
            break;
        case 2:
            color = [UIColor redColor];
            break;
        default:
            NSLog(@"Unknown color! Value: %u",card.color);
            break;
    }
    return color;
}

+ (CGFloat)shadingWithSetCard:(SetCard*)card
{
    CGFloat shading = 0.0f;
    switch (card.shading)
    {
        case 0:
            shading = 0.0f;
            break;
        case 1:
            shading = 0.3f;
            break;
        case 2:
            shading = 1.0f;
            break;
        default:
            NSLog(@"Unknown transparency! Value: %u",card.shading);
            break;
    }
    return shading;
}

- (NSArray*)convertLastFlipArrayToAttributedStrings:(NSArray*)lastFlipArray
{
    NSMutableArray* attStringArray = [[NSMutableArray alloc] init];
    for (int i =0; i < ([lastFlipArray count] -1);i++) {
        if ([lastFlipArray[i] isKindOfClass:[SetCard class]]) {
            SetCard* curCard = lastFlipArray[i];
            [attStringArray addObject:[SetCardGameViewController convertSetCardToAttributedString:curCard]];
        } else {
            NSLog(@"Non-SetCard found in lastFlipArray for Set");
        }
    }
    [attStringArray addObject:[lastFlipArray lastObject]];
    return attStringArray;
}

@end
