//
//  MainViewController.m
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "Series.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "ImageCell.h"
#import "CustomActivityIndicator.h"
#import <UIImageView+AFNetworking.h>
#import "UIScrollView+InfiniteScroll.h"

// <summary>
// Definición de la interfaz de la clase MainViewController para variables y métodos privados
// </summary>
@interface MainViewController ()
{
    // <summary>
    // Variable con el conteo de actualizaciones del infinite scroll
    // </summary>
    int refreshCount;
}

// <summary>
// Buscador de la vista
// </summary>
@property (weak, nonatomic) IBOutlet UISearchBar *IMDBSearchBar;

// <summary>
// Para presentar la lista de series
// </summary>
@property (weak, nonatomic) IBOutlet UICollectionView *IMDBCollectionView;

// <summary>
// Vista que se presenta cuando la búsqueda no genera resultados
// </summary>
@property (nonatomic, strong) UIView *noResultsView;

// <summary>
// Arreglo con la lista de series
// </summary>
@property (nonatomic, strong) NSMutableArray *seriesArray;

// <summary>
// Instancia de la clase MainBL con el acceso a la capa de lógica
// </summary>
@property (nonatomic, strong) MainBL *mainBL;

// <summary>
// Instancia de la clase AppDelegate con acceso al delegado principal de la aplicación
// </summary>
@property (nonatomic, strong) AppDelegate *appDelegate;

// <summary>
// Instancia de la clase CustomActivityIndicator con el indicador de actividad
// </summary>
@property (nonatomic, strong) CustomActivityIndicator *activityIndicator;

@end


// <summary>
// Definición de la implementación de la clase MainViewController
// </summary>
@implementation MainViewController


#pragma mark - UIViewController

// <summary>
// Método que se llama antes de la carga de la vista
// </summary>
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    refreshCount = 0;
    self.navigationController.navigationBarHidden = YES;
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Inicialización de la instancia de MainBL
    self.mainBL = [[MainBL alloc] init];
    self.mainBL.delegate = self;
    
    //Inicialización de la instancia de CustomActivityIndicator
    self.activityIndicator = [[CustomActivityIndicator alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - (kActivityIndicatorDim / 2), (SCREEN_HEIGHT / 2) - (kActivityIndicatorDim / 2), kActivityIndicatorDim, kActivityIndicatorDim)];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator setHidden:YES];
    
    self.seriesArray = [[NSMutableArray alloc] init];
    
    [self addInfiniteScrollHandler];
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
    self.IMDBSearchBar = nil;
    self.IMDBCollectionView = nil;
    self.noResultsView = nil;
    
    self.seriesArray = nil;
    
    self.mainBL = nil;
    self.appDelegate = nil;
    self.activityIndicator = nil;
}


#pragma mark - UICollectionView

// <summary>
// Definir el número de items a presentar en la vista
// </summary>
// <param name="collectionView">Vista de tipo UICollectionView</param>
// <param name="section">Número de la sección (por defecto 0)</param>
// <returns>El número de items a presentar</returns>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.seriesArray count];
}

// <summary>
// Definir la presentación de las celdas de la vista
// </summary>
// <param name="collectionView">Vista de tipo UICollectionView</param>
// <param name="indexPath">Número del índice</param>
// <returns>Objeto de tipo UICollectionViewCell</returns>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kImageCell forIndexPath:indexPath];
    
    Series *serie = [self.seriesArray objectAtIndex:indexPath.item];
    // Si no hay información sobre la imagen se presenta una por defecto
    if ([serie.image length] == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"no_disponible.png"];
    }
    else
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[[self.appDelegate imagesBaseUrlString] stringByAppendingString:serie.image]]];
    }
    cell.imageView.tag = kStartImage + indexPath.item;
    cell.label.text = serie.name;
    
    // Se agrega un detector de toques para las imagenes para pasar a la vista detallada
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [cell.imageView setUserInteractionEnabled:YES];
    [cell.imageView addGestureRecognizer:tapGestureRecognizer];
    
    cell.layer.borderWidth = 3.0;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    return cell;
}

// <summary>
// Definir el tamaño de las celdas de la vista
// </summary>
// <param name="collectionView">Vista de tipo UICollectionView</param>
// <param name="collectionViewLayout">Objeto de tipo UICollectionViewLayout</param>
// <param name="indexPath">Número del índice</param>
// <returns>El tamaño de la celda</returns>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat itemWidth = collectionWidth * 0.48;
    
    return CGSizeMake(itemWidth, itemWidth);
}


