<template>
  <button v-if="showButton && currentUser.role === 'supermanager'" @click="show">
    Créer une équipe
  </button>
  <button v-else-if="currentUser.role === 'supermanager'" @click="show">
    Retour
  </button>
  <CreateTeam v-if="!showComponent && currentUser.role === 'supermanager'" />
  <EditTeam v-else-if="showComponent && loaded" />
</template>

<script>
import CreateTeam from "@/components/team/createTeam.vue";
import EditTeam from "@/components/team/editTeam.vue";

import { mapGetters, mapActions } from "vuex";
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
      loaded: false,
    };
  },

  computed: {
    ...mapGetters("user", ["currentUser"]),
    ...mapGetters("team", ["getTeam"]),
  },

  async mounted () {
    await this.get(this.currentUser.team.id)
    this.loaded = true
  },


  methods: {
    ...mapActions("team", ["get"]),
    show() {
      this.showComponent = !this.showComponent;
      this.showButton = !this.showButton;
    },
  },
};

</script>

<style scoped>

</style>