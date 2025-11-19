import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../../company/presentation/providers/company_provider.dart';
import '../../domain/entities/publication.dart' as pub;
import '../providers/publication_provider.dart';

class CreatePublicationPage extends StatefulWidget {
  const CreatePublicationPage({super.key});

  @override
  State<CreatePublicationPage> createState() => _CreatePublicationPageState();
}

class _CreatePublicationPageState extends State<CreatePublicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  
  pub.PublicationStatus _selectedStatus = pub.PublicationStatus.draft;
  int? _selectedCompanyId;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user?.isProfessional ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CompanyProvider>().getCompanies();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PublicationProvider>();
    final success = await provider.createPublication(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      status: _selectedStatus.toApiString(),
      companyId: _selectedCompanyId,
      tags: _tagsController.text.trim().isEmpty ? null : _tagsController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, AppStrings.publicationCreated);
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
    final user = context.watch<AuthProvider>().user;
    final isProfessional = user?.isProfessional ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createPublication),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLG),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: AppStrings.title,
                prefixIcon: Icons.title,
                validator: Validators.validateTitle,
                maxLength: 255,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _contentController,
                label: AppStrings.content,
                prefixIcon: Icons.description_outlined,
                maxLines: 8,
                validator: Validators.validateContent,
              ),
              const SizedBox(height: AppTheme.paddingMD),
              CustomTextField(
                controller: _tagsController,
                label: AppStrings.tags,
                hint: 'technologie, innovation, business',
                prefixIcon: Icons.label_outlined,
                validator: Validators.validateTags,
              ),
              const SizedBox(height: AppTheme.paddingLG),
              // Status Selection
              Text(
                AppStrings.status,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.paddingSM),
              Wrap(
                spacing: 8,
                children: pub.PublicationStatus.values.map((status) {
                  return ChoiceChip(
                    label: Text(status.displayName),
                    selected: _selectedStatus == status,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedStatus = status);
                      }
                    },
                  );
                }).toList(),
              ),
              if (isProfessional) ...[
                const SizedBox(height: AppTheme.paddingLG),
                Text(
                  'Entreprise (optionnel)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.paddingSM),
                Consumer<CompanyProvider>(
                  builder: (context, companyProvider, child) {
                    if (companyProvider.companies.isEmpty) {
                      return const Text(
                        'Aucune entreprise disponible',
                        style: TextStyle(color: AppColors.textDisabled),
                      );
                    }

                    return DropdownButtonFormField<int>(
                      value: _selectedCompanyId,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.business_outlined),
                        hintText: 'Sélectionner une entreprise',
                      ),
                      items: [
                        const DropdownMenuItem<int>(
                          child: Text('Aucune entreprise'),
                        ),
                        ...companyProvider.companies.map((company) {
                          return DropdownMenuItem<int>(
                            value: company.id,
                            child: Text(company.name),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedCompanyId = value);
                      },
                    );
                  },
                ),
              ],
              const SizedBox(height: AppTheme.paddingXL),
              Consumer<PublicationProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: _selectedStatus == pub.PublicationStatus.published
                        ? 'Créer et publier'
                        : 'Créer',
                    onPressed: _handleCreate,
                    isLoading: provider.isLoading,
                    icon: _selectedStatus == pub.PublicationStatus.published
                        ? Icons.publish
                        : Icons.save,
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