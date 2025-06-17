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
git clone https://github.com/Jynra/work_schedule_app.git
cd work_schedule_app
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

- **Flutter** - Framework UI
- **Dart** - Langage de programmation
- **Material Design 3** - Interface utilisateur
- **file_picker** - Sélection de fichiers
- **intl** - Internationalisation

## 🔧 Structure du projet

```
lib/
├── main.dart           # Point d'entrée de l'application
├── models/             # Modèles de données
└── widgets/            # Widgets personnalisés
```

## 🚀 Fonctionnalités à venir

- [ ] Export des plannings modifiés
- [ ] Édition des événements dans l'app
- [ ] Notifications pour les événements
- [ ] Thème sombre
- [ ] Synchronisation cloud

## 🤝 Contribution

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrez une Pull Request

## 🐛 Signaler un bug

Si vous trouvez un bug, n'hésitez pas à [ouvrir une issue](https://github.com/Jynra/work_schedule_app/issues).

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🙏 Remerciements

- Flutter team pour le framework
- Material Design pour les guidelines UI
- Communauté Flutter pour les packages

---

Développé avec ❤️ en Flutter par [Jynra](https://github.com/Jynra)