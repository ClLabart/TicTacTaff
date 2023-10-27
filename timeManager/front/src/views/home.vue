<template>
  <LoginComponent
      v-if="!isConnected"
      @connected="connectedMethod"
  />
  <ConnectedComponent v-if="isConnected" />
</template>

<script>
import LoginComponent from "@/components/connexion/loginComponent.vue";
import ConnectedComponent from "@/components/connexion/connectedComponent.vue";

export default {
  name: 'HomePage',
  components: {
    LoginComponent,
    ConnectedComponent
  },
  data() {
    return {
      connected: true
    }
  },

  computed: {
    isConnected() {
      return this.connected
    }
  },

  methods : {
    connectedMethod (value) {
      this.connected = value
    }
  }
}

</script>

<style scoped>
  
</style>