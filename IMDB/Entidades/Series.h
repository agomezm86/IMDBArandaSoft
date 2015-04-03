//
//  Series.h
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>

// <summary>
// Definición de la interfaz de la clase Series
// </summary>
@interface Series : NSObject

// <summary>
// Nombre
// </summary>
@property (nonatomic, strong) NSString *name;

// <summary>
// Imagen
// </summary>
@property (nonatomic, strong) NSString *image;

// <summary>
// ID
// </summary>
@property (nonatomic, strong) NSString *ide;

// <summary>
// Géneros
// </summary>
@property (nonatomic, strong) NSSet *genres;

// <summary>
// Actores
// </summary>
@property (nonatomic, strong) NSSet *actors;

// <summary>
// Número de temporadas
// </summary>
@property (nonatomic, strong) NSNumber *seasons;

// <summary>
// Número de episodios por temporada
// </summary>
@property (nonatomic, strong) NSDictionary *numberEpisodes;

// <summary>
// Nombre de los episodios
// </summary>
@property (nonatomic, strong) NSArray *nameEpisodes;

// <summary>
// Declaración de métodos públicos
// </summary>
- (id)initWithAttributes:(NSString *)serieName image:(NSString *)serieImage serieId:(NSString *)serieId genres:(NSSet *)serieGenres actors:(NSSet *)serieActors seasons:(NSNumber *)serieSeasons numberEpisodes:(NSDictionary *)serieNumberEpisodes nameEpisodes:(NSArray *)serieNameEpisodes;

@end
