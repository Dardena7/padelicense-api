# L'image de base : Ruby 3.3.9 sur Debian Bookworm (version slim = plus légère)
# "slim" signifie qu'on part d'un Linux minimal, sans les outils inutiles (docs, man pages, etc.)
FROM ruby:3.3.9-slim-bookworm

# On installe les paquets système dont Rails a besoin :
# - build-essential : compilateur C (certaines gems ont des extensions natives en C)
# - libpq-dev : headers PostgreSQL (nécessaire pour compiler la gem 'pg')
# - git : certaines gems sont installées depuis des repos git
# - curl : utilitaire pour télécharger des fichiers (healthchecks, etc.)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Le dossier de travail dans le container
# Toutes les commandes suivantes s'exécuteront depuis /app
WORKDIR /app

# On copie d'abord UNIQUEMENT le Gemfile (et Gemfile.lock s'il existe)
# Pourquoi pas tout le projet d'un coup ? Pour le CACHE Docker.
# Docker crée un "layer" (couche) à chaque instruction.
# Si le Gemfile n'a pas changé, Docker réutilise le cache du bundle install
# → tu ne réinstalles pas toutes les gems à chaque changement de code.
COPY Gemfile Gemfile.lock* ./

# Installe les gems Ruby (équivalent de npm install pour Node)
RUN bundle install

# Maintenant on copie tout le reste du code
COPY . .

# Le port sur lequel Rails écoute
EXPOSE 3000

# La commande par défaut quand le container démarre
# - "0.0.0.0" = écoute sur toutes les interfaces réseau (nécessaire dans Docker,
#   sinon Rails n'écoute que sur localhost qui est isolé dans le container)
CMD ["rails", "server", "-b", "0.0.0.0"]
