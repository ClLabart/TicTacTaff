<template>
  <button v-if="showButton" @click="show">
    Créer une équipe
  </button>
  <button v-else @click="show">
    Retour
  </button>
  <CreateTeam v-if="!showComponent" />
  <EditTeam v-else />
</template>

<script>
import CreateTeam from "@/components/team/createTeam.vue";
import EditTeam from "@/components/team/editTeam.vue";
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