import 'package:flutter/material.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../features/auth/presentation/pages/account_type_selection_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/company/domain/entities/company.dart';
import '../../features/company/presentation/pages/companies_list_page.dart';
import '../../features/company/presentation/pages/company_detail_page.dart';
import '../../features/company/presentation/pages/create_company_page.dart';
import '../../features/company/presentation/pages/edit_company_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/publication/domain/entities/publication.dart';
import '../../features/publication/presentation/pages/create_publication_page.dart';
import '../../features/publication/presentation/pages/edit_publication_page.dart';
import '../../features/publication/presentation/pages/my_publications_page.dart';
import '../../features/publication/presentation/pages/publication_detail_page.dart';
import '../../features/publication/presentation/pages/search_publications_page.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.accountTypeSelection:
        return MaterialPageRoute(
          builder: (_) => const AccountTypeSelectionPage(),
        );

      case RouteNames.register:
        final accountType = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => RegisterPage(accountType: accountType),
        );

      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      // Home
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // Company Routes
      case RouteNames.companies:
        return MaterialPageRoute(builder: (_) => const CompaniesListPage());

      case RouteNames.createCompany:
        return MaterialPageRoute(builder: (_) => const CreateCompanyPage());

      case RouteNames.editCompany:
        final company = settings.arguments! as Company;
        return MaterialPageRoute(
          builder: (_) => EditCompanyPage(company: company),
        );

      case RouteNames.companyDetail:
        final company = settings.arguments! as Company;
        return MaterialPageRoute(
          builder: (_) => CompanyDetailPage(company: company),
        );

      // Publication Routes
      case RouteNames.createPublication:
        return MaterialPageRoute(
          builder: (_) => const CreatePublicationPage(),
        );

      case RouteNames.publicationDetail:
        final publication = settings.arguments! as Publication;
        return MaterialPageRoute(
          builder: (_) => PublicationDetailPage(publication: publication),
        );

      case RouteNames.searchPublications:
        return MaterialPageRoute(
          builder: (_) => const SearchPublicationsPage(),
        );

      case RouteNames.myPublications:
        return MaterialPageRoute(
          builder: (_) => const MyPublicationsPage(),
        );

      case RouteNames.editPublication:
        final publication = settings.arguments! as Publication;
        return MaterialPageRoute(
          builder: (_) => EditPublicationPage(publication: publication),
        );

      // Default route
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}