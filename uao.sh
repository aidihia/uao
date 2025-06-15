#!/bin/bash

# =============================================================================
# UAO - Unzip And Open
# =============================================================================
# Script pour extraire automatiquement une archive ZIP et l'ouvrir dans IntelliJ IDEA
#
# Usage: uao path/to/archive.zip
# Usage avec debug: DEBUG=y uao path/to/archive.zip
#
# Auteur: Ayoub ID-IHIA
# Date: $(date +%Y-%m-%d)
# Version: 1.0
# =============================================================================

# Configuration du mode debug
# Pour activer le logging, utiliser la commande: DEBUG=y uao ...
debug=${DEBUG:-n}

# Fonction de logging conditionnelle
# Affiche les messages uniquement si le mode debug est activé
function log {
  message=$1
  if [[ ! -z "$message" ]] ; then
    # Test si debug n'est pas égal à "n", alors affiche le message
    `test ".$debug" != ".n"` && echo "$message"
  fi
}

# =============================================================================
# VÉRIFICATION DES PRÉREQUIS
# =============================================================================

# Vérification de la présence de la commande unzip
unzip_path=`command -v unzip`
log "Chemin de unzip: $unzip_path"
if [[ -z "$unzip_path" ]] ; then
  echo "❌ Erreur: impossible de trouver la commande 'unzip'"
  echo "   Installez unzip: sudo apt-get install unzip"
  exit -1
fi

# Vérification de la présence de la commande idea (IntelliJ IDEA)
idea_path=`command -v idea`
log "Chemin d'IntelliJ IDEA: $idea_path"
if [[ -z "$idea_path" ]] ; then
  echo "❌ Erreur: impossible de trouver la commande 'idea'"
  echo "   Installez IntelliJ IDEA et configurez la commande line launcher"
  echo "   Ou créez un lien symbolique: sudo ln -s /path/to/idea/bin/idea.sh /usr/local/bin/idea"
  exit -1
fi

# =============================================================================
# TRAITEMENT DES PARAMÈTRES
# =============================================================================

# Construction du chemin absolu de l'archive
# Cette ligne complexe permet d'obtenir le chemin absolu même si un chemin relatif est fourni
archive="$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
log "Archive à traiter: $archive"

# Vérification qu'une archive a été fournie en paramètre
if [[ -z "$archive" ]] ; then
  echo "❌ Usage: $0 chemin/vers/archive.zip"
  echo ""
  echo "Exemples:"
  echo "  $0 ./project.zip"
  echo "  $0 /home/user/Downloads/source-code.zip"
  echo "  DEBUG=y $0 ./project.zip  # avec mode debug"
  exit 1
fi

# Extraction du nom du répertoire à partir du nom de l'archive
# basename supprime l'extension .zip pour créer le nom du dossier de destination
dir=`basename "$archive" .zip`
log "Répertoire de destination: $dir"

# Vérification que l'extension .zip a bien été supprimée
# Si le nom contient encore .zip, c'est que basename a échoué
if [[ "$dir" == *.zip ]] ; then
  echo "❌ Erreur: impossible d'analyser le nom du répertoire pour l'archive $archive"
  echo "   Vérifiez que le fichier a bien l'extension .zip"
  exit 2
fi

# Vérification que le répertoire de destination n'existe pas déjà
if [[ -d "$dir" ]] ; then
  echo "❌ Erreur: le répertoire '$dir' existe déjà"
  echo "   Supprimez-le ou renommez-le avant de continuer"
  exit 3
fi

# =============================================================================
# EXTRACTION ET OUVERTURE
# =============================================================================

# Récupération du répertoire parent de l'archive
parent="$(dirname "$archive")"
log "Répertoire parent: $parent"

# Création du répertoire de destination
log "🔨 Création du répertoire: $parent/$dir"
mkdir "$parent/$dir"
if [[ $? -ne 0 ]] ; then
  echo "❌ Erreur: impossible de créer le répertoire $parent/$dir"
  exit 4
fi

# Extraction de l'archive dans le répertoire de destination
log "📦 Extraction de l'archive: unzip -d $parent/$dir $archive"
echo "🚀 Extraction en cours..."
unzip -d "$parent/$dir" "$archive"
if [[ $? -ne 0 ]] ; then
  echo "❌ Erreur: échec de l'extraction de l'archive"
  # Nettoyage du répertoire créé en cas d'échec
  rmdir "$parent/$dir" 2>/dev/null
  exit 5
fi

# Ouverture du projet dans IntelliJ IDEA
log "💡 Ouverture dans IntelliJ IDEA: idea $parent/$dir/"
echo "✅ Extraction terminée, ouverture dans IntelliJ IDEA..."
idea "$parent/$dir/"

echo "🎉 Terminé ! Le projet a été extrait dans '$parent/$dir' et ouvert dans IntelliJ IDEA."