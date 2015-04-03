//
//  DetailDA.h
//  IMDB
//
//  Created by Alejandro Gómez on 2/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Series.h"

// <summary>
// Declaración del protocolo DetailDADelegate
// </summary>
@protocol DetailDADelegate
@optional
- (void)getSerieInfoDAResponse:(Series *)serie;
@end

// <summary>
// Definición de la interfaz de la clase DetailDA
// </summary>
@interface DetailDA : NSObject

// <summary>
// Declaración del objeto DetailDADelegate
// </summary>
@property (nonatomic, weak) id<DetailDADelegate> delegate;

// <summary>
// Declaración de métodos públicos
// </summary>
- (void)getSerieInfoWithId:(NSString *)idSerie;
- (void)getEpisodesInfoWithId:(NSString *)idSerie withSeason:(int)season withEpisodes:(int)episodes andSerie:(Series *)serie;

@end
