import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/publication.dart';

class PublicationCard extends StatelessWidget {

  const PublicationCard({
    required this.publication, 
    super.key,
    this.onTap,
  });
  final Publication publication;
  final VoidCallback? onTap;

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
              // Header with status
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
              // Content preview
              Text(
                publication.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              // Meta info
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: AppColors.textDisabled),
                  const SizedBox(width: 4),
                  Text(
                    publication.authorName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                  if (publication.companyName != null) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.business_outlined, size: 14, color: AppColors.textDisabled),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        publication.companyName!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textDisabled,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppTheme.paddingSM),
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
                  Text(
                    publication.isPublished && publication.publishedAt != null
                        ? DateFormatter.formatRelativeTime(publication.publishedAt!)
                        : DateFormatter.formatRelativeTime(publication.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
              // Tags
              if (publication.tagsList.isNotEmpty) ...[
                const SizedBox(height: AppTheme.paddingSM),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: publication.tagsList.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}