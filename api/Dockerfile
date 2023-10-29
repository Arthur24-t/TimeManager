
# Utiliser une image Elixir officielle comme image de base
FROM elixir:latest

# Mettre à jour et installer les paquets nécessaires
RUN apt-get update && apt-get install -y inotify-tools && apt-get clean

# Créer et définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration et le code source dans l'image
COPY . .

# Installer les dépendances Hex et rebar
RUN mix local.hex --force && mix local.rebar --force

# Installer les dépendances du projet
RUN mix deps.get

# Compiler le projet
RUN mix compile

# Exposer le port sur lequel l'application va s'exécuter
EXPOSE 4000

# Définir la commande pour démarrer l'application
CMD ["mix", "phx.server"]
