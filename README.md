# Planning de Travail 📅

Une application Flutter moderne pour gérer et visualiser vos plannings de travail hebdomadaires avec persistance automatique des données.

## ✨ Fonctionnalités

- 📱 **Interface mobile native** (Android/iOS)
- 📊 **Import CSV** pour charger vos plannings
- 💾 **Sauvegarde automatique** du dernier planning importé
- 📅 **Vue hebdomadaire** du lundi au dimanche
- 🔄 **Navigation** entre les semaines
- 🎯 **Bouton "Aujourd'hui"** pour revenir rapidement à la semaine courante
- 🔄 **Bouton réinitialiser** pour revenir aux données d'exemple
- 🇫🇷 **Support français** complet
- 🎨 **Design moderne** et responsive
- 📊 **Indicateurs visuels** (semaine actuelle, nombre d'événements)

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

## 📂 Fichier CSV de test

Un fichier de test complet pour juin 2025 est disponible :

```csv
date,horaire,poste,taches
2025-06-01,Repos,Congé,Jour de repos - Dimanche
2025-06-02,08:00-16:00,Bureau Principal,Réunion équipe hebdomadaire - Planning projets
2025-06-03,09:00-17:00,Site A,Formation sécurité - Supervision équipe
...
```

*Utilisez ce format pour créer vos propres plannings ou testez l'application avec les données d'exemple intégrées.*

## 🛠️ Technologies utilisées

- **Flutter** - Framework UI multiplateforme
- **Dart** - Langage de programmation
- **Material Design 3** - Interface utilisateur moderne
- **file_picker** - Sélection de fichiers
- **intl** - Internationalisation et dates
- **shared_preferences** - Persistance locale des données
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
- **WorkScheduleHomePage** : Page d'accueil avec navigation et persistance
- **WorkEvent** : Modèle de données pour les événements (avec sérialisation JSON)
- **Parser CSV** : Logique d'import et traitement des fichiers
- **Persistance** : Sauvegarde/chargement automatique avec SharedPreferences

## 🎯 Fonctionnalités détaillées

### Import CSV et persistance
- Parsing automatique des fichiers CSV
- **Sauvegarde automatique** après chaque import
- **Rechargement automatique** au démarrage de l'application
- Support des différents encodages
- Validation des données
- Messages d'erreur informatifs

### Interface utilisateur
- Design Material 3 moderne
- Animations fluides
- **Navigation intuitive** avec boutons dédiés
- **Bouton "Aujourd'hui"** pour navigation rapide
- **Bouton réinitialiser** avec confirmation
- Responsive design
- **Indicateurs visuels** (semaine actuelle, compteur d'événements)

### Gestion des semaines
- Détection automatique de la semaine courante
- Navigation entre semaines avec flèches
- Affichage du lundi au dimanche
- **Indicateur "Aujourd'hui"** sur les événements du jour
- **Badge "Actuelle"** sur la semaine courante
- **Navigation rapide** vers la semaine courante

### Persistance des données
- **Sauvegarde locale** sécurisée avec SharedPreferences
- **Rechargement automatique** du dernier planning au démarrage
- **Gestion des erreurs** avec fallback vers les données d'exemple
- **Option de réinitialisation** avec dialogue de confirmation

## 🚀 Fonctionnalités à venir

- [ ] Export des plannings modifiés
- [ ] Édition des événements dans l'app
- [ ] Notifications pour les événements
- [ ] Thème sombre
- [ ] Synchronisation cloud
- [ ] Support multi-langues
- [ ] Statistiques de travail
- [ ] Backup/restore des plannings
- [ ] Import depuis Google Calendar
- [ ] Mode hors ligne complet

## 🧪 Tests

```bash
# Lancer les tests
flutter test

# Analyser le code
flutter analyze

# Vérifier les bonnes pratiques
flutter doctor
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

## 📱 Utilisation

### Premier lancement
1. L'application démarre avec des **données d'exemple** pour tester l'interface
2. Utilisez le bouton **"Importer CSV"** pour charger votre planning
3. Les données sont **automatiquement sauvegardées** localement

### Navigation
- **Flèches gauche/droite** : Naviguer entre les semaines
- **Bouton "Aujourd'hui"** : Revenir rapidement à la semaine courante
- **Bouton reset (🔄)** : Réinitialiser avec les données d'exemple

### Gestion des données
- **Sauvegarde automatique** : Vos données sont préservées entre les sessions
- **Pas de connexion requise** : Tout fonctionne en mode hors ligne
- **Réinitialisation** : Possibilité de revenir aux données d'exemple

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
- Testez la persistance des données
- Vérifiez la compatibilité Android/iOS

## 🐛 Signaler un bug

Si vous trouvez un bug, n'hésitez pas à [ouvrir une issue](https://github.com/Jynra/work-schedule-app/issues) avec :
- Description détaillée du problème
- Étapes pour reproduire
- Captures d'écran si applicable
- Informations sur l'environnement (OS, version Flutter, etc.)
- **Préciser si le bug concerne la persistance des données**

## 🔧 Dépannage

### Problèmes courants

**Les données ne se sauvegardent pas :**
- Vérifiez les permissions de l'application
- Redémarrez l'application après import

**Import CSV échoue :**
- Vérifiez le format du fichier (virgules comme séparateurs)
- Assurez-vous que les en-têtes sont corrects : `date,horaire,poste,taches`
- Utilisez le format de date YYYY-MM-DD

**Navigation bloquée :**
- Utilisez le bouton "Aujourd'hui" pour revenir à la semaine courante
- Réinitialisez avec le bouton reset si nécessaire

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

**Version actuelle : 1.0.0** - Avec persistance automatique des données et navigation améliorée