import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context,
      title: 'Déconnexion',
      message: AppStrings.confirmLogout,
    );

    if (confirmed != true) return;

    if (!context.mounted) return;

    final authProvider = context.read<AuthProvider>();
    final secureStorage = SecureStorage();
    final refreshToken = await secureStorage.getRefreshToken();

    if (refreshToken == null) {
      if (!context.mounted) return;
      SnackBarUtils.showError(context, 'Erreur lors de la déconnexion');
      return;
    }

    final success = await authProvider.logout(refreshToken);

    if (!context.mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, AppStrings.logoutSuccess);
      await Navigator.of(context).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
            tooltip: AppStrings.logout,
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(
              child: Text('Utilisateur non connecté'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: user.isProfessional
                            ? AppColors.professionalAccount
                            : AppColors.privateAccount,
                        child: Text(
                          user.firstName[0].toUpperCase() +
                              user.lastName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.paddingMD),
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppTheme.paddingSM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingMD,
                          vertical: AppTheme.paddingSM,
                        ),
                        decoration: BoxDecoration(
                          color: user.isProfessional
                              ? AppColors.professionalAccount.withOpacity(0.1)
                              : AppColors.privateAccount.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.isProfessional
                                  ? Icons.business_outlined
                                  : Icons.person_outline,
                              size: 16,
                              color: user.isProfessional
                                  ? AppColors.professionalAccount
                                  : AppColors.privateAccount,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.isProfessional
                                  ? AppStrings.professionalAccount
                                  : AppStrings.privateAccount,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: user.isProfessional
                                    ? AppColors.professionalAccount
                                    : AppColors.privateAccount,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.paddingXL),
                // Profile Information
                _buildInfoCard(
                  context,
                  'Informations personnelles',
                  [
                    _buildInfoRow(
                        Icons.email_outlined, 'Email', user.email),
                    _buildInfoRow(Icons.person_outline, 'Prénom',
                        user.firstName),
                    _buildInfoRow(Icons.person_outline, 'Nom',
                        user.lastName),
                    if (user.address != null && user.address!.isNotEmpty)
                      _buildInfoRow(Icons.location_on_outlined, 'Adresse',
                          user.address!),
                  ],
                ),
                if (user.isProfessional) ...[
                  const SizedBox(height: AppTheme.paddingLG),
                  _buildInfoCard(
                    context,
                    'Informations entreprise',
                    [
                      if (user.companyName != null)
                        _buildInfoRow(Icons.business_outlined,
                            'Entreprise', user.companyName!),
                      if (user.cfeNumber != null)
                        _buildInfoRow(
                            Icons.numbers, 'Numéro CFE', user.cfeNumber!),
                    ],
                  ),
                ],
                const SizedBox(height: AppTheme.paddingXL),
                // Action Buttons (Placeholder for now)
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMD),
                ListTile(
                  leading: const Icon(Icons.edit, color: AppColors.primary),
                  title: const Text(AppStrings.editProfile),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    SnackBarUtils.showInfo(
                        context, 'Fonctionnalité à venir');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline,
                      color: AppColors.primary),
                  title: const Text(AppStrings.changePassword),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    SnackBarUtils.showInfo(
                        context, 'Fonctionnalité à venir');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
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
}