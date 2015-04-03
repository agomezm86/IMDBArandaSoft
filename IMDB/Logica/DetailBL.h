//
//  DetailBL.h
//  IMDB
//
//  Created by Alejandro Gómez on 2/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailDA.h"
#import "Series.h"

// <summary>
// Declaración del protocolo DetailBLDelegate
// </summary>
@protocol DetailBLDelegate
@optional
- (void)getSerieInfoBLResponse:(Series *)serie;
@end

// <summary>
// Definición de la interfaz de la clase DetailBL
// </summary>
@interface DetailBL : NSObject <DetailDADelegate>

// <summary>
// Declaración del objeto DetailBLDelegate
// </summary>
@property (nonatomic, weak) id<DetailBLDelegate> delegate;

// <summary>
// Declaración de métodos públicos
// </summary>
- (void)getSerieInfoWithId:(NSString *)idSerie;
- (void)getEpisodesInfoWithId:(NSString *)idSerie withSeason:(int)season withEpisodes:(int)episodes andSerie:(Series *)serie;

@end
