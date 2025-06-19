# Planning de Travail 📅

Une application Flutter moderne pour gérer et visualiser vos plannings de travail hebdomadaires avec persistance automatique des données, mode sombre et **support des horaires multiples**.

## ✨ Fonctionnalités

- 📱 **Interface mobile native** (Android/iOS)
- 📊 **Import CSV** pour charger vos plannings
- ⏰ **Horaires multiples** dans la même journée (ex: 08:00-12:00 | 14:00-18:00)
- 🌙 **Horaires de nuit** gérés automatiquement (ex: 22:00-06:00)
- 💾 **Sauvegarde automatique** du dernier planning importé
- 📅 **Vue hebdomadaire** du lundi au dimanche
- 🔄 **Navigation** entre les semaines
- 🎯 **Bouton "Aujourd'hui"** pour revenir rapidement à la semaine courante
- 🔄 **Bouton réinitialiser** pour revenir aux données d'exemple
- 🌙 **Mode sombre** avec basculement automatique et persistance
- 🇫🇷 **Support français** complet
- 🎨 **Design moderne** et responsive
- 📊 **Indicateurs visuels** (semaine actuelle, badge "Coupure" pour horaires multiples)
- ⏱️ **Calcul automatique** du temps total travaillé par jour
- 🧹 **Interface épurée** sans indicateurs de pause superflus

## 📱 Captures d'écran

![Interface principale](screenshots/main_screen.png)
![Mode sombre](screenshots/dark_mode.png)
![Import CSV](screenshots/csv_import.png)
![Horaires multiples](screenshots/multiple_schedules.png)

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

L'application accepte les fichiers CSV avec ce format, **incluant les horaires multiples** :

### Format standard
```csv
date,horaire,poste,taches
2025-06-30,08:00-16:00,Bureau,Réunion équipe
2025-07-01,09:00-17:00,Site A,Formation
2025-07-02,Repos,Congé,Jour de repos
```

### **Nouveauté : Horaires multiples** 🆕
```csv
date,horaire,poste,taches
2025-06-30,"08:00-12:00 | 14:00-18:00",Bureau Principal,"Matin: réunions, après-midi: formation"
2025-07-01,10:00-15:00 puis 18:00-22:00,Site A,Supervision jour et nuit
2025-07-02,09:00-13:00 / 15:00-17:00,Site B,Double vacation
2025-07-03,22:00-06:00,Site C,Équipe de nuit (8h)
2025-07-04,Repos,Congé,Jour de repos
```

### **Séparateurs supportés pour horaires multiples :**
- `|` : `08:00-12:00 | 14:00-18:00`
- `puis` : `10:00-15:00 puis 18:00-22:00`
- `/` : `09:00-13:00 / 15:00-17:00`
- `+` : `08:00-12:00 + 14:00-18:00`
- `et` : `09:00-13:00 et 15:00-17:00`

### Colonnes supportées :
- **date** : Format YYYY-MM-DD
- **horaire** : Plage horaire simple, multiple ou "Repos"
- **poste** : Lieu de travail
- **taches** : Description des activités

## 📂 Fichier CSV de test complet

Un fichier de test avec horaires multiples pour juin 2025 :

```csv
date,horaire,poste,taches
2025-06-16,"08:00-12:00 | 14:00-18:00",Bureau Principal,"Réunion matin, formation après-midi"
2025-06-17,09:00-17:00,Site A,Formation continue
2025-06-18,08:30-12:30 puis 14:00-16:30,Bureau Principal,"Planification matin, suivi projets après-midi"
2025-06-19,10:00-15:00 / 18:00-22:00,Site B,"Contrôle qualité jour, audit nuit"
2025-06-20,08:00-16:00,Bureau Principal,Réunions clients
2025-06-21,09:00-13:00,Domicile,Travail à distance
2025-06-22,Repos,Congé,Jour de repos
2025-06-23,22:00-06:00,Site C,Équipe de nuit (8h)
2025-06-24,07:00-11:00 + 13:00-17:00,Site A,Double vacation
```

