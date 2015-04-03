//
//  MainBL.h
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainDA.h"

// <summary>
// Declaración del protocolo MainBLDelegate
// </summary>
@protocol MainBLDelegate
@optional
- (void)searchWithTextBLResponse:(NSArray *)series;
@end

// <summary>
// Definición de la interfaz de la clase MainBL
// </summary>
@interface MainBL : NSObject <MainDADelegate>

// <summary>
// Declaración del objeto MainBLDelegate
// </summary>
@property (nonatomic, weak) id<MainBLDelegate> delegate;

// <summary>
// Declaración de métodos públicos
// </summary>
- (void)searchWithText:(NSString *)textString refreshCount:(int)refreshCount;

@end
