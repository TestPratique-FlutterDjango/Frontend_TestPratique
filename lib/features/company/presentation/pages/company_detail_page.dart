import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/company.dart';

class CompanyDetailPage extends StatelessWidget {

  const CompanyDetailPage({required this.company, super.key});
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails entreprise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit - sera géré par le router
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingLG),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        company.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMD),
                    Text(
                      company.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.paddingSM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingMD,
                        vertical: AppTheme.paddingSM,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: company.isActive ? AppColors.success : AppColors.textDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.paddingLG),
            // Informations principales
            _buildInfoCard(
              context,
              'Informations principales',
              [
                _buildInfoRow(Icons.numbers, 'Numéro CFE', company.cfeNumber),
                _buildInfoRow(Icons.location_on_outlined, 'Adresse', company.address),
                if (company.phone != null)
                  _buildInfoRow(Icons.phone_outlined, 'Téléphone', company.phone!),
                if (company.email != null)
                  _buildInfoRow(Icons.email_outlined, 'Email', company.email!),
                if (company.website != null)
                  _buildInfoRow(Icons.language, 'Site web', company.website!),
              ],
            ),
            if (company.description != null && company.description!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.paddingLG),
              _buildInfoCard(
                context,
                'Description',
                [
                  Text(
                    company.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppTheme.paddingLG),
            // Statistiques
            _buildInfoCard(
              context,
              'Statistiques',
              [
                _buildStatRow(
                  Icons.article_outlined,
                  'Publications',
                  company.publicationsCount.toString(),
                  AppColors.primary,
                ),
                _buildStatRow(
                  Icons.calendar_today,
                  'Créée le',
                  DateFormatter.formatShortDate(company.createdAt),
                  AppColors.textSecondary,
                ),
                _buildStatRow(
                  Icons.update,
                  'Modifiée le',
                  DateFormatter.formatRelativeTime(company.updatedAt),
                  AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.paddingMD),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppTheme.paddingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingMD),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppTheme.paddingMD),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}