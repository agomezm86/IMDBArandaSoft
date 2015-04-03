//
//  MainDA.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "MainDA.h"
#import "Series.h"
#import <JLTMDbClient.h>


// <summary>
// Definición de la implementación de la clase MainDA
// </summary>
@implementation MainDA



#pragma mark - Public Methods

// <summary>
// Obtener la lista de serie de acuerdo a la búsqueda realizada
// </summary>
// <param name="textString">Texto para búsqueda</param>
// <param name="refreshCount">Contador para la consulta por páginas</param>
- (void)searchWithText:(NSString *)textString refreshCount:(int)refreshCount
{
    // Si el contador está en 0 o 1 es porque debe consultar la página 1
    int page = 1;
    if (refreshCount > 0)
    {
        page = refreshCount;
    }
    NSMutableArray *seriesArray = [[NSMutableArray alloc] init];
    
    NSArray *optionsArray = [NSArray arrayWithObjects:kJLTMDbSearchTV, nil];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:textString forKey:kResponseQuery];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKeyedSubscript:kResponseData];
    
    //Se hace la petición a los servicios para obtener la información de las series
    [[JLTMDbClient sharedAPIInstance] GET:optionsArray[arc4random() % [optionsArray count]] withParameters:parameters andResponseBlock: ^(id response, NSError *error)
     {
         if (!error)
         {
             NSArray *resultsArray = [NSArray arrayWithArray:[response objectForKey:kResponseResults]];
             
             for (NSDictionary *dictionary in resultsArray)
             {
                 Series *serie = [[Series alloc] init];
                 serie.name = [dictionary objectForKey:kResponseOriginalName] == [NSNull null] ? @"" : [dictionary objectForKey:kResponseOriginalName];
                 serie.image = [dictionary objectForKey:kResponsePosterPath] == [NSNull null] ? @"" : [dictionary objectForKey:kResponsePosterPath];
                 serie.ide = [dictionary objectForKey:kResponseId];
                 [seriesArray addObject:serie];
             }
             
             [self.delegate searchWithTextDAResponse:seriesArray];
         }
         else
         {
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Try", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
             [errorAlertView show];
         }
     }];
}


#pragma mark - Memory

// <summary>
// Desalojamiento de objetos de memoria
// </summary>
- (void)dealloc
{
    self.delegate = nil;
}

@end
