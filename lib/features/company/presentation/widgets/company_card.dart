import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/company.dart';

class CompanyCard extends StatelessWidget {

  const CompanyCard({
    required this.company, 
    super.key,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });
  final Company company;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

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
                      company.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingSM,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: company.isActive
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.textDisabled.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Text(
                      company.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: company.isActive
                            ? AppColors.success
                            : AppColors.textDisabled,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSM),
              // CFE Number
              Row(
                children: [
                  const Icon(Icons.numbers, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'CFE: ${company.cfeNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSM),
              // Address
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      company.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (company.publicationsCount > 0) ...[
                const SizedBox(height: AppTheme.paddingSM),
                Row(
                  children: [
                    const Icon(Icons.article_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${company.publicationsCount} publication${company.publicationsCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppTheme.paddingSM),
              // Date
              Text(
                'Créée ${DateFormatter.formatRelativeTime(company.createdAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textDisabled,
                ),
              ),
              const SizedBox(height: AppTheme.paddingMD),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onToggleStatus != null)
                    TextButton.icon(
                      onPressed: onToggleStatus,
                      icon: Icon(
                        company.isActive ? Icons.block : Icons.check_circle,
                        size: 16,
                      ),
                      label: Text(company.isActive ? 'Désactiver' : 'Activer'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
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