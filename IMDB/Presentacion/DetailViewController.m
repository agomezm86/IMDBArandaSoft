//
//  DetailViewController.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "DetailViewController.h"
#import "Series.h"
#import "CustomActivityIndicator.h"

// <summary>
// Definición de la interfaz de la clase DetailViewController para variables y métodos privados
// </summary>
@interface DetailViewController ()

// <summary>
// Instancia de la clase CustomActivityIndicator con el indicador de actividad
// </summary>
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

// <summary>
// Instancia de la clase DetailBL con el acceso a la capa de lógica
// </summary>
@property (nonatomic, strong) DetailBL *detailBL;

// <summary>
// Instancia de la clase Series con la información de la serie
// </summary>
@property (nonatomic, strong) Series *infoSerie;

@end

// <summary>
// Definición de la implementación de la clase DetailViewController
// </summary>
@implementation DetailViewController


#pragma mark - UIViewController

// <summary>
// Método que se llama antes de la carga de la vista
// </summary>
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Inicialización de la instancia de DetailBL
    self.detailBL = [[DetailBL alloc] init];
    self.detailBL.delegate = self;

    //Inicialización de la instancia de CustomActivityIndicator
    self.activityIndicator = [[CustomActivityIndicator alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - (kActivityIndicatorDim / 2), (SCREEN_HEIGHT / 2) - (kActivityIndicatorDim / 2), kActivityIndicatorDim, kActivityIndicatorDim)];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    [self getSerieInfo];
}


#pragma mark - Memory

// <summary>
// Advertir sobre un excesivo consumo de memoria
// </summary>
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// <summary>
// Desalojamiento de objetos de memoria
// </summary>
- (void)dealloc
{
    self.serieId = nil;
    self.activityIndicator = nil;
    self.detailBL = nil;
    self.infoSerie = nil;
}


#pragma mark - Private Methods

// <summary>
// Obtener la información detallada de la serie
// </summary>
- (void)getSerieInfo
{
    [self.detailBL getSerieInfoWithId:self.serieId];
}

