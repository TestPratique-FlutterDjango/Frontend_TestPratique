import 'package:flutter/material.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../widgets/account_type_card.dart';
import '../widgets/custom_button.dart';

class AccountTypeSelectionPage extends StatefulWidget {
  const AccountTypeSelectionPage({super.key});

  @override
  State<AccountTypeSelectionPage> createState() =>
      _AccountTypeSelectionPageState();
}

class _AccountTypeSelectionPageState extends State<AccountTypeSelectionPage> {
  String? _selectedAccountType;

  void _handleContinue() {
    if (_selectedAccountType == null) return;

    Navigator.of(context).pushNamed(
      RouteNames.register,
      arguments: _selectedAccountType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectAccountType),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppTheme.paddingLG),
              const Text(
                'Choisissez le type de compte qui vous convient',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.paddingXL),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: AppTheme.paddingLG,
                  childAspectRatio: 1.2,
                  children: [
                    AccountTypeCard(
                      title: AppStrings.privateAccount,
                      description: AppStrings.privateAccountDesc,
                      icon: Icons.person_outline,
                      color: AppColors.privateAccount,
                      isSelected: _selectedAccountType == 'PRIVATE',
                      onTap: () {
                        setState(() {
                          _selectedAccountType = 'PRIVATE';
                        });
                      },
                    ),
                    AccountTypeCard(
                      title: AppStrings.professionalAccount,
                      description: AppStrings.professionalAccountDesc,
                      icon: Icons.business_outlined,
                      color: AppColors.professionalAccount,
                      isSelected: _selectedAccountType == 'PROFESSIONAL',
                      onTap: () {
                        setState(() {
                          _selectedAccountType = 'PROFESSIONAL';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.paddingLG),
              CustomButton(
                text: 'Continuer',
                onPressed: _selectedAccountType != null ? _handleContinue : null,
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}