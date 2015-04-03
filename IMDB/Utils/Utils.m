//
//  Utils.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "Utils.h"

// <summary>
// Definición de la implementación de la clase Utils
// </summary>
@implementation Utils

// <summary>
// Define si un caracter es alfanúmerico
// </summary>
// <param name="string">Caracter para definir</param>
// <returns>Si el caracter ingresado es alfanúmerico</returns>
+ (BOOL)isAlphaNumeric:(NSString*)string
{
    NSMutableCharacterSet *unwantedCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [unwantedCharacters invert];
    [unwantedCharacters removeCharactersInString:@"\n"];
    [unwantedCharacters removeCharactersInString:@" "];
    if ([string rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
