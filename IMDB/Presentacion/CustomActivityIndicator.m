//
//  CustomActivityIndicator.m
//  IMDB
//
//  Created by Alejandro Gómez on 2/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "CustomActivityIndicator.h"

// <summary>
// Definición de la interfaz de la clase CustomActivityIndicator para variables y métodos privados
// </summary>
@interface CustomActivityIndicator()

// <summary>
// Objeto de tipo UIActivityIndicatorView
// </summary>
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

// <summary>
// Definición de la implementación de la clase CustomActivityIndicator
// </summary>
@implementation CustomActivityIndicator


#pragma mark - Init

// <summary>
// Método de inicialización de la clase
// </summary>
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.activityIndicator = [[UIActivityIndicatorView alloc] init];
        self.activityIndicator.frame = self.bounds;
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:self.activityIndicator];
    }
    
    return self;
}


#pragma mark - Public Methods

// <summary>
// Iniciar la animácion de indicador de actividad
// </summary>
- (void)startAnimating
{
    [self.activityIndicator startAnimating];
}

// <summary>
// Detener la animácion de indicador de actividad
// </summary>
- (void)stopAnimating
{
    [self.activityIndicator stopAnimating];
}


#pragma mark - Memory

// <summary>
// Desalojamiento de objetos de memoria
// </summary>
- (void)dealloc
{
    self.activityIndicator = nil;
}

@end
