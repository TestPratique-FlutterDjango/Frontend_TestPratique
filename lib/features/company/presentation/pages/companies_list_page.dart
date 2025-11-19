import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../providers/company_provider.dart';
import '../widgets/company_card.dart';

class CompaniesListPage extends StatefulWidget {
  const CompaniesListPage({super.key});

  @override
  State<CompaniesListPage> createState() => _CompaniesListPageState();
}

class _CompaniesListPageState extends State<CompaniesListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyProvider>().getCompanies();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<CompanyProvider>().getCompanies();
  }

  Future<void> _handleDelete(int id, String name) async {
    final confirmed = await DialogUtils.showDeleteConfirmationDialog(
      context,
      title: 'Supprimer l\'entreprise',
      message: 'Voulez-vous vraiment supprimer "$name" ?',
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final provider = context.read<CompanyProvider>();
    final success = await provider.deleteCompany(id);

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, AppStrings.companyDeleted);
    } else {
      SnackBarUtils.showError(
        context,
        provider.errorMessage ?? AppStrings.unknownError,
      );
    }
  }

  Future<void> _handleToggleStatus(int id) async {
    final provider = context.read<CompanyProvider>();
    final success = await provider.toggleCompanyStatus(id);

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, 'Statut modifié avec succès');
    } else {
      SnackBarUtils.showError(
        context,
        provider.errorMessage ?? AppStrings.unknownError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.companies),
      ),
      body: Consumer<CompanyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.companies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.companies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 80,
                    color: AppColors.textDisabled,
                  ),
                  SizedBox(height: AppTheme.paddingLG),
                  Text(
                    AppStrings.noCompanies,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppTheme.paddingSM),
                  Text(
                    AppStrings.addFirstCompany,
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
              itemCount: provider.companies.length,
              itemBuilder: (context, index) {
                final company = provider.companies[index];
                return CompanyCard(
                  company: company,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.companyDetail,
                      arguments: company,
                    );
                  },
                  onEdit: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.editCompany,
                      arguments: company,
                    );
                  },
                  onDelete: () => _handleDelete(company.id, company.name),
                  onToggleStatus: () => _handleToggleStatus(company.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.createCompany);
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}