*L'application détecte automatiquement les horaires multiples et affiche le temps total travaillé.*

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
- **WorkScheduleApp** : Widget principal de l'application avec gestion des thèmes
- **WorkScheduleHomePage** : Page d'accueil avec navigation et persistance
- **WorkEvent** : Modèle de données pour les événements (avec sérialisation JSON et horaires multiples)
- **TimeSlot** : 🆕 Classe pour gérer les créneaux horaires individuels
- **Parser CSV** : Logique d'import et traitement des fichiers avec détection automatique des horaires multiples
- **Persistance** : Sauvegarde/chargement automatique avec SharedPreferences

## 🎯 Fonctionnalités détaillées

### **⏰ Gestion des horaires multiples** 🆕
- **Détection automatique** des créneaux multiples dans une journée
- **Parsing intelligent** avec support de 5 séparateurs différents
- **Calcul automatique** du temps total travaillé
- **Badge "Coupure"** pour identifier les journées avec horaires multiples
- **Affichage séquentiel** des créneaux sans indicateurs de pause
- **Horaires de nuit** calculés correctement (ex: 22:00-06:00 = 8h)

### Import CSV et persistance
- Parsing automatique des fichiers CSV
- **Support des horaires multiples** avec détection automatique
- **Sauvegarde automatique** après chaque import
- **Rechargement automatique** au démarrage de l'application
- Support des différents encodages et guillemets
- Validation des données avec avertissements détaillés
- Messages d'erreur informatifs

### Interface utilisateur
- Design Material 3 moderne
- **Affichage uniforme** pour créneaux simples et multiples
- **Badge "Coupure"** discret pour les journées avec horaires multiples
- **Calcul du temps total** affiché pour chaque jour
- **Interface épurée** sans éléments superflus
- **Mode sombre/clair** avec basculement fluide
- **Persistance du thème** choisi par l'utilisateur
- Animations fluides et transitions élégantes
- **Navigation intuitive** avec boutons dédiés
- **Bouton "Aujourd'hui"** pour navigation rapide
- **Bouton réinitialiser** avec confirmation
- Responsive design adaptatif

### Mode sombre 🌙
- **Basculement instantané** avec bouton discret dans le header
- **Couleurs adaptatives** pour une expérience optimale
- **Persistance automatique** de la préférence utilisateur
- **Dégradés personnalisés** pour chaque mode
- **Contrastes optimisés** pour la lisibilité
- **Icônes animées** pour le feedback visuel

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
- **Sauvegarde des préférences** (thème, paramètres)
- **Gestion des erreurs** avec fallback vers les données d'exemple
- **Option de réinitialisation** avec dialogue de confirmation

## 🚀 Fonctionnalités à venir

- [ ] Export des plannings modifiés
- [ ] Édition des événements dans l'app
- [ ] Notifications pour les événements
- [x] ~~Thème sombre~~ ✅ **Implémenté**
- [x] ~~Horaires multiples~~ ✅ **Implémenté**
- [x] ~~Interface épurée~~ ✅ **Implémenté**
- [x] ~~Badge "Coupure"~~ ✅ **Implémenté**
- [ ] Synchronisation cloud
- [ ] Support multi-langues
- [ ] Statistiques de travail avancées
- [ ] Backup/restore des plannings
- [ ] Import depuis Google Calendar
- [ ] Mode hors ligne complet
- [ ] Personnalisation des couleurs
- [ ] Graphiques de temps de travail
- [ ] Export PDF des plannings

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
1. L'application démarre avec des **données d'exemple** incluant des horaires multiples
2. Utilisez le bouton **"Importer CSV"** pour charger votre planning
3. Les données sont **automatiquement sauvegardées** localement
4. Votre **préférence de thème** est également sauvegardée

### Navigation
- **Flèches gauche/droite** : Naviguer entre les semaines
- **Bouton "Aujourd'hui"** : Revenir rapidement à la semaine courante
- **Bouton reset (🔄)** : Réinitialiser avec les données d'exemple
- **Bouton thème (🌙/☀️)** : Basculer entre mode clair et sombre

### **Gestion des horaires multiples** 🆕
- **Détection automatique** lors de l'import CSV
- **Affichage en créneaux** séparés avec durées individuelles
- **Badge "Coupure"** orange pour identifier les journées avec coupures
- **Calcul du temps total** affiché en bas de chaque jour
- **Interface épurée** sans indicateurs de pause entre créneaux

