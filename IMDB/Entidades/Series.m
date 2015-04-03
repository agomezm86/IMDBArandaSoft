//
//  Series.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "Series.h"

// <summary>
// Definición de la implementación de la clase Series
// </summary>
@implementation Series


// <summary>
// Método de inicialización de la clase
// </summary>
// <param name="serieName">Nombre de la serie</param>
// <param name="serieImage">Imagen de la serie</param>
// <param name="serieId">ID de la serie</param>
// <param name="serieGenres">Géneros de la serie</param>
// <param name="serieActors">Actores de la serie</param>
// <param name="serieSeasons">Número de temporadas de la serie</param>
// <param name="serieNumberEpisodes">Número de episodios por temporada de la serie</param>
// <param name="serieNameEpisodes">Nombre de los episodios de la serie</param>
// <returns>Objeto de la clase Serie</returns>
- (id)initWithAttributes:(NSString *)serieName image:(NSString *)serieImage serieId:(NSString *)serieId genres:(NSSet *)serieGenres actors:(NSSet *)serieActors seasons:(NSNumber *)serieSeasons numberEpisodes:(NSDictionary *)serieNumberEpisodes nameEpisodes:(NSArray *)serieNameEpisodes
{
    self.name = serieName;
    self.image = serieImage;
    self.ide = serieId;
    self.genres = serieGenres;
    self.actors = serieActors;
    self.seasons = serieSeasons;
    self.numberEpisodes = serieNumberEpisodes;
    self.nameEpisodes = serieNameEpisodes;
    
    return self;
}

@end
