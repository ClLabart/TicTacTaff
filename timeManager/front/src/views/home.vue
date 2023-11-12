<template>
    <div :class="{ 'centerContent': !isConnected }" class="h-full">
        <LoginComponent v-if="!isConnected" @connected="connect" />
        <ConnectedComponent v-if="isConnected" />
    </div>
</template>

<script>
import LoginComponent from "@/components/connexion/loginComponent.vue";
import ConnectedComponent from "@/components/connexion/connectedComponent.vue";
import { mapActions } from "vuex";

export default {
    name: "HomePage",
    components: {
        LoginComponent,
        ConnectedComponent,
    },
    data() {
        return {
            connected: null,
        };
    },

    computed: {
        isConnected() {
            return this.connected;
        },
    },

    mounted() {
      if(localStorage.getItem('user') === null) {
        this.connected = false;
      } else {
        this.updateCurrentUser(JSON.parse(localStorage.getItem('user')));
        this.showComponent({"type": "dashboard"});
        this.connected = true;
      }
    },

  methods: {
        ...mapActions("user", ["updateCurrentUser"]),
        ...mapActions("component", ["showComponent"]),
        connect(connected) {
          this.updateCurrentUser(JSON.parse(localStorage.getItem('user')));
          this.showComponent({"type": "dashboard"});
          this.connected = connected;
        },
    },
};
</script>

<style>
@media (min-width: 768px) {
    .centerContent {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100%;
    }
}
</style>
