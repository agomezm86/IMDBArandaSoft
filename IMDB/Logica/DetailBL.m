//
//  DetailBL.m
//  IMDB
//
//  Created by Alejandro Gómez on 2/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "DetailBL.h"

// <summary>
// Definición de la interfaz de la clase DetailBL para variables y métodos privados
// </summary>
@interface DetailBL()

// <summary>
// Variable de tipo DetailDA para acceder a la capa de acceso a datos
// </summary>
@property (nonatomic, strong) DetailDA *detailDA;

@end


// <summary>
// Definición de la implementación de la clase DetailBL
// </summary>
@implementation DetailBL


#pragma mark - Init

// <summary>
// Método de inicialización de la clase
// </summary>
- (id)init
{
    if (self = [super init])
    {
        self.detailDA = [[DetailDA alloc] init];
        self.detailDA.delegate = self;
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
    [self.detailDA getSerieInfoWithId:idSerie];
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
    [self.detailDA getEpisodesInfoWithId:idSerie withSeason:season withEpisodes:episodes andSerie:serie];
}


#pragma mark - DetailDADelegate

// <summary>
// Método del delegado DetailDADelegate
// Respuesta con la información detallada de la serie
// </summary>
// <param name="serie">Objeto con la información de la serie</param>
- (void)getSerieInfoDAResponse:(Series *)serie
{
    [self.delegate getSerieInfoBLResponse:serie];
}


#pragma mark - Memory

// <summary>
// Desalojamiento de objetos de memoria
// </summary>
- (void)dealloc
{
    self.delegate = nil;
    self.detailDA = nil;
}

@end
