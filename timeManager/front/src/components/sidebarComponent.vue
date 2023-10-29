<template>
    <div class="sidebar">
        <div class="inline-flex">
            <div class="logoContainer">
                <!-- Logo du site web -->
                <img :src="profileImage" alt="Logo de Batman" class="logo" />
            </div>
            <div>
                <!-- Nom d'utilisateur -->
                <span>Bonjour 🤝</span>
                <span>{{ username }}</span>
            </div>
        </div>

        <div>
            <!-- Catégorie de menu 1 -->
            <div class="menu-category">
                Menu
                <!-- Éléments du menu 1 -->
                <button>Accueil</button>
                <button>Pointeuse</button>
                <button @click="type = 'workingTimes'">Temps</button>
            </div>

            <!-- Catégorie de menu 2 -->
            <div class="menu-category">
              Paramètres
                <!-- Éléments du menu 2 -->
                <button @click="type = 'userComponent'">Profil</button>
                <button>Se déconnecter</button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: {
      profileImage: String,
      username: String,
    },

  data() {
    return {
      type: null,
    };
  },

  watch: {
    type() {
      this.$emit("type", this.type);
    },
  },
}
</script>

<style scoped>
/* Styles de la barre latérale */
.sidebar {
    height: calc(100% - 2rem);
    width: 100%;
    background-color: #f5f5f5;
    padding: 1rem 2rem 1rem 2rem;
    color: black;
    margin: 1rem;
    border-radius: 10px;
}

.logoContainer {
    width: 100%;
    height: 100%;
}

/* Style de l'image de profil */
.logo {
    width: 80%;
    height: 80%;
}

/* Style du nom d'utilisateur */

/* Style des catégories de menus */
.menu-category {
    margin-top: 20px;
}

/* Style des éléments de menu */
.menu-item {
    padding: 10px;
    text-align: center;
    text-decoration: none;
    display: block;
    color: #fff;
}

.menu-item:hover {
    background-color: #555;
}
</style>
