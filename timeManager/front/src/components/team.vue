<template>
  <button v-if="showButton && currentUser.role === 'supermanager'" @click="show">
    Créer une équipe
  </button>
  <button v-else-if="currentUser === 'supermanager'" @click="show">
    Retour
  </button>
  <CreateTeam v-if="!showComponent && currentUser.role === 'supermanager'" />
  <EditTeam v-else />
</template>

<script>
import CreateTeam from "@/components/team/createTeam.vue";
import EditTeam from "@/components/team/editTeam.vue";

import { mapGetters } from "vuex";
export default {

  name: "TeamComponent",
  components: {
    CreateTeam,
    EditTeam,
  },

  data() {
    return {
      showComponent: true,
      showButton: true,
    };
  },

  computed: {
    ...mapGetters("user", ["currentUser"])
  },


  methods: {
    show() {
      this.showComponent = !this.showComponent;
      this.showButton = !this.showButton;
    },
  },
};

</script>

<style scoped>

</style>