### Gestion des données
- **Sauvegarde automatique** : Vos données sont préservées entre les sessions
- **Pas de connexion requise** : Tout fonctionne en mode hors ligne
- **Réinitialisation** : Possibilité de revenir aux données d'exemple
- **Persistance du thème** : Votre choix clair/sombre est mémorisé

## 🌙 Mode sombre

Le mode sombre offre :
- **Confort visuel** réduit la fatigue oculaire
- **Économie de batterie** sur écrans OLED
- **Élégance moderne** avec des dégradés sombres
- **Basculement instantané** sans redémarrage
- **Adaptation intelligente** de tous les éléments UI

## 🎨 Design et UX

### Principes de design
- **Minimalisme** : Interface épurée sans éléments superflus
- **Clarté** : Information visible d'un coup d'œil
- **Cohérence** : Comportement uniforme dans toute l'application
- **Accessibilité** : Contrastes adaptés pour tous les utilisateurs

### Améliorations récentes
- ✅ Suppression des badges "pause" pour une interface plus épurée
- ✅ Affichage séquentiel des créneaux multiples
- ✅ Badge "Coupure" pour identifier les journées à horaires multiples
- ✅ Calculs automatiques des temps totaux
- ✅ Terminologie professionnelle et claire

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
- **Testez les deux modes** (clair et sombre)
- **Testez les horaires multiples** avec différents séparateurs
- **Privilégiez la simplicité** dans l'interface utilisateur

## 🐛 Signaler un bug

Si vous trouvez un bug, n'hésitez pas à [ouvrir une issue](https://github.com/Jynra/work-schedule-app/issues) avec :
- Description détaillée du problème
- Étapes pour reproduire
- Captures d'écran si applicable
- **Mode utilisé** (clair/sombre)
- **Type d'horaires** (simple/multiple)
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
- **Nouveauté** : Encadrez les horaires multiples avec des guillemets si nécessaire

**Horaires multiples non détectés :**
- Utilisez un des séparateurs supportés : `|`, `puis`, `/`, `+`, `et`
- Vérifiez le format des heures : `HH:MM-HH:MM`
- Exemple correct : `08:00-12:00 | 14:00-18:00`

**Calculs d'heures incorrects :**
- L'application gère automatiquement les horaires de nuit
- Exemple : `22:00-06:00` = 8h (pas -16h)
- Vérifiez la console pour les messages de débogage

**Navigation bloquée :**
- Utilisez le bouton "Aujourd'hui" pour revenir à la semaine courante
- Réinitialisez avec le bouton reset si nécessaire

**Problème de thème :**
- Le mode sombre se sauvegarde automatiquement
- Redémarrez l'app si le thème ne se charge pas correctement
- Vérifiez que SharedPreferences fonctionne sur votre appareil

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

**Version actuelle : 1.4.0** - Badge "Coupure", interface épurée, horaires multiples optimisés, mode sombre et persistance automatique des données

## 📱 Captures d'écran

![Interface principale](screenshots/main_screen.png)
![Mode sombre](screenshots/dark_mode.png)
![Import CSV](screenshots/csv_import.png)
![Horaires multiples](screenshots/multiple_schedules.png)

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

L'application accepte les fichiers CSV avec ce format, **incluant les horaires multiples** :

### Format standard
```csv
date,horaire,poste,taches
2025-06-30,08:00-16:00,Bureau,Réunion équipe
2025-07-01,09:00-17:00,Site A,Formation
2025-07-02,Repos,Congé,Jour de repos
```

### **Nouveauté : Horaires multiples** 🆕
```csv
date,horaire,poste,taches
2025-06-30,"08:00-12:00 | 14:00-18:00",Bureau Principal,"Matin: réunions, après-midi: formation"
2025-07-01,10:00-15:00 puis 18:00-22:00,Site A,Supervision jour et nuit
2025-07-02,09:00-13:00 / 15:00-17:00,Site B,Double vacation
2025-07-03,22:00-06:00,Site C,Équipe de nuit (8h)
2025-07-04,Repos,Congé,Jour de repos
```

### **Séparateurs supportés pour horaires multiples :**
- `|` : `08:00-12:00 | 14:00-18:00`
- `puis` : `10:00-15:00 puis 18:00-22:00`
- `/` : `09:00-13:00 / 15:00-17:00`
- `+` : `08:00-12:00 + 14:00-18:00`
- `et` : `09:00-13:00 et 15:00-17:00`

