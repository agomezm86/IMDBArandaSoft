//
//  Constants.h
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

// <summary>
// Constantes usadas en la aplicación
// </summary>

#ifndef IMDB_Constants_h
#define IMDB_Constants_h


#pragma mark - Main

// <summary>
// Token para consultas en https://www.themoviedb.org/
// </summary>
#define API_KEY                     @"f8a5df25b94cee05d6d67286102ee63d"

// <summary>
// Ruta base por defecto para las descarga de imagenes
// </summary>
#define kDefaultImagesUrl           @"http://api.themoviedb.org/3"

// <summary>
// Dimensiones del dispositivo
// </summary>
#define SCREEN_WIDTH                (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT               (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define STATUS_BAR_HEIGHT           [UIApplication sharedApplication].statusBarFrame.size.height

// <summary>
// Constantes usadas en la vista principal
// </summary>
#pragma mark - MainViewController
#define kStartImage                 1000
#define kImageCell                  @"ImageCell"
#define kNoResultsFont              @"Verdana"
#define kNoResultsFontSize          24

// <summary>
// Constantes usadas en la vista detallada
// </summary>
#pragma mark - DetailViewController
#define kStartButton                2000
#define kDetailFrameMarginBottom    10
#define kDetailTextOffset           SCREEN_WIDTH * 0.1
#define kDetailTextWidth            SCREEN_WIDTH * 0.8
#define kDetailFrameOffset          SCREEN_WIDTH * 0.05
#define kDetailFrameWidth           SCREEN_WIDTH * 0.9
#define kDetailSeasonScrollHeight   40
#define kDetailSeasonButton         30
#define kDetailButtonFont           @"Verdana"
#define kDetailButtonFontSize       16
#define kDetailBackView             150
#define kDetailEpisodesTag          100
#define kDetailLabelFont            @"Verdana"
#define kDetailLabelFontSize        14
#define kDetailEpisodeHeight        25

// <summary>
// Constantes usadas para lógica
// </summary>
#pragma mark - BL
#define kObjectsPerSearch           9

// <summary>
// Constantes usadas para acceso a datos
// </summary>
#pragma mark - DataAccess
#define kResponseQuery              @"query"
#define kResponseData               @"page"
#define kResponseResults            @"results"
#define kResponseOriginalName       @"original_name"
#define kResponsePosterPath         @"poster_path"
#define kResponseId                 @"id"
#define kResponseGenres             @"genres"
#define kResponseName               @"name"
#define kResponseNumberOfSeasons    @"number_of_seasons"
#define kResponseSeasons            @"seasons"
#define kResponseEpisodeCount       @"episode_count"
#define kResponseSeasonNumber       @"season_number"
#define kResponseEpisodeNumber      @"episode_number"
#define kResponseCast               @"cast"
#define kResponseCharacter          @"character"

// <summary>
// Constantes usadas para la ruta base de las imagenes
// </summary>
#pragma mark - ImagesBaseUrl

#define kImagesBaseUrl              @"imagesBaseUrlString"
#define kImagesBaseUrlImages        @"images"
#define kImagesBaseUrlBaseUrl       @"base_url"
#define kImagesBaseUrlw92           @"w92"

// <summary>
// Constantes usadas para la vista de indicador de actividad
// </summary>
#pragma mark - ActivityIndicator

#define kActivityIndicatorDim   200

#endif
