import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publications_app/config/routes/routes_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key, this.accountType});
  final String? accountType;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _cfeNumberController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late String _accountType;

  @override
  void initState() {
    super.initState();
    _accountType = widget.accountType ?? 'PRIVATE';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _companyNameController.dispose();
    _cfeNumberController.dispose();
    super.dispose();
  }

  bool get _isProfessional => _accountType == 'PROFESSIONAL';

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      passwordConfirm: _confirmPasswordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      accountType: _accountType,
      companyName: _isProfessional ? _companyNameController.text.trim() : null,
      cfeNumber: _isProfessional ? _cfeNumberController.text.trim() : null,
    );

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, AppStrings.registerSuccess);
      await Navigator.of(context).pushReplacementNamed(RouteNames.home);
    } else {
      SnackBarUtils.showError(
        context,
        authProvider.errorMessage ?? AppStrings.unknownError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createAccount),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Account Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingMD,
                    vertical: AppTheme.paddingSM,
                  ),
                  decoration: BoxDecoration(
                    color: _isProfessional
                        ? AppColors.professionalAccount.withOpacity(0.1)
                        : AppColors.privateAccount.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isProfessional
                            ? Icons.business_outlined
                            : Icons.person_outline,
                        size: 20,
                        color: _isProfessional
                            ? AppColors.professionalAccount
                            : AppColors.privateAccount,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isProfessional
                            ? AppStrings.professionalAccount
                            : AppStrings.privateAccount,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isProfessional
                              ? AppColors.professionalAccount
                              : AppColors.privateAccount,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLG),
                // Personal Information
                Text(
                  'Informations personnelles',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.paddingMD),
                CustomTextField(
                  controller: _firstNameController,
                  label: AppStrings.firstName,
                  prefixIcon: Icons.person_outline,
                  validator: (value) =>
                      Validators.validateName(value, fieldName: 'Le prénom'),
                ),
                const SizedBox(height: AppTheme.paddingMD),
                CustomTextField(
                  controller: _lastNameController,
                  label: AppStrings.lastName,
                  prefixIcon: Icons.person_outline,
                  validator: (value) =>
                      Validators.validateName(value, fieldName: 'Le nom'),
                ),
                const SizedBox(height: AppTheme.paddingMD),
                CustomTextField(
                  controller: _emailController,
                  label: AppStrings.email,
                  hint: 'exemple@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: AppTheme.paddingMD),
                CustomTextField(
                  controller: _addressController,
                  label: AppStrings.address,
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (value) =>
                      Validators.validateAddress(value, isRequired: false),
                ),
                const SizedBox(height: AppTheme.paddingLG),
                // Company Information (if professional)
                if (_isProfessional) ...[
                  Text(
                    'Informations entreprise',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.paddingMD),
                  CustomTextField(
                    controller: _companyNameController,
                    label: AppStrings.companyName,
                    prefixIcon: Icons.business_outlined,
                    validator: (value) =>
                        Validators.validateCompanyName(value, isRequired: true),
                  ),
                  const SizedBox(height: AppTheme.paddingMD),
                  CustomTextField(
                    controller: _cfeNumberController,
                    label: AppStrings.cfeNumber,
                    prefixIcon: Icons.numbers,
                    validator: (value) =>
                        Validators.validateCFENumber(value, isRequired: true),
                  ),
                  const SizedBox(height: AppTheme.paddingLG),
                ],
                // Security
                Text(
                  'Sécurité',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.paddingMD),
                CustomTextField(
                  controller: _passwordController,
                  label: AppStrings.password,
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  validator: Validators.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMD),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: AppStrings.confirmPassword,
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppTheme.paddingXL),
                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: AppStrings.createAccount,
                      onPressed: _handleRegister,
                      isLoading: authProvider.isLoading,
                      icon: Icons.person_add,
                    );
                  },
                ),
                const SizedBox(height: AppTheme.paddingMD),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyHaveAccount,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        AppStrings.login,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}