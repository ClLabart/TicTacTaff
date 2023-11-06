<template>
  <CreateTeam />
  <EditTeam />
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
};

</script>

<style scoped>

</style>