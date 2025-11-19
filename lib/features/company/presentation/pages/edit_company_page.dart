import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../domain/entities/company.dart';
import '../providers/company_provider.dart';

class EditCompanyPage extends StatefulWidget {

  const EditCompanyPage({required this.company, super.key});
  final Company company;

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name);
    _addressController = TextEditingController(text: widget.company.address);
    _phoneController = TextEditingController(text: widget.company.phone ?? '');
    _emailController = TextEditingController(text: widget.company.email ?? '');
    _websiteController = TextEditingController(text: widget.company.website ?? '');
    _descriptionController = TextEditingController(text: widget.company.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CompanyProvider>();
    final success = await provider.updateCompany(
      id: widget.company.id,
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, AppStrings.companyUpdated);
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
        title: const Text(AppStrings.editCompany),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLG),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CFE Number (non modifiable)
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingMD),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.numbers, color: Colors.grey),
                    const SizedBox(width: AppTheme.paddingSM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Numéro CFE',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.company.cfeNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Chip(
                      label: Text('Non modifiable', style: TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.paddingLG),
              Text(
                'Informations modifiables',
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
                controller: _addressController,
                label: AppStrings.address,
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                validator: Validators.validateAddress,
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
                    onPressed: _handleUpdate,
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