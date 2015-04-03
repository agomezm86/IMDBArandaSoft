//
//  MainDA.h
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>

// <summary>
// Declaración del protocolo MainDADelegate
// </summary>
@protocol MainDADelegate
@optional
- (void)searchWithTextDAResponse:(NSArray *)series;
@end

// <summary>
// Definición de la interfaz de la clase MainDA
// </summary>
@interface MainDA : NSObject

// <summary>
// Declaración del objeto MainDADelegate
// </summary>
@property (nonatomic, weak) id<MainDADelegate> delegate;

// <summary>
// Declaración de métodos públicos
// </summary>
- (void)searchWithText:(NSString *)textString refreshCount:(int)refreshCount;

@end
