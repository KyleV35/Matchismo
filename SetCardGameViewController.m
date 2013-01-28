//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck*)getAppropriateDeck
{
    return [[SetCardDeck alloc] init];
}

- (void) viewDidLoad
{
    [self.game setNumberOfCardsToMatch:3];
}

@end
