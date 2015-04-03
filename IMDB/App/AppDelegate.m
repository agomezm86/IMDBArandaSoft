//
//  AppDelegate.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "AppDelegate.h"
#import <JLTMDbClient.h>


// <summary>
// Definición de la implementación de la clase AppDelegate
// </summary>
@implementation AppDelegate


#pragma mark - UIApplication

// <summary>
// Método que es llamado por el sistema cuando se lanza la aplicación
// </summary>
// <param name="application">Objeto de clase UIApplication</param>
// <param name="launchOptions">Diccionario con información sobre el lanzamiento de la aplicación</param>
// <returns>Booleano</returns>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Se asigna el API obtenido de la página https://www.themoviedb.org/
    [[JLTMDbClient sharedAPIInstance] setAPIKey:API_KEY];
    [self imagesBaseUrl];
    return YES;
}

// <summary>
// Método que es llamado por el sistema cuando la aplicación vuelve a estar activa
// </summary>
// <param name="application">Objeto de clase UIApplication</param>
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Se asigna el API obtenido de la página https://www.themoviedb.org/
    [[JLTMDbClient sharedAPIInstance] setAPIKey:API_KEY];
    [self imagesBaseUrl];
}


#pragma mark - Public Methods

// <summary>
// Obtener la ruta base para la descarga de imágenes
// </summary>
- (void)imagesBaseUrl
{
    // Si la ruta no existe en NSUserDefaults, se asigna una por defecto
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kImagesBaseUrl] == [NSNull null])
    {
        [[NSUserDefaults standardUserDefaults] setObject:kDefaultImagesUrl forKey:kImagesBaseUrl];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.imagesBaseUrlString = [[NSUserDefaults standardUserDefaults] objectForKey:kImagesBaseUrl];
    
    // Se hace una petición a los servicios para obtener la ruta base
    // Si se obtiene respuesta del servicio se reemplaza la ruta base en NSUserDefaults
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(id response, NSError *error)
     {
         if (!error)
         {
             self.imagesBaseUrlString = [response[kImagesBaseUrlImages][kImagesBaseUrlBaseUrl] stringByAppendingString:kImagesBaseUrlw92];
             [[NSUserDefaults standardUserDefaults] setObject:self.imagesBaseUrlString forKey:kImagesBaseUrl];
             [[NSUserDefaults standardUserDefaults] synchronize];
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
    self.imagesBaseUrlString = nil;
}

@end
