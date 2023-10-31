<template>
  <h1 className="text-3xl font-bold underline test">
      Hello world!
    </h1>
  <LoginComponent
      v-if="!isConnected"
      @connected="isConnected()"
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
    ConnectedComponent,
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
  }
}

</script>

<style scoped>

</style>
