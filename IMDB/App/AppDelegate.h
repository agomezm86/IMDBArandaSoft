//
//  AppDelegate.h
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>

// <summary>
// Definición de la interfaz de la clase AppDelegate
// </summary>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

// <summary>
// Objeto de tipo UIWindow con la ventana principal de la aplicación
// </summary>
@property (strong, nonatomic) UIWindow *window;

// <summary>
// Variable con la ruta base para la descarga de imágenes
// </summary>
@property (nonatomic, strong) NSString *imagesBaseUrlString;

@end

