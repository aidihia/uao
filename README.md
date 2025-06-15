# UAO - Unzip And Open 📦💡

Script bash pour extraire une archive ZIP et l'ouvrir automatiquement dans IntelliJ IDEA.

[![Shell Script](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🚀 Installation

```bash
# Installation rapide
curl -fsSL https://raw.githubusercontent.com/aidihia/uao/main/uao.sh -o ~/bin/uao
chmod +x ~/bin/uao
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Prérequis
- `unzip` : `sudo apt-get install unzip`
- IntelliJ IDEA avec commande `idea` configurée

**Configurer la commande `idea` :**
- Dans IntelliJ : **Tools** → **Create Command-line Launcher**
- Ou : `sudo ln -s /path/to/idea/bin/idea.sh /usr/local/bin/idea`

## 📖 Usage

```bash
# Usage basique
uao mon-projet.zip
uao /path/to/archive.zip

# Mode debug
DEBUG=y uao mon-projet.zip
```

## ⚠️ Codes d'erreur

| Code | Erreur | Solution |
|------|--------|----------|
| -1 | `unzip` ou `idea` manquant | Installer les prérequis |
| 1 | Aucune archive spécifiée | `uao archive.zip` |
| 2 | Extension non .zip | Vérifier le fichier |
| 3 | Dossier existe déjà | Supprimer/renommer le dossier |
| 4-5 | Erreur extraction | Vérifier permissions/archive |

## 🤝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/amélioration`)
3. Commit (`git commit -am 'Ajout fonctionnalité'`)
4. Push (`git push origin feature/amélioration`)
5. Ouvrir une Pull Request

## 📄 Licence

MIT License - voir [LICENSE](LICENSE)

---

**Bugs/Questions** : [Issues GitHub](https://github.com/aidihia/uao/issues)