<template>
  <LoginComponent
      v-if="!connexion"
  />
  <ConnectedComponent v-if="connexion" />
</template>

<script>
import LoginComponent from "@/components/connexion/loginComponent.vue";
import ConnectedComponent from "@/components/connexion/connectedComponent.vue";

import { mapGetters } from 'vuex'
export default {
  name: 'HomePage',
  components: {
    LoginComponent,
    ConnectedComponent
  },

  computed: {
    ...mapGetters('user', ['isConnected']),
    connexion() {
      return this.isConnected
    }
  },
}

</script>

<style scoped>

</style>
