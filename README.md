# Publications App - Flutter Frontend

Application mobile Flutter pour la gestion de publications avec support des comptes privés et professionnels.

## Aperçu

Application mobile complète permettant aux utilisateurs de :
- Créer un compte (Privé ou Professionnel)
- Gérer leurs entreprises (comptes professionnels)
- Créer, modifier et publier des publications
- Rechercher des publications
- Consulter les publications publiques


## Technologies Utilisées

### Core
- **Flutter SDK** : ^3.0.0
- **Dart** : ^3.0.0

### State Management & DI
- **Provider** : ^6.1.1 (Gestion d'état)
- **GetIt** : ^7.6.4 (Dependency Injection)

### Network & Data
- **Dio** : ^5.4.0 (HTTP Client)
- **Dartz** : ^0.10.1 (Functional Programming)
- **flutter_secure_storage** : ^9.0.0 (Tokens JWT)
- **shared_preferences** : ^2.2.2 (Cache local)

### UI
- **Google Fonts** : ^6.1.0
- **Shimmer** : ^3.0.0
- **cached_network_image** : ^3.3.1

### Utils
- **Equatable** : ^2.0.5
- **intl** : ^0.19.0
- **logger** : ^2.0.2+1

## Structure du Projet

```
publications_app/
    lib/
        core/                      # Code partagé
        config/                    # Configuration
        features/
            auth/                 # Module authentification
                domain/
                data/
                presentation/
                    providers/
                    pages/
                    widgets/
            company/              # Module entreprises
            publication/          # Module publications
            home/                 # Navigation principale
        main.dart
        app.dart

    android/                       # Configuration Android
    assets/                        # Images, fonts
    test/                          # Tests unitaires
    pubspec.yaml                   # Dépendances
    README.md
```

## Installation

### Prérequis
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK (API 21+)
- Émulateur ou appareil Android

### Étapes

1. **Cloner le repository**
```bash
git clone https://github.com/TestPratique-FlutterDjango/Frontend_TestPratique.git
cd frontend
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Vérifier la configuration**
```bash
flutter doctor
```

4. **Lancer l'application**
```bash
flutter run
```

## Configuration

### API Backend

L'URL de l'API est définie dans `lib/core/constants/api_constants.dart` :

```dart
static const String baseUrl = 'https://backend-testpratique-2.onrender.com';
```

### Authentification JWT

Les tokens sont stockés de manière sécurisée via `flutter_secure_storage` et automatiquement ajoutés aux requêtes via un intercepteur Dio.

## Fonctionnalités

### Authentification
- Inscription (compte privé/professionnel)
- Connexion
- Déconnexion
- Profil utilisateur
- JWT avec refresh automatique

### Gestion Entreprises (Comptes Pro)
- Liste des entreprises
- Créer une entreprise
- Modifier une entreprise
- Voir détails entreprise
- Supprimer une entreprise
- Activer/Désactiver

### Gestion Publications
- Liste des publications publiques
- Mes publications
- Créer une publication
- Modifier une publication
- Supprimer une publication
- Recherche avancée (texte, statut, tags)
- Statuts (Brouillon, Publié, Archivé)
- Compteur de vues

## Tests

```bash
# Lancer tous les tests
flutter test

# Tests avec coverage
flutter test --coverage
```

## Build APK

### APK Debug (Test)
```bash
flutter build apk --debug
```

### APK Release (Production)
```bash
flutter build apk --release
```

APK généré dans : `build/app/outputs/flutter-apk/`

## Design

### Palette de Couleurs
- **Primary** : #2563EB (Bleu)
- **Secondary** : #10B981 (Vert)
- **Error** : #EF4444 (Rouge)
- **Success** : #10B981 (Vert)

### Police
- **Google Fonts** : Poppins

### Theme
- Material Design 3
- Mode clair uniquement


## Sécurité

- Tokens JWT stockés de manière sécurisée
- Refresh token automatique
- Validation des données côté client
- Communication HTTPS avec le backend

## License

Ce projet est sous licence MIT.

## Auteur

Développé dans le cadre d'un test pratique.

## Liens Utiles

- **Backend API** : https://backend-testpratique-2.onrender.com
- **Documentation API** : https://backend-testpratique-2.onrender.com/api/docs/
- **Organisation GitHub** : https://github.com/TestPratique-FlutterDjango

## Support

Pour toute question : fawazdango28@gmail.com

---

**Version** : 1.0.0  
**Dernière mise à jour** : Novembre 2024