import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/publication.dart';
import '../../domain/usecases/create_publication_usecase.dart';
import '../../domain/usecases/get_publications_usecase.dart';
import '../../domain/usecases/search_publications_usecase.dart';

enum PublicationProviderStatus {
  initial,
  loading,
  loaded,
  error,
}

class PublicationProvider extends ChangeNotifier {

  PublicationProvider({
    required this.getPublicationsUseCase,
    required this.createPublicationUseCase,
    required this.searchPublicationsUseCase,
  });
  final GetPublicationsUseCase getPublicationsUseCase;
  final CreatePublicationUseCase createPublicationUseCase;
  final SearchPublicationsUseCase searchPublicationsUseCase;

  PublicationProviderStatus _status = PublicationProviderStatus.initial;
  List<Publication> _publications = [];
  final List<Publication> _myPublications = [];
  String? _errorMessage;
  bool _isLoading = false;

  final _logger = Logger();

  // Getters
  PublicationProviderStatus get status => _status;
  List<Publication> get publications => List.unmodifiable(_publications);
  List<Publication> get myPublications => List.unmodifiable(_myPublications);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Charger toutes les publications
  Future<bool> getPublications() async {
    _logger.i('PublicationProvider: Début du chargement des publications...');
    
    _isLoading = true;
    _status = PublicationProviderStatus.loading;
    _errorMessage = null;
    notifyListeners(); 

    final result = await getPublicationsUseCase(const NoParams());

    return result.fold(
      (failure) {
        _logger.e(' PublicationProvider: Échec - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _status = PublicationProviderStatus.error;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (publications) {
        _logger.i(' PublicationProvider: ${publications.length} publications chargées');
        _publications = publications;
        _status = PublicationProviderStatus.loaded;
        _isLoading = false;
        notifyListeners();
        
        // afficher les titres
        for (final pub in publications) {
          _logger.d(' ${pub.title} (ID: ${pub.id})');
        }
        
        return true;
      },
    );
  }

  // Rechercher des publications
  Future<bool> searchPublications({
    String? query,
    String? status,
    int? companyId,
    String? tags,
  }) async {
    _logger.i(' PublicationProvider: Recherche de publications...');
    
    _isLoading = true;
    _status = PublicationProviderStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final params = SearchPublicationsParams(
      query: query,
      status: status,
      companyId: companyId,
      tags: tags,
    );

    final result = await searchPublicationsUseCase(params);

    return result.fold(
      (failure) {
        _logger.e(' PublicationProvider: Échec recherche - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _status = PublicationProviderStatus.error;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (publications) {
        _logger.i(' PublicationProvider: ${publications.length} publications trouvées');
        _publications = publications;
        _status = PublicationProviderStatus.loaded;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Créer une nouvelle publication
  Future<bool> createPublication({
    required String title,
    required String content,
    required String status,
    int? companyId,
    String? tags,
    String? imagePath,
  }) async {    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final params = CreatePublicationParams(
      title: title,
      content: content,
      status: status,
      companyId: companyId,
      tags: tags,
      imagePath: imagePath,
    );

    final result = await createPublicationUseCase(params);

    return result.fold(
      (failure) {
        _logger.e(' PublicationProvider: Échec création - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (publication) {
        _logger.i(' PublicationProvider: Publication créée - ${publication.title}');
        _publications = [publication, ..._publications];
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Effacer le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Obtenir une publication par ID
  Publication? getPublicationById(int id) {
    try {
      return _publications.firstWhere((p) => p.id == id);
    } catch (e) {
      _logger.i(' PublicationProvider: Publication introuvable - ID: $id');
      return null;
    }
  }

  // Reset state
  void reset() {
    _status = PublicationProviderStatus.initial;
    _publications = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}