#pragma mark - UISearchBar

// <summary>
// Ingresar un caracter en la barra de búsqueda
// </summary>
// <param name="searchBar">Barra de búsqueda</param>
// <param name="range">Rango en el que se ingresa el texto</param>
// <param name="text">Texto</param>
// <returns>Booleano que indica si se ingresa el texto</returns>
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0 && range.length > 0)
    {
        return YES;
    }
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    
    if ([Utils isAlphaNumeric:text])
    {
        refreshCount = 0;
        if (self.noResultsView)
        {
            [self.noResultsView removeFromSuperview];
        }
        [self.seriesArray removeAllObjects];
        [self.IMDBCollectionView reloadData];
        return YES;
    }
    else
    {
        return NO;
    }
}

// <summary>
// Presionar el botón buscar de la barra de búsqueda
// </summary>
// <param name="searchBar">Barra de búsqueda</param>
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Ocultar la barra de búsqueda
    if ([self.IMDBSearchBar isFirstResponder])
    {
        [self.IMDBSearchBar resignFirstResponder];
    }
    
    // Presentar el indicador de actividad
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.mainBL searchWithText:self.IMDBSearchBar.text refreshCount:refreshCount];
}


#pragma mark - MainBLDelegate

// <summary>
// Método del delegado MainBLDelegate
// Respuesta con la lista de series
// </summary>
// <param name="array">Objeto con la lista de series</param>
- (void)searchWithTextBLResponse:(NSArray *)series
{
    // Ocultar el indicador de actividad
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    // Si es la segunda vez que se actualiza el CollectionView
    // Se borra todo el contenido
    if (refreshCount == 1)
    {
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < self.seriesArray.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        [self.seriesArray removeAllObjects];
        [self.IMDBCollectionView deleteItemsAtIndexPaths:indexPaths];
    }
    
    // Insertar los nuevos objetos al arreglo de las series
    NSMutableArray *newIndexPaths = [NSMutableArray new];
    NSInteger firstIndex = self.seriesArray.count;
    for (int i = 0; i < series.count; i++)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:firstIndex + i inSection:0];
        [newIndexPaths addObject:indexPath];
    }
    
    [self.seriesArray addObjectsFromArray:series];
    [self.IMDBCollectionView insertItemsAtIndexPaths:newIndexPaths];
    refreshCount++;
    
    // Si no hay objetos para la búsqueda se presenta la vista correspondiente
    if ([self.seriesArray count] == 0)
    {
        [self showNoResults];
    }
}


#pragma mark - InfiniteScroll

// <summary>
// Manejar la funcionalidad de infinite scroll
// </summary>
- (void)addInfiniteScrollHandler
{
    [self.IMDBCollectionView addInfiniteScrollWithHandler:^(UICollectionView* collectionView)
    {
        [collectionView performBatchUpdates:^
        {
            [self.mainBL searchWithText:self.IMDBSearchBar.text refreshCount:refreshCount];
        } completion:^(BOOL finished)
        {
            [collectionView finishInfiniteScroll];
        }];
    }];
}


#pragma mark - UITapGestureRecognizer

// <summary>
// Serie seleccionada para presentar la vista detallada
// </summary>
// <param name="sender">Objeto que envia el mensaje al selector</param>
- (void)imageSelected:(id)sender
{
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    Series *serie = (Series *)[self.seriesArray objectAtIndex:tapGestureRecognizer.view.tag - kStartImage];
    NSString *serieId = serie.ide;
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.serieId = serieId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - Private Methods

// <summary>
// Crear la vista que se presenta cuando la busqueda no retorna resultados
// </summary>
- (void)showNoResults
{
    self.noResultsView = [[UIView alloc] init];
    self.noResultsView.frame = self.IMDBCollectionView.frame;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0.0, self.noResultsView.frame.size.height / 2, self.noResultsView.frame.size.width, 100.0);
    label.text = NSLocalizedString(@"NoResults", nil);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:kNoResultsFont size:kNoResultsFontSize];
    label.numberOfLines = 0;
    [self.noResultsView addSubview:label];
    
    [self.view addSubview:self.noResultsView];
}

@end
