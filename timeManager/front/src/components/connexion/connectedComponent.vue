<template>
    <div class="grid grid-cols-4 h-full">
        <!-- Utilisez le composant Sidebar ici -->
        <SidebarComponent
            :profileImage="require('@/assets/imgs/Logo_Batman.png')"
            :username="username"
            class="col-span-1 h-full"
        />
        <main class="col-span-3" :class="[component.type !== '' ? active : '']">
            <!-- <div> -->
            <Stats v-if="component.type === 'dashboard'" :user="currentUser" />
            <UserComponent v-if="component.type === 'userComponent'" />
            <!-- </div> -->
            <!-- <div> -->
            <WorkingTimes v-if="component.type === 'workingTimes'" />
            <!-- </div> -->
            <!-- <div> -->
            <!-- </div> -->
            <!-- <div> -->
            <TeamComponent v-if="component.type === 'teamComponent'" />
            <!-- </div> -->
            <!-- <div> -->
            <ClockManager v-if="component.type === 'clock'" />
            <!-- </div> -->
        </main>
    </div>
</template>

<script>
import SidebarComponent from "@/components/sidebarComponent.vue";
//import ChartManager from "@/components/chartManager.vue";
import ClockManager from "@/components/clockManager.vue";
import Stats from "@/components/stats.vue";
import UserComponent from "@/components/userComponent.vue";
import WorkingTimes from "@/components/workingTimes.vue";
import { mapGetters } from "vuex";
import TeamComponent from "@/components/team.vue";

export default {
    name: "ConnectedComponent",
    components: {
      TeamComponent,
      WorkingTimes,
      SidebarComponent,
      UserComponent,
      Stats,
      ClockManager,
    },

    data() {
        return {
            username: "Batman",
            active: "h-[calc(100%-2rem)] rounded-xl m-4 bg-[#f5f5f5]",
        };
    },

    computed: {
        ...mapGetters("component", ["getComponent"]),
        ...mapGetters("user", ["currentUser"]),
        component() {
            return this.getComponent;
        },
    },

};
</script>

<style></style>
