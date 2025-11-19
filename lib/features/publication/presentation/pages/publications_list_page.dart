import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../providers/publication_provider.dart';
import '../widgets/publication_card.dart';

class PublicationsListPage extends StatefulWidget {
  const PublicationsListPage({super.key});

  @override
  State<PublicationsListPage> createState() => _PublicationsListPageState();
}

class _PublicationsListPageState extends State<PublicationsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PublicationProvider>().getPublications();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<PublicationProvider>().getPublications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.publications),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.searchPublications);
            },
          ),
        ],
      ),
      body: Consumer<PublicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.publications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.publications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 80,
                    color: AppColors.textDisabled,
                  ),
                  SizedBox(height: AppTheme.paddingLG),
                  Text(
                    AppStrings.noPublications,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppTheme.paddingSM),
                  Text(
                    'Aucune publication disponible',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingSM),
              itemCount: provider.publications.length,
              itemBuilder: (context, index) {
                final publication = provider.publications[index];
                return PublicationCard(
                  publication: publication,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.publicationDetail,
                      arguments: publication,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.createPublication);
        },
        icon: const Icon(Icons.add),
        label: const Text('Créer'),
      ),
    );
  }
}