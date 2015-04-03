//
//  DetailDA.m
//  IMDB
//
//  Created by Alejandro Gómez on 2/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "DetailDA.h"
#import <JLTMDbClient.h>


// <summary>
// Definición de la interfaz de la clase DetailDA para variables y métodos privados
// </summary>
@interface DetailDA()

// <summary>
// Variable de tipo Series para almacenar información sobre la serie
// </summary>
@property (nonatomic, strong) Series *infoSerie;

// <summary>
// Arreglo mutable con los nombres de los episodios consultados
// </summary>
@property (nonatomic, strong) NSMutableArray *nameEpisodes;

@end

// <summary>
// Definición de la implementación de la clase DetailDA
// </summary>
@implementation DetailDA


#pragma mark - Init

// <summary>
// Método de inicialización de la clase
// </summary>
- (id)init
{
    if (self = [super init])
    {
        self.infoSerie = [[Series alloc] init];
    }
    
    return self;
}


#pragma mark - Public Methods

// <summary>
// Obtener la información básica de la serie
// </summary>
// <param name="idSerie">Identificador único de la serie</param>
- (void)getSerieInfoWithId:(NSString *)idSerie
{
    NSArray *optionsArray = [NSArray arrayWithObjects:kJLTMDbTV, nil];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:idSerie forKey:kResponseId];
    
    //Se hace la petición a los servicios para obtener la información básica de la serie
    [[JLTMDbClient sharedAPIInstance] GET:optionsArray[arc4random() % [optionsArray count]] withParameters:parameters andResponseBlock:^(id response, NSError *error)
     {
         if (!error)
         {
             //Nombre de la serie
             self.infoSerie.name = [response objectForKey:kResponseOriginalName] == [NSNull null] ? @"" : [response objectForKey:kResponseOriginalName];
             
             //Géneros de la serie
             if ([response objectForKey:kResponseGenres] != [NSNull null])
             {
                 NSMutableSet *set = [[NSMutableSet alloc] init];
                 NSArray *genresArray = [NSArray arrayWithArray:[[response objectForKey:kResponseGenres] allObjects]];
                 for (NSDictionary *dictionary in genresArray)
                 {
                     [set addObject:[dictionary objectForKey:kResponseName]];
                 }
                 self.infoSerie.genres = set;
             }
             
             //Número de temporadas de la serie
             self.infoSerie.seasons = [response objectForKey:kResponseNumberOfSeasons] == [NSNull null] ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:[[response objectForKey:kResponseNumberOfSeasons] intValue]];
             
             //Número de episodios por temporada de la serie
             if ([response objectForKey:kResponseSeasons] != [NSNull null])
             {
                 NSArray *seasonsArray = [NSArray arrayWithArray:[[response objectForKey:kResponseSeasons] allObjects]];
                 NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
                 for (NSDictionary *dictionary in seasonsArray)
                 {
                     [mutableDictionary setObject:[dictionary objectForKey:kResponseEpisodeCount] forKey:[dictionary objectForKey:kResponseSeasonNumber]];
                 }
                 self.infoSerie.numberEpisodes = mutableDictionary;
             }

             [self getActorsSerieInfoWithId:idSerie];
         }
         else
         {
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Try", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
             [errorAlertView show];
         }
     }];
}

// <summary>
// Obtener la información sobre los episodios por temporada de la serie
// </summary>
// <param name="idSerie">Identificador único de la serie</param>
// <param name="season">Número de la temporada</param>
// <param name="episodes">Número de episodios de la temporada</param>
// <param name="serie">Instancia del objeto de tipo Serie con la información de la serie</param>
- (void)getEpisodesInfoWithId:(NSString *)idSerie withSeason:(int)season withEpisodes:(int)episodes andSerie:(Series *)serie
{
    self.nameEpisodes = [[NSMutableArray alloc] init];
    
    // Si la serie no tiene información sobre los episodios se devuelve una respuesta vacia
    if (episodes == 0)
    {
        self.infoSerie.nameEpisodes = self.nameEpisodes;
        [self.delegate getSerieInfoDAResponse:self.infoSerie];
    }
    else
    {
        // Se debe consultar información de los episodios de a uno en uno
        for (int i = 0; i < episodes; i++)
        {
            NSArray *optionsArray = [NSArray arrayWithObjects:kJLTMDbTVEpisodes, nil];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:idSerie forKey:kResponseId];
            [parameters setObject:[NSString stringWithFormat:@"%d", season] forKey:kResponseSeasonNumber];
            [parameters setObject:[NSString stringWithFormat:@"%d", i+1] forKey:kResponseEpisodeNumber];
            
            [[JLTMDbClient sharedAPIInstance] GET:optionsArray[arc4random() % [optionsArray count]] withParameters:parameters andResponseBlock:^(id response, NSError *error)
             {
                 if (!error)
                 {
                     if ([response objectForKey:kResponseName] != [NSNull null])
                     {
                         [self.nameEpisodes addObject:[response objectForKey:kResponseName]];
                     }
                     
                     if (i+1 == episodes)
                     {
                         self.infoSerie.nameEpisodes = self.nameEpisodes;
                         [self.delegate getSerieInfoDAResponse:self.infoSerie];
                     }
                 }
             }];
        }
    }
}


#pragma mark - Private Methods

// <summary>
// Obtener la información de los actores de la serie
// </summary>
// <param name="idSerie">Identificador único de la serie</param>
- (void)getActorsSerieInfoWithId:(NSString *)idSerie
{
    NSArray *optionsArray = [NSArray arrayWithObjects:kJLTMDbTVCredits, nil];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:idSerie forKey:kResponseId];
    
    //Se hace la petición a los servicios para obtener la información de los créditos de la serie
    [[JLTMDbClient sharedAPIInstance] GET:optionsArray[arc4random() % [optionsArray count]] withParameters:parameters andResponseBlock:^(id response, NSError *error)
     {
         if (!error)
         {
             if ([response objectForKey:kResponseCast] != [NSNull null])
             {
                 NSMutableSet *set = [[NSMutableSet alloc] init];
                 NSArray *actorsArray = [NSArray arrayWithArray:[[response objectForKey:kResponseCast] allObjects]];
                 for (NSDictionary *dictionary in actorsArray)
                 {
                     // Solo se ingresan en el set de actores a los que tengan como rol "Character"
                     if ([dictionary objectForKey:kResponseCharacter] != [NSNull null])
                     {
                         [set addObject:[dictionary objectForKey:kResponseName]];
                     }
                 }
                 self.infoSerie.actors = set;
             }
             
             [self getEpisodesInfoWithId:idSerie withSeason:1 withEpisodes:[[self.infoSerie.numberEpisodes objectForKey:[NSNumber numberWithInt:1]] intValue] andSerie:self.infoSerie];
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
    self.infoSerie = nil;
    self.nameEpisodes = nil;
}

@end