// <summary>
// Dibujar un rectangulo de acuerdo a las coordenadas definidas
// </summary>
// <param name="rect">Marco con coordenadas</param>
- (UIImage *)drawRectangle:(CGRect)rect
{
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// <summary>
// Dibujar un rectangulo con texto de acuerdo a las coordenadas definidas
// </summary>
// <param name="rect">Marco con coordenadas</param>
// <param name="text">Texto para dibujar</param>
// <param name="attributes">Atributos del texto</param>
- (UIImage*)drawRectangle:(CGRect)rect withText:(NSString *)text andAttributes:(NSDictionary *)attributes
{
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeRect(context, rect);
    [text drawInRect:CGRectMake(0.0, (rect.size.height / 2) - 10.0, rect.size.width, 20.0) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - UIView

// <summary>
// Borrar las subvistas de la vista principal
// </summary>
- (void)removeSubviews
{
    if (self.view)
    {
        for (UIView *subview in self.view.subviews)
        {
            [subview removeFromSuperview];
        }
    }
}

// <summary>
// Dibujar la vista para la información general de la serie
// </summary>
- (void)paintgeneralView
{
    // Posicion vertical para empezar a dibujar
    float originY = STATUS_BAR_HEIGHT;
    CGSize textSize;
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH * 0.8, 5000);
    
    UIView *generalView = [[UIView alloc] init];
    generalView.tag = 1;
    
    // Label para el nombre de la serie
    UILabel *serieNameLabel = [[UILabel alloc] init];
    serieNameLabel.numberOfLines = 0;
    serieNameLabel.font = [UIFont fontWithName:kDetailLabelFont size:kDetailLabelFontSize];
    serieNameLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Name", nil), self.infoSerie.name];
    textSize = [serieNameLabel sizeThatFits:maximumLabelSize];
    serieNameLabel.frame = CGRectMake(kDetailTextOffset, originY, kDetailTextWidth, textSize.height);
    [generalView addSubview:serieNameLabel];
    originY += serieNameLabel.frame.size.height;
    
    // Label para los géneros de la serie
    UILabel *serieGenreLabel = [[UILabel alloc] init];
    serieGenreLabel.numberOfLines = 0;
    serieGenreLabel.font = [UIFont fontWithName:kDetailLabelFont size:kDetailLabelFontSize];
    serieGenreLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Genres", nil), [[self.infoSerie.genres allObjects] componentsJoinedByString:@", "]];
    textSize = [serieGenreLabel sizeThatFits:maximumLabelSize];
    serieGenreLabel.frame = CGRectMake(kDetailTextOffset, originY, kDetailTextWidth, textSize.height);
    [generalView addSubview:serieGenreLabel];
    originY += serieGenreLabel.frame.size.height;
    
    // Label para los actores de la serie
    UILabel *serieActorsLabel = [[UILabel alloc] init];
    serieActorsLabel.numberOfLines = 0;
    serieActorsLabel.font = [UIFont fontWithName:kDetailLabelFont size:kDetailLabelFontSize];
    serieActorsLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Actors", nil), [[self.infoSerie.actors allObjects] componentsJoinedByString:@", "]];
    textSize = [serieActorsLabel sizeThatFits:maximumLabelSize];
    serieActorsLabel.frame = CGRectMake(kDetailTextOffset, originY, kDetailTextWidth, textSize.height);
    [generalView addSubview:serieActorsLabel];
    originY += serieActorsLabel.frame.size.height;
    
    // Dibujar el cuadro que encierra la información general
    CGRect rectangle = CGRectMake(0.0, 0.0, kDetailFrameWidth, originY + kDetailFrameMarginBottom);
    UIImage *image = [self drawRectangle:rectangle];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(kDetailFrameOffset, 0.0, image.size.width, image.size.height);
    imageView.image = image;
    [generalView addSubview:imageView];
    originY += kDetailFrameMarginBottom;
    
    generalView.frame = CGRectMake(0.0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, originY);
    [self.view addSubview:generalView];
}

// <summary>
// Dibujar la vista para la información de las temporadas y episodios de la serie
// </summary>
- (void)paintEpisodesView
{
    // Posicion vertical para empezar a dibujar
    float originY = STATUS_BAR_HEIGHT;
    CGSize textSize;
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH, 1000);
    
    UIView *generalView = (UIView *)[self.view viewWithTag:1];
    
    UIView *episodesView = [[UIView alloc] init];
    episodesView.tag = 2;
    
    // Label para la palabra "Episodios"
    UILabel *episodesLabel = [[UILabel alloc] init];
    episodesLabel.numberOfLines = 0;
    episodesLabel.text = NSLocalizedString(@"Episodes", nil);
    textSize = [episodesLabel sizeThatFits:maximumLabelSize];
    episodesLabel.frame = CGRectMake(kDetailTextOffset, originY, kDetailTextWidth, textSize.height);
    [episodesView addSubview:episodesLabel];
    originY += episodesLabel.frame.size.height + kDetailFrameMarginBottom;
    
    // Scroll para el número de temporadas de la serie
    UIScrollView *seasonsScrollView = [[UIScrollView alloc] init];
    seasonsScrollView.frame = CGRectMake(kDetailTextOffset, originY, kDetailTextWidth, kDetailSeasonScrollHeight);
    
    UIFont *font = [UIFont fontWithName:kDetailButtonFont size:kDetailButtonFontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    float scrollOriginX = 0;
    // Se dibuja el recuadro con texto para cada una de las temporadas
    for (int i = 0; i < [self.infoSerie.seasons intValue]; i++)
    {
        CGRect rectangle = CGRectMake(0.0, 0.0, kDetailSeasonButton, kDetailSeasonButton);
        UIImage *image = [self drawRectangle:rectangle withText:[NSString stringWithFormat:@"%d", i+1] andAttributes:attributes];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kStartButton + i;
        button.frame = CGRectMake(scrollOriginX, 0.0, kDetailSeasonButton, kDetailSeasonButton);
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(seasonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [seasonsScrollView addSubview:button];
        scrollOriginX += kDetailSeasonScrollHeight;
    }
    
    // Se ajusta el tamaño del contenido del scroll
    // Para hacerlo visible así se salga de los márgenes de la supervista
    seasonsScrollView.contentSize = CGSizeMake(scrollOriginX, seasonsScrollView.frame.size.height);
    [episodesView addSubview:seasonsScrollView];
    originY += seasonsScrollView.frame.size.height;
    
    // Scroll para la lista de episodios
    UIScrollView *episodesScrollView = [[UIScrollView alloc] init];
    episodesScrollView.tag = kDetailEpisodesTag;
    
    float scrollOriginY = 0;
    for (int i = 0; i < [self.infoSerie.nameEpisodes count]; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:kDetailLabelFont size:kDetailLabelFontSize];
        label.frame = CGRectMake(0.0, scrollOriginY, kDetailTextWidth, kDetailEpisodeHeight);
        label.text = [NSString stringWithFormat:@"%d. %@", i+1, [self.infoSerie.nameEpisodes objectAtIndex:i]];
        [episodesScrollView addSubview:label];
        scrollOriginY += label.frame.size.height;
    }
    
    // Se ajusta el tamaño del contenido del scroll
    // Para hacerlo visible así se salga de los márgenes de la supervista
    episodesScrollView.frame = CGRectMake(kDetailTextOffset, originY, kDetailTextWidth, SCREEN_HEIGHT - generalView.frame.size.height - seasonsScrollView.frame.size.height - kDetailBackView);
    episodesScrollView.contentSize = CGSizeMake(episodesScrollView.frame.size.width, scrollOriginY);
    [episodesView addSubview:episodesScrollView];
    originY += episodesScrollView.frame.size.height;
    
    // Dibujar el cuadro que encierra la información general
    CGRect rectangle = CGRectMake(0.0, 0.0, kDetailFrameWidth, originY + STATUS_BAR_HEIGHT);
    UIImage *image = [self drawRectangle:rectangle];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(kDetailFrameOffset, 0.0, image.size.width, image.size.height);
    imageView.image = image;
    [episodesView addSubview:imageView];
    
    episodesView.frame = CGRectMake(0.0, generalView.frame.origin.x + generalView.frame.size.height + (STATUS_BAR_HEIGHT * 1.5), SCREEN_WIDTH, originY);
    
    [self.view addSubview:episodesView];
}

// <summary>
// Dibujar la vista para el botón de regresar
// </summary>
- (void)paintBackView
{
    UIView *episodesView = (UIView *)[self.view viewWithTag:2];
    
    // Vista para el bóton de regresar
    UIView *backView = [[UIView alloc] init];
    backView.tag = 3;
    backView.frame = CGRectMake(0.0, episodesView.frame.origin.y + episodesView.frame.size.height + (STATUS_BAR_HEIGHT * 1.5), SCREEN_WIDTH, kDetailSeasonButton);
    
    UIFont *font = [UIFont fontWithName:kDetailButtonFont size:kDetailButtonFontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // Dibujar el cuadro con el texto "Regresar"
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGRect rectangle = CGRectMake(0.0, 0.0, SCREEN_WIDTH * 0.3, backView.frame.size.height);
    UIImage *image = [self drawRectangle:rectangle withText:NSLocalizedString(@"Back", nil) andAttributes:attributes];
    UIGraphicsEndImageContext();

    // Botón de regresar
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH * 0.65, 0.0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    [self.view addSubview:backView];
}


#pragma mark - DetailBLDelegate

// <summary>
// Método del delegado DetailBLDelegate
// Respuesta con la información detallada de la serie
// </summary>
// <param name="serie">Objeto con la información de la serie</param>
- (void)getSerieInfoBLResponse:(Series *)serie
{
    self.infoSerie = serie;
    [self.activityIndicator stopAnimating];
    [self removeSubviews];
    [self paintgeneralView];
    [self paintEpisodesView];
    [self paintBackView];
}


#pragma mark - UIButton

// <summary>
// Temporada de la serie seleccionada
// </summary>
// <param name="sender">Objeto que envia el mensaje al selector</param>
- (void)seasonSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int seasonSelected = (int)button.tag - kStartButton;
    [self.detailBL getEpisodesInfoWithId:self.serieId withSeason:seasonSelected withEpisodes:[[self.infoSerie.numberEpisodes objectForKey:[NSNumber numberWithInt:1]] intValue] andSerie:self.infoSerie];
    
    UIView *episodesView = (UIView *)[self.view viewWithTag:2];
    UIScrollView *episodesScrollView = (UIScrollView *)[self.view viewWithTag:kDetailEpisodesTag];
    for (UIView *subview in episodesView.subviews)
    {
        if (subview == episodesScrollView)
        {
            [episodesScrollView removeFromSuperview];
        }
    }
    
    self.activityIndicator = [[CustomActivityIndicator alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - (kActivityIndicatorDim / 2), (SCREEN_HEIGHT / 2) - (kActivityIndicatorDim / 2), kActivityIndicatorDim, kActivityIndicatorDim)];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

// <summary>
// Volver a la vista principal
// </summary>
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
