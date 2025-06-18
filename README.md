# Planning de Travail 📅

Une application Flutter moderne pour gérer et visualiser vos plannings de travail hebdomadaires.

## ✨ Fonctionnalités

- 📱 **Interface mobile native** (Android/iOS)
- 📊 **Import CSV** pour charger vos plannings
- 📅 **Vue hebdomadaire** du lundi au dimanche
- 🔄 **Navigation** entre les semaines
- 🇫🇷 **Support français** complet
- 🎨 **Design moderne** et responsive

## 📱 Captures d'écran

![Interface principale](screenshots/main_screen.png)
![Import CSV](screenshots/csv_import.png)

## 🚀 Installation

### Prérequis
- Flutter SDK (>=3.5.0)
- Android Studio ou VS Code
- Git

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone https://github.com/Jynra/work-schedule-app.git
cd work-schedule-app
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Lancer l'application**
```bash
flutter run
```

## 📋 Format CSV

L'application accepte les fichiers CSV avec ce format :

```csv
date,horaire,poste,taches
2025-06-30,08:00-16:00,Bureau,Réunion équipe
2025-07-01,09:00-17:00,Site A,Formation
2025-07-02,Repos,Congé,Jour de repos
```

### Colonnes supportées :
- **date** : Format YYYY-MM-DD
- **horaire** : Plage horaire ou "Repos"
- **poste** : Lieu de travail
- **taches** : Description des activités

## 🛠️ Technologies utilisées

- **Flutter** - Framework UI multiplateforme
- **Dart** - Langage de programmation
- **Material Design 3** - Interface utilisateur moderne
- **file_picker** - Sélection de fichiers
- **intl** - Internationalisation et dates
- **flutter_launcher_icons** - Génération d'icônes

## 🏗️ Architecture du projet

```
work-schedule-app/
├── android/                    # Configuration Android
├── ios/                        # Configuration iOS
├── lib/
│   └── main.dart              # Code principal de l'application
├── test/                      # Tests unitaires
├── assets/                    # Ressources (icônes, images)
├── pubspec.yaml              # Dépendances et configuration
└── README.md                 # Documentation
```

### Structure du code
- **WorkScheduleApp** : Widget principal de l'application
- **WorkScheduleHomePage** : Page d'accueil avec navigation
- **WorkEvent** : Modèle de données pour les événements
- **Parser CSV** : Logique d'import et traitement des fichiers

## 🎯 Fonctionnalités détaillées

### Import CSV
- Parsing automatique des fichiers CSV
- Support des différents encodages
- Validation des données
- Messages d'erreur informatifs

### Interface utilisateur
- Design Material 3 moderne
- Animations fluides
- Navigation intuitive
- Responsive design

### Gestion des semaines
- Détection automatique de la semaine courante
- Navigation entre semaines
- Affichage du lundi au dimanche
- Indicateur "Aujourd'hui"

## 🚀 Fonctionnalités à venir

- [ ] Export des plannings modifiés
- [ ] Édition des événements dans l'app
- [ ] Notifications pour les événements
- [ ] Thème sombre
- [ ] Synchronisation cloud
- [ ] Support multi-langues
- [ ] Statistiques de travail

## 🧪 Tests

```bash
# Lancer les tests
flutter test

# Analyser le code
flutter analyze
```

## 📦 Build de production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release
```

### iOS (macOS requis)
```bash
flutter build ios --release
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrez une Pull Request

### Lignes directrices
- Suivez les conventions de code Dart
- Ajoutez des tests pour les nouvelles fonctionnalités
- Mettez à jour la documentation si nécessaire

## 🐛 Signaler un bug

Si vous trouvez un bug, n'hésitez pas à [ouvrir une issue](https://github.com/Jynra/work-schedule-app/issues) avec :
- Description détaillée du problème
- Étapes pour reproduire
- Captures d'écran si applicable
- Informations sur l'environnement (OS, version Flutter, etc.)

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- [Flutter team](https://flutter.dev/) pour le framework extraordinaire
- [Material Design](https://material.io/) pour les guidelines UI
- Communauté Flutter pour les packages et le support
- Contributeurs et utilisateurs de ce projet

## 📊 Statistiques du projet

![GitHub stars](https://img.shields.io/github/stars/Jynra/work-schedule-app?style=social)
![GitHub forks](https://img.shields.io/github/forks/Jynra/work-schedule-app?style=social)
![GitHub issues](https://img.shields.io/github/issues/Jynra/work-schedule-app)
![GitHub license](https://img.shields.io/github/license/Jynra/work-schedule-app)

---

Développé avec ❤️ en Flutter par [Jynra](https://github.com/Jynra)