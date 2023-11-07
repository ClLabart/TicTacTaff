<template>
  <CreateProfile v-if="component.childrenType === 'create'" />
  <EditProfile v-if="component.childrenType === 'edit'" />
</template>


<script>
import CreateProfile from "@/components/user/createProfile.vue";
import EditProfile from "@/components/user/editProfile.vue";
import { mapGetters } from "vuex";

export default {
  name: "UserComponent",
  components: {
    CreateProfile,
    EditProfile
  },


  computed: {
    ...mapGetters('component', ['getComponent']),
    component () {
      return this.getComponent;
    }
  },


}
</script>

<style scoped>

</style>