import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/local_storage.dart';
import '../../core/storage/secure_storage.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/change_password_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/update_profile_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Company Feature
import '../../features/company/data/datasources/company_remote_datasource.dart';
import '../../features/company/data/repositories/company_repository_impl.dart';
import '../../features/company/domain/repositories/company_repository.dart';
import '../../features/company/domain/usecases/create_company_usecase.dart';
import '../../features/company/domain/usecases/delete_company_usecase.dart';
import '../../features/company/domain/usecases/get_companies_usecase.dart';
import '../../features/company/domain/usecases/toggle_company_status_usecase.dart';
import '../../features/company/domain/usecases/update_company_usecase.dart';
import '../../features/company/presentation/providers/company_provider.dart';

// Publication Feature
import '../../features/publication/data/datasources/publication_remote_datasource.dart';
import '../../features/publication/data/repositories/publication_repository_impl.dart';
import '../../features/publication/domain/repositories/publication_repository.dart';
import '../../features/publication/domain/usecases/create_publication_usecase.dart';
import '../../features/publication/domain/usecases/get_publications_usecase.dart';
import '../../features/publication/domain/usecases/search_publications_usecase.dart';
import '../../features/publication/presentation/providers/publication_provider.dart';

// Service Locator
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // ============================================
  // Core
  // ============================================
  
  // Network
  sl..registerLazySingleton<DioClient>(DioClient.new)
  ..registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  )
  ..registerLazySingleton(InternetConnectionChecker.new)
  
  // Storage
  ..registerLazySingleton<SecureStorage>(SecureStorage.new)
  ..registerLazySingleton<LocalStorage>(LocalStorage.new);
  
  // Initialize LocalStorage
  await sl<LocalStorage>().init();
  
  // ============================================
  // Features - Auth
  // ============================================
  
  // Data Sources
  sl
  ..registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  )
  ..registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      localStorage: sl(),
      secureStorage: sl(),
    ),
  )
  
  // Repository
  ..registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  )
  
  // Use Cases
  ..registerLazySingleton(() => LoginUseCase(sl()))
  ..registerLazySingleton(() => RegisterUseCase(sl()))
  ..registerLazySingleton(() => LogoutUseCase(sl()))
  ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
  ..registerLazySingleton(() => UpdateProfileUseCase(sl()))
  ..registerLazySingleton(() => ChangePasswordUseCase(sl()))
  
  // Providers
  ..registerFactory(
    () => AuthProvider(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      updateProfileUseCase: sl(),
      changePasswordUseCase: sl(),
    ),
  )
  
  // ============================================
  // Features - Company
  // ============================================
  
  // Data Sources
  ..registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(dioClient: sl()),
  )
  
  // Repository
  ..registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  )
  
  // Use Cases
  ..registerLazySingleton(() => GetCompaniesUseCase(sl()))
  ..registerLazySingleton(() => CreateCompanyUseCase(sl()))
  ..registerLazySingleton(() => UpdateCompanyUseCase(sl()))
  ..registerLazySingleton(() => DeleteCompanyUseCase(sl()))
  ..registerLazySingleton(() => ToggleCompanyStatusUseCase(sl()))
  
  // Providers
  ..registerFactory(
    () => CompanyProvider(
      getCompaniesUseCase: sl(),
      createCompanyUseCase: sl(),
      updateCompanyUseCase: sl(),
      deleteCompanyUseCase: sl(),
      toggleCompanyStatusUseCase: sl(),
    ),
  )
  
  // ============================================
  // Features - Publication
  // ============================================
  
  // Data Sources
  ..registerLazySingleton<PublicationRemoteDataSource>(
    () => PublicationRemoteDataSourceImpl(dioClient: sl()),
  )
  
  // Repository
  ..registerLazySingleton<PublicationRepository>(
    () => PublicationRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  )
  
  // Use Cases
  ..registerLazySingleton(() => GetPublicationsUseCase(sl()))
  ..registerLazySingleton(() => CreatePublicationUseCase(sl()))
  ..registerLazySingleton(() => SearchPublicationsUseCase(sl()))
  
  // Providers
  ..registerFactory(
    () => PublicationProvider(
      getPublicationsUseCase: sl(),
      createPublicationUseCase: sl(),
      searchPublicationsUseCase: sl(),
    ),
  );
}