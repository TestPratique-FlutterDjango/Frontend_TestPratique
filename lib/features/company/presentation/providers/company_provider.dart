import 'package:flutter/foundation.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/company.dart';
import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/usecases/delete_company_usecase.dart';
import '../../domain/usecases/get_companies_usecase.dart';
import '../../domain/usecases/toggle_company_status_usecase.dart';
import '../../domain/usecases/update_company_usecase.dart';

enum CompanyStatus {
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

  CompanyStatus _status = CompanyStatus.initial;
  List<Company> _companies = [];
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  CompanyStatus get status => _status;
  List<Company> get companies => _companies;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Get all companies
  Future<bool> getCompanies() async {
    _setLoading(true);
    _errorMessage = null;

    final result = await getCompaniesUseCase(const NoParams());

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (companies) {
        _companies = companies;
        _status = CompanyStatus.loaded;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Create company
  Future<bool> createCompany({
    required String name,
    required String cfeNumber,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
  }) async {
    _setLoading(true);
    _errorMessage = null;

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
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (company) {
        _companies.insert(0, company);
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Update company
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
    _setLoading(true);
    _errorMessage = null;

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
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (company) {
        final index = _companies.indexWhere((c) => c.id == id);
        if (index != -1) {
          _companies[index] = company;
        }
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Delete company
  Future<bool> deleteCompany(int id) async {
    _setLoading(true);
    _errorMessage = null;

    final params = DeleteCompanyParams(id: id);
    final result = await deleteCompanyUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _companies.removeWhere((c) => c.id == id);
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Toggle company status
  Future<bool> toggleCompanyStatus(int id) async {
    _setLoading(true);
    _errorMessage = null;

    final params = ToggleCompanyStatusParams(id: id);
    final result = await toggleCompanyStatusUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (company) {
        final index = _companies.indexWhere((c) => c.id == id);
        if (index != -1) {
          _companies[index] = company;
        }
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
      _status = CompanyStatus.loading;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = CompanyStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get company by id
  Company? getCompanyById(int id) {
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}