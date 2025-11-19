import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/company.dart';
import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/usecases/delete_company_usecase.dart';
import '../../domain/usecases/get_companies_usecase.dart';
import '../../domain/usecases/toggle_company_status_usecase.dart';
import '../../domain/usecases/update_company_usecase.dart';

enum CompanyProviderStatus {
  initial,
  loading,
  loaded,
  error,
}

class CompanyProvider extends ChangeNotifier {

  CompanyProvider({
    required this.getCompaniesUseCase,
    required this.createCompanyUseCase,
    required this.updateCompanyUseCase,
    required this.deleteCompanyUseCase,
    required this.toggleCompanyStatusUseCase,
  });
  final GetCompaniesUseCase getCompaniesUseCase;
  final CreateCompanyUseCase createCompanyUseCase;
  final UpdateCompanyUseCase updateCompanyUseCase;
  final DeleteCompanyUseCase deleteCompanyUseCase;
  final ToggleCompanyStatusUseCase toggleCompanyStatusUseCase;

  CompanyProviderStatus _status = CompanyProviderStatus.initial;
  List<Company> _companies = [];
  String? _errorMessage;
  bool _isLoading = false;

  final _logger = Logger();

  // Getters
  CompanyProviderStatus get status => _status;
  List<Company> get companies => List.unmodifiable(_companies);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Obtenir la liste des entreprises
  Future<bool> getCompanies() async {
    _logger.i(' CompanyProvider: Début du chargement des entreprises...');
    
    _isLoading = true;
    _status = CompanyProviderStatus.loading;
    _errorMessage = null;
    notifyListeners(); 

    final result = await getCompaniesUseCase(const NoParams());

    return result.fold(
      (failure) {
        _logger.e(' CompanyProvider: Échec - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _status = CompanyProviderStatus.error;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (companies) {
        _logger.i(' CompanyProvider: ${companies.length} entreprises chargées');
        _companies = companies;
        _status = CompanyProviderStatus.loaded;
        _isLoading = false;
        notifyListeners(); 
        
        _logger.d(' CompanyProvider: Liste des entreprises:');
        for (final company in companies) {
          _logger.d(' ${company.name} (ID: ${company.id})');
        }
        
        return true;
      },
    );
  }

  // Créer une nouvelle entreprise
  Future<bool> createCompany({
    required String name,
    required String cfeNumber,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
  }) async {
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final params = CreateCompanyParams(
      name: name,
      cfeNumber: cfeNumber,
      address: address,
      phone: phone,
      email: email,
      description: description,
      website: website,
    );

    final result = await createCompanyUseCase(params);

    return result.fold(
      (failure) {
        _logger.e(' CompanyProvider: Échec création - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (company) {
        _logger.i(' CompanyProvider: Entreprise créée - ${company.name}');
        _companies = [company, ..._companies];
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Mettre à jour une entreprise
  Future<bool> updateCompany({
    required int id,
    required String name,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
    bool? isActive,
  }) async {
    _logger.i(' CompanyProvider: Mise à jour entreprise ID: $id');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final params = UpdateCompanyParams(
      id: id,
      name: name,
      address: address,
      phone: phone,
      email: email,
      description: description,
      website: website,
      isActive: isActive,
    );

    final result = await updateCompanyUseCase(params);

    return result.fold(
      (failure) {
        _logger.e(' CompanyProvider: Échec mise à jour - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (company) {
        _logger.i(' CompanyProvider: Entreprise mise à jour - ${company.name}');
        final index = _companies.indexWhere((c) => c.id == id);
        if (index != -1) {
          _companies[index] = company;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Supprimer une entreprise
  Future<bool> deleteCompany(int id) async {
    _logger.i(' CompanyProvider: Suppression entreprise ID: $id');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final params = DeleteCompanyParams(id: id);
    final result = await deleteCompanyUseCase(params);

    return result.fold(
      (failure) {
        _logger.e(' CompanyProvider: Échec suppression - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _logger.i(' CompanyProvider: Entreprise supprimée');
        _companies.removeWhere((c) => c.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Bascule statut entreprise
  Future<bool> toggleCompanyStatus(int id) async {
    _logger.i(' CompanyProvider: Changement statut entreprise ID: $id');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final params = ToggleCompanyStatusParams(id: id);
    final result = await toggleCompanyStatusUseCase(params);

    return result.fold(
      (failure) {
        _logger.e(' CompanyProvider: Échec changement statut - ${getFailureMessage(failure)}');
        _errorMessage = getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (company) {
        _logger.i(' CompanyProvider: Statut modifié - ${company.isActive ? "Active" : "Inactive"}');
        final index = _companies.indexWhere((c) => c.id == id);
        if (index != -1) {
          _companies[index] = company;
        }
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

  // Obtenir une entreprise par ID
  Company? getCompanyById(int id) {
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (e) {
      _logger.i(' CompanyProvider: Entreprise introuvable - ID: $id');
      return null;
    }
  }

  // Annuler l'état du provider
  void reset() {
    _status = CompanyProviderStatus.initial;
    _companies = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}