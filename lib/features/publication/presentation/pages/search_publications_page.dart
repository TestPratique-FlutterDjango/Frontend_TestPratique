import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/publication.dart' as pub_entity;
import '../providers/publication_provider.dart';
import '../widgets/publication_card.dart';

class SearchPublicationsPage extends StatefulWidget {
  const SearchPublicationsPage({super.key});

  @override
  State<SearchPublicationsPage> createState() => _SearchPublicationsPageState();
}

class _SearchPublicationsPageState extends State<SearchPublicationsPage> {
  final _searchController = TextEditingController();
  pub_entity.PublicationStatus? _selectedStatus;
  String? _selectedTags;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final query = _searchController.text.trim();
    
    await context.read<PublicationProvider>().searchPublications(
      query: query.isEmpty ? null : query,
      status: _selectedStatus?.toApiString(),
      tags: _selectedTags,
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _selectedTags = null;
    });
    context.read<PublicationProvider>().getPublications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher'),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Effacer'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingMD),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher par titre ou contenu...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                  onSubmitted: (_) => _handleSearch(),
                ),
                const SizedBox(height: AppTheme.paddingMD),
                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Status Filter
                      FilterChip(
                        label: Text(_selectedStatus?.displayName ?? 'Tous les statuts'),
                        selected: _selectedStatus != null,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _showStatusPicker();
                            } else {
                              _selectedStatus = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // Tags Filter
                      FilterChip(
                        label: Text(_selectedTags ?? 'Tags'),
                        selected: _selectedTags != null,
                        onSelected: (selected) {
                          if (!selected) {
                            setState(() => _selectedTags = null);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMD),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Rechercher'),
                  ),
                ),
              ],
            ),
          ),
          // Results
          Expanded(
            child: Consumer<PublicationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.publications.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: AppColors.textDisabled,
                        ),
                        SizedBox(height: AppTheme.paddingLG),
                        Text(
                          'Aucun résultat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppTheme.paddingSM),
                        Text(
                          "Essayez avec d'autres mots-clés",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.paddingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filtrer par statut',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.paddingLG),
            ...pub_entity.PublicationStatus.values.map((status) {
              return ListTile(
                title: Text(status.displayName),
                trailing: _selectedStatus == status
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedStatus = status);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}