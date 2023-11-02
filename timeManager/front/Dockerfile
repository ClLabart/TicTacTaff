# ETAPE DE CONSTRUCTION
FROM node:lts-alpine as build
# Dossier de travail
WORKDIR /app
# Copie des packages json
COPY package*.json ./
# Copie des fichiers
COPY . .
# Installation des dépendances
RUN npm install
# Construire l'app
RUN npm run build

# ETAPE DE DÉPLOIEMENT
FROM nginx:stable-alpine as prod
# Copie des fichiers
COPY --from=build /app/dist /usr/share/nginx/html
# Exposer le port de l'appli
EXPOSE 80
# Démarrer nginx
CMD [ "nginx", "-g", "daemon off;" ]
