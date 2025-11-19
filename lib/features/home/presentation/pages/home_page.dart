import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../company/presentation/pages/companies_list_page.dart';
import '../../../company/presentation/providers/company_provider.dart';
import '../../../publication/presentation/pages/publications_list_page.dart';
import '../../../publication/presentation/providers/publication_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    final isProfessional = user?.isProfessional ?? false;

    // Force un délai pour être sûr que les providers sont prêts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<PublicationProvider>().getPublications();
        if (isProfessional) {
          context.read<CompanyProvider>().getCompanies();
        }
      }
    });

    _pages = [
      const PublicationsListPage(),
      if (isProfessional)
        const CompaniesListPage()
      else
        const _NotProfessionalTab(),
      const _ProfileTab(),
    ];

    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PublicationProvider>().getPublications();
      if (isProfessional) {
        context.read<CompanyProvider>().getCompanies();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Publications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Entreprises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _NotProfessionalTab extends StatelessWidget {
  const _NotProfessionalTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entreprises')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business_outlined,
                size: 80,
                color: AppColors.textDisabled,
              ),
              SizedBox(height: 24),
              Text(
                'Réservé aux comptes professionnels',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Créez un compte professionnel pour gérer vos entreprises',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed(RouteNames.profile);
          },
          icon: const Icon(Icons.person),
          label: const Text('Voir mon profil'),
        ),
      ),
    );
  }
}
