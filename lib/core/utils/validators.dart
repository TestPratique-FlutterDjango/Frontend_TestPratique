class Validators {
  // Validation d'email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "L'email est obligatoire";
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    
    return null;
  }

  // Validation de mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est obligatoire';
    }
    
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    
    return null;
  }

  // Validation de confirmation de mot de passe
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }

  // Validation de champ obligatoire
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est obligatoire';
    }
    return null;
  }

  // Validation de nom 
  static String? validateName(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Le nom'} est obligatoire';
    }
    
    if (value.length < 2) {
      return '${fieldName ?? 'Le nom'} doit contenir au moins 2 caractères';
    }
    
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$');
    if (!nameRegex.hasMatch(value)) {
      return '${fieldName ?? 'Le nom'} contient des caractères invalides';
    }
    
    return null;
  }

  // Validation de numéro de téléphone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; 
    }
    
    // Supprimer les espaces, tirets et parenthèses
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Vérifier le format du numéro de téléphone
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Numéro de téléphone invalide';
    }
    
    return null;
  }

  // Validation d'URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; 
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'URL invalide';
    }
    
    return null;
  }

  // Validation de numéro CFE (pour comptes professionnels)
  static String? validateCFENumber(String? value, {bool isRequired = false}) {
    if (!isRequired && (value == null || value.isEmpty)) {
      return null;
    }
    
    if (value == null || value.isEmpty) {
      return 'Le numéro CFE est obligatoire pour un compte professionnel';
    }
    
    if (value.length < 5) {
      return 'Le numéro CFE doit contenir au moins 5 caractères';
    }
    
    return null;
  }

  // Validation du nom de l'entreprise
  static String? validateCompanyName(String? value, {bool isRequired = false}) {
    if (!isRequired && (value == null || value.isEmpty)) {
      return null;
    }
    
    if (value == null || value.isEmpty) {
      return "Le nom de l'entreprise est obligatoire pour un compte professionnel";
    }
    
    if (value.length < 2) {
      return "Le nom de l'entreprise doit contenir au moins 2 caractères";
    }
    
    return null;
  }

  // Validation de l'adresse
  static String? validateAddress(String? value, {bool isRequired = true}) {
    if (!isRequired && (value == null || value.isEmpty)) {
      return null;
    }
    
    if (value == null || value.isEmpty) {
      return "L'adresse est obligatoire";
    }
    
    if (value.length < 4) {
      return "L'adresse doit contenir au moins 10 caractères";
    }
    
    return null;
  }

  // Validation du titre pour la publication
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le titre est obligatoire';
    }
    
    if (value.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    
    if (value.length > 255) {
      return 'Le titre ne peut pas dépasser 255 caractères';
    }
    
    return null;
  }

  // Validation de contenu pour la publication
  static String? validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le contenu est obligatoire';
    }
    
    if (value.length < 10) {
      return 'Le contenu doit contenir au moins 10 caractères';
    }
    
    return null;
  }

  // Tags Validation
  static String? validateTags(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    // Verifier le nombre de tags (séparés par des virgules)
    final tags = value.split(',').map((tag) => tag.trim()).toList();
    
    if (tags.length > 10) {
      return 'Maximum 10 tags autorisés';
    }
    
    return null;
  }

  // Validation de nombre
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Optional
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Ce champ'} doit être un nombre';
    }
    
    return null;
  }

  // Validation de nombre positif
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final error = validateNumber(value, fieldName: fieldName);
    if (error != null) return error;
    
    if (value != null && value.isNotEmpty) {
      final number = int.parse(value);
      if (number <= 0) {
        return '${fieldName ?? 'Ce champ'} doit être un nombre positif';
      }
    }
    
    return null;
  }
}