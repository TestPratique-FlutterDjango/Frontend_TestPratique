import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../providers/company_provider.dart';

class CreateCompanyPage extends StatefulWidget {
  const CreateCompanyPage({super.key});

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cfeNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cfeNumberController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CompanyProvider>();
    final success = await provider.createCompany(
      name: _nameController.text.trim(),
      cfeNumber: _cfeNumberController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, AppStrings.companyCreated);
      Navigator.of(context).pop();
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
        title: const Text(AppStrings.addCompany),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLG),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informations obligatoires',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _nameController,
                label: AppStrings.companyName,
                prefixIcon: Icons.business_outlined,
                validator: (value) => Validators.validateCompanyName(value, isRequired: true),
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _cfeNumberController,
                label: AppStrings.cfeNumber,
                prefixIcon: Icons.numbers,
                validator: (value) => Validators.validateCFENumber(value, isRequired: true),
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _addressController,
                label: AppStrings.address,
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                validator: Validators.validateAddress,
              ),
              const SizedBox(height: AppTheme.paddingLG),
              Text(
                'Informations optionnelles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _phoneController,
                label: AppStrings.phone,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _emailController,
                label: 'Email entreprise',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  return Validators.validateEmail(value);
                },
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _websiteController,
                label: AppStrings.website,
                prefixIcon: Icons.language,
                keyboardType: TextInputType.url,
                validator: Validators.validateUrl,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _descriptionController,
                label: AppStrings.description,
                prefixIcon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: AppTheme.paddingXL),
              Consumer<CompanyProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: AppStrings.save,
                    onPressed: _handleCreate,
                    isLoading: provider.isLoading,
                    icon: Icons.check,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}