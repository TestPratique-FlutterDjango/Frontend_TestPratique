import 'package:flutter/material.dart';
import 'package:publications_app/config/routes/routes_names.dart';

import '../../../../config/di/injection_container.dart' as di;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../publication/data/datasources/publication_remote_datasource.dart';
import '../../domain/entities/publication.dart';

class MyPublicationsPage extends StatefulWidget {
  const MyPublicationsPage({super.key});

  @override
  State<MyPublicationsPage> createState() => _MyPublicationsPageState();
}

class _MyPublicationsPageState extends State<MyPublicationsPage> {
  List<Publication> _myPublications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyPublications();
  }

  Future<void> _loadMyPublications() async {
    setState(() => _isLoading = true);
    
    try {
      final dataSource = di.sl<PublicationRemoteDataSource>();
      final publications = await dataSource.getMyPublications();
      
      setState(() {
        _myPublications = publications.map((model) => model.toEntity()).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDelete(int id, String title) async {
    final confirmed = await DialogUtils.showDeleteConfirmationDialog(
      context,
      title: 'Supprimer la publication',
      message: 'Voulez-vous vraiment supprimer "$title" ?',
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final dataSource = di.sl<PublicationRemoteDataSource>();
      await dataSource.deletePublication(id);
      
      if (!mounted) return;
      
      SnackBarUtils.showSuccess(context, AppStrings.publicationDeleted);
      await _loadMyPublications();
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, 'Erreur lors de la suppression');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myPublications),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myPublications.isEmpty
              ? const Center(
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
                        'Aucune publication',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppTheme.paddingSM),
                      Text(
                        AppStrings.createFirstPublication,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMyPublications,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingSM),
                    itemCount: _myPublications.length,
                    itemBuilder: (context, index) {
                      final publication = _myPublications[index];
                      return _MyPublicationCard(
                        publication: publication,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteNames.publicationDetail,
                            arguments: publication,
                          );
                        },
                        onEdit: () {
                          Navigator.of(context).pushNamed(
                            RouteNames.editPublication,
                            arguments: publication,
                          );
                        },
                        onDelete: () => _handleDelete(publication.id, publication.title),
                      );
                    },
                  ),
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

class _MyPublicationCard extends StatelessWidget {

  const _MyPublicationCard({
    required this.publication,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });
  final Publication publication;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  Color _getStatusColor() {
    switch (publication.status) {
      case PublicationStatus.draft:
        return AppColors.statusDraft;
      case PublicationStatus.published:
        return AppColors.statusPublished;
      case PublicationStatus.archived:
        return AppColors.statusArchived;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMD,
        vertical: AppTheme.paddingSM,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      publication.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingSM,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Text(
                      publication.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSM),
              Text(
                publication.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 14, color: AppColors.textDisabled),
                  const SizedBox(width: 4),
                  Text(
                    '${publication.viewsCount} vue${publication.viewsCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                  const Spacer(),
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Modifier',
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outlined, size: 20),
                      color: AppColors.error,
                      tooltip: 'Supprimer',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}