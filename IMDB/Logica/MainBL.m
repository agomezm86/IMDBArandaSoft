//
//  MainBL.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "MainBL.h"

// <summary>
// Definición de la interfaz de la clase MainBL para variables y métodos privados
// </summary>
@interface MainBL()
{
    // <summary>
    // Variable con el conteo de actualizaciones del infinite scroll
    // </summary>
    int refreshCnt;
}

// <summary>
// Variable de tipo MainDA para acceder a la capa de acceso a datos
// </summary>
@property (nonatomic, strong) MainDA *mainDA;

@end

// <summary>
// Definición de la implementación de la clase MainBL
// </summary>
@implementation MainBL


#pragma mark - Init

// <summary>
// Método de inicialización de la clase
// </summary>
- (id)init
{
    if (self = [super init])
    {
        self.mainDA = [[MainDA alloc] init];
        self.mainDA.delegate = self;
    }
    
    return self;
}


#pragma mark - Public Methods

// <summary>
// Obtener la lista de serie de acuerdo a la búsqueda realizada
// </summary>
// <param name="textString">Texto para búsqueda</param>
// <param name="refreshCount">Contador para la consulta por páginas</param>
- (void)searchWithText:(NSString *)textString refreshCount:(int)refreshCount
{
    refreshCnt = refreshCount;
    [self.mainDA searchWithText:textString refreshCount:refreshCount];
}


#pragma mark - MainDADelegate

// <summary>
// Método del delegado MainDADelegate
// Respuesta con la información de la series obtenidas por búsqueda
// </summary>
// <param name="serie">Objeto con la información de la serie</param>
- (void)searchWithTextDAResponse:(NSArray *)series
{
    NSMutableArray *mutableArray;
    if (refreshCnt == 0)
    {
        //Si es la primera consulta solo debe mostrar las primeras 9 series
        if ([series count] <= kObjectsPerSearch)
        {
            mutableArray = [[NSMutableArray alloc] initWithArray:series];
        }
        else
        {
            mutableArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < kObjectsPerSearch; i++)
            {
                [mutableArray addObject:[series objectAtIndex:i]];
            }
        }
    }
    else
    {
        mutableArray = [[NSMutableArray alloc] initWithArray:series];
    }
    [self.delegate searchWithTextBLResponse:mutableArray];
}


#pragma mark - Memory

// <summary>
// Desalojamiento de objetos de memoria
// </summary>
- (void)dealloc
{
    self.mainDA = nil;
    self.delegate = nil;
}

@end
