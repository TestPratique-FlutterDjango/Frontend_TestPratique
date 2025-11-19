import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/di/injection_container.dart' as di;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../../company/presentation/providers/company_provider.dart';
import '../../data/datasources/publication_remote_datasource.dart';
import '../../domain/entities/publication.dart';

class EditPublicationPage extends StatefulWidget {

  const EditPublicationPage({required this.publication, super.key});
  final Publication publication;

  @override
  State<EditPublicationPage> createState() => _EditPublicationPageState();
}

class _EditPublicationPageState extends State<EditPublicationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  
  late PublicationStatus _selectedStatus;
  int? _selectedCompanyId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.publication.title);
    _contentController = TextEditingController(text: widget.publication.content);
    _tagsController = TextEditingController(text: widget.publication.tags);
    _selectedStatus = widget.publication.status;
    _selectedCompanyId = widget.publication.companyId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyProvider>().getCompanies();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dataSource = di.sl<PublicationRemoteDataSource>();
      final data = {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'status': _selectedStatus.toApiString(),
        if (_selectedCompanyId != null) 'company': _selectedCompanyId,
        if (_tagsController.text.trim().isNotEmpty) 'tags': _tagsController.text.trim(),
      };

      await dataSource.updatePublication(widget.publication.id, data);

      if (!mounted) return;

      SnackBarUtils.showSuccess(context, AppStrings.publicationUpdated);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, 'Erreur lors de la mise à jour');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editPublication),
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
              Text(
                AppStrings.status,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.paddingSM),
              Wrap(
                spacing: 8,
                children: PublicationStatus.values.map((status) {
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
              const SizedBox(height: AppTheme.paddingXL),
              CustomButton(
                text: AppStrings.save,
                onPressed: _handleUpdate,
                isLoading: _isLoading,
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}