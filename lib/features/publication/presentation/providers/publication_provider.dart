import 'package:flutter/foundation.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/publication.dart';
import '../../domain/usecases/create_publication_usecase.dart';
import '../../domain/usecases/get_publications_usecase.dart';
import '../../domain/usecases/search_publications_usecase.dart';

enum PublicationStatus {
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

  PublicationStatus _status = PublicationStatus.initial;
  List<Publication> _publications = [];
  final List<Publication> _myPublications = [];
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  PublicationStatus get status => _status;
  List<Publication> get publications => _publications;
  List<Publication> get myPublications => _myPublications;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Get all publications
  Future<bool> getPublications() async {
    _setLoading(true);
    _errorMessage = null;

    final result = await getPublicationsUseCase(const NoParams());

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (publications) {
        _publications = publications;
        _status = PublicationStatus.loaded;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Search publications
  Future<bool> searchPublications({
    String? query,
    String? status,
    int? companyId,
    String? tags,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final params = SearchPublicationsParams(
      query: query,
      status: status,
      companyId: companyId,
      tags: tags,
    );

    final result = await searchPublicationsUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (publications) {
        _publications = publications;
        _status = PublicationStatus.loaded;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Create publication
  Future<bool> createPublication({
    required String title,
    required String content,
    required String status,
    int? companyId,
    String? tags,
    String? imagePath,
  }) async {
    _setLoading(true);
    _errorMessage = null;

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
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (publication) {
        _publications.insert(0, publication);
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _status = PublicationStatus.loading;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = PublicationStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get publication by id
  Publication? getPublicationById(int id) {
    try {
      return _publications.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}