### Colonnes supportées :
- **date** : Format YYYY-MM-DD
- **horaire** : Plage horaire simple, multiple ou "Repos"
- **poste** : Lieu de travail
- **taches** : Description des activités

## 📂 Fichier CSV de test complet

Un fichier de test avec horaires multiples pour juin 2025 :

```csv
date,horaire,poste,taches
2025-06-16,"08:00-12:00 | 14:00-18:00",Bureau Principal,"Réunion matin, formation après-midi"
2025-06-17,09:00-17:00,Site A,Formation continue
2025-06-18,08:30-12:30 puis 14:00-16:30,Bureau Principal,"Planification matin, suivi projets après-midi"
2025-06-19,10:00-15:00 / 18:00-22:00,Site B,"Contrôle qualité jour, audit nuit"
2025-06-20,08:00-16:00,Bureau Principal,Réunions clients
2025-06-21,09:00-13:00,Domicile,Travail à distance
2025-06-22,Repos,Congé,Jour de repos
2025-06-23,22:00-06:00,Site C,Équipe de nuit (8h)
2025-06-24,07:00-11:00 + 13:00-17:00,Site A,Double vacation
```

*L'application détecte automatiquement les horaires multiples et affiche le temps total travaillé.*

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
- **WorkScheduleApp** : Widget principal de l'application avec gestion des thèmes
- **WorkScheduleHomePage** : Page d'accueil avec navigation et persistance
- **WorkEvent** : Modèle de données pour les événements (avec sérialisation JSON et horaires multiples)
- **TimeSlot** : 🆕 Classe pour gérer les créneaux horaires individuels
- **Parser CSV** : Logique d'import et traitement des fichiers avec détection automatique des horaires multiples
- **Persistance** : Sauvegarde/chargement automatique avec SharedPreferences

## 🎯 Fonctionnalités détaillées

### **⏰ Gestion des horaires multiples** 🆕
- **Détection automatique** des créneaux multiples dans une journée
- **Parsing intelligent** avec support de 5 séparateurs différents
- **Calcul automatique** du temps total travaillé
- **Interface épurée** avec badges visuels pour identifier les journées multiples
- **Affichage séquentiel** des créneaux sans indicateurs de pause
- **Horaires de nuit** calculés correctement (ex: 22:00-06:00 = 8h)

### Import CSV et persistance
- Parsing automatique des fichiers CSV
- **Support des horaires multiples** avec détection automatique
- **Sauvegarde automatique** après chaque import
- **Rechargement automatique** au démarrage de l'application
- Support des différents encodages et guillemets
- Validation des données avec avertissements détaillés
- Messages d'erreur informatifs

### Interface utilisateur
- Design Material 3 moderne
- **Affichage uniforme** pour créneaux simples et multiples
- **Badges visuels** discrets pour les journées avec horaires multiples
- **Calcul du temps total** affiché pour chaque jour
- **Interface épurée** sans éléments superflus
- **Mode sombre/clair** avec basculement fluide
- **Persistance du thème** choisi par l'utilisateur
- Animations fluides et transitions élégantes
- **Navigation intuitive** avec boutons dédiés
- **Bouton "Aujourd'hui"** pour navigation rapide
- **Bouton réinitialiser** avec confirmation
- Responsive design adaptatif

### Mode sombre 🌙
- **Basculement instantané** avec bouton discret dans le header
- **Couleurs adaptatives** pour une expérience optimale
- **Persistance automatique** de la préférence utilisateur
- **Dégradés personnalisés** pour chaque mode
- **Contrastes optimisés** pour la lisibilité
- **Icônes animées** pour le feedback visuel

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
- **Sauvegarde des préférences** (thème, paramètres)
- **Gestion des erreurs** avec fallback vers les données d'exemple
- **Option de réinitialisation** avec dialogue de confirmation

## 🚀 Fonctionnalités à venir

- [ ] Export des plannings modifiés
- [ ] Édition des événements dans l'app
- [ ] Notifications pour les événements
- [x] ~~Thème sombre~~ ✅ **Implémenté**
- [x] ~~Horaires multiples~~ ✅ **Implémenté**
- [x] ~~Interface épurée~~ ✅ **Implémenté**
- [ ] Synchronisation cloud
- [ ] Support multi-langues
- [ ] Statistiques de travail avancées
- [ ] Backup/restore des plannings
- [ ] Import depuis Google Calendar
- [ ] Mode hors ligne complet
- [ ] Personnalisation des couleurs
- [ ] Graphiques de temps de travail
- [ ] Export PDF des plannings

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
1. L'application démarre avec des **données d'exemple** incluant des horaires multiples
2. Utilisez le bouton **"Importer CSV"** pour charger votre planning
3. Les données sont **automatiquement sauvegardées** localement
4. Votre **préférence de thème** est également sauvegardée

### Navigation
- **Flèches gauche/droite** : Naviguer entre les semaines
- **Bouton "Aujourd'hui"** : Revenir rapidement à la semaine courante
- **Bouton reset (🔄)** : Réinitialiser avec les données d'exemple
- **Bouton thème (🌙/☀️)** : Basculer entre mode clair et sombre

### **Gestion des horaires multiples** 🆕
- **Détection automatique** lors de l'import CSV
- **Affichage en créneaux** séparés avec durées individuelles
- **Badge orange** indiquant le nombre de créneaux pour identification rapide
- **Calcul du temps total** affiché en bas de chaque jour
- **Interface épurée** sans indicateurs de pause entre créneaux

### Gestion des données
- **Sauvegarde automatique** : Vos données sont préservées entre les sessions
- **Pas de connexion requise** : Tout fonctionne en mode hors ligne
- **Réinitialisation** : Possibilité de revenir aux données d'exemple
- **Persistance du thème** : Votre choix clair/sombre est mémorisé

## 🌙 Mode sombre

Le mode sombre offre :
- **Confort visuel** réduit la fatigue oculaire
- **Économie de batterie** sur écrans OLED
- **Élégance moderne** avec des dégradés sombres
- **Basculement instantané** sans redémarrage
- **Adaptation intelligente** de tous les éléments UI

## 🎨 Design et UX

### Principes de design
- **Minimalisme** : Interface épurée sans éléments superflus
- **Clarté** : Information visible d'un coup d'œil
- **Cohérence** : Comportement uniforme dans toute l'application
- **Accessibilité** : Contrastes adaptés pour tous les utilisateurs

### Améliorations récentes
- ✅ Suppression des badges "pause" pour une interface plus épurée
- ✅ Affichage séquentiel des créneaux multiples
- ✅ Badges discrets pour identifier les journées à horaires multiples
- ✅ Calculs automatiques des temps totaux

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
- **Testez les deux modes** (clair et sombre)
- **Testez les horaires multiples** avec différents séparateurs
- **Privilégiez la simplicité** dans l'interface utilisateur

## 🐛 Signaler un bug

Si vous trouvez un bug, n'hésitez pas à [ouvrir une issue](https://github.com/Jynra/work-schedule-app/issues) avec :
- Description détaillée du problème
- Étapes pour reproduire
- Captures d'écran si applicable
- **Mode utilisé** (clair/sombre)
- **Type d'horaires** (simple/multiple)
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
- **Nouveauté** : Encadrez les horaires multiples avec des guillemets si nécessaire

**Horaires multiples non détectés :**
- Utilisez un des séparateurs supportés : `|`, `puis`, `/`, `+`, `et`
- Vérifiez le format des heures : `HH:MM-HH:MM`
- Exemple correct : `08:00-12:00 | 14:00-18:00`

**Calculs d'heures incorrects :**
- L'application gère automatiquement les horaires de nuit
- Exemple : `22:00-06:00` = 8h (pas -16h)
- Vérifiez la console pour les messages de débogage

**Navigation bloquée :**
- Utilisez le bouton "Aujourd'hui" pour revenir à la semaine courante
- Réinitialisez avec le bouton reset si nécessaire

**Problème de thème :**
- Le mode sombre se sauvegarde automatiquement
- Redémarrez l'app si le thème ne se charge pas correctement
- Vérifiez que SharedPreferences fonctionne sur votre appareil

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

**Version actuelle : 1.3.0** - Interface épurée, horaires multiples optimisés, mode sombre et persistance automatique des données