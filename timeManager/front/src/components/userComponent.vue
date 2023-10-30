<template>
  <CreateProfile />
<!--
  <EditProfile v-if="component.type === 'editProfile'" />
-->
</template>


<script>
import CreateProfile from "@/components/user/createProfile.vue";
import EditProfile from "@/components/user/editProfile.vue";

export default {
  name: "UserComponent",
  components: {
    CreateProfile,
    EditProfile
  },
}
</script>

<style scoped>

</style>