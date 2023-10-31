<template>
    <div class="grid grid-cols-4 h-full">
        <!-- Utilisez le composant Sidebar ici -->
        <SidebarComponent
            :profileImage="require('@/assets/imgs/Logo_Batman.png')"
            :username="username"
            class="col-span-1 h-full"
        />
        <main class="col-span-3 h-full">
            <div>
                <UserComponent v-if="component.type === 'userComponent'" />
            </div>
            <!--            <div>
              <WorkingTime />
          </div>-->
            <div>
                <WorkingTimes
                    v-if="component.type === 'workingTimes'"
                />
            </div>
            <!--            <div>
              <ChartManager />
          </div>-->
            <!--            <div>
              <ClockManager />
          </div>-->
        </main>
    </div>
</template>

<script>
import SidebarComponent from "@/components/sidebarComponent.vue";
//import ChartManager from "@/components/chartManager.vue";
//import ClockManager from "@/components/clockManager.vue";
import UserComponent from "@/components/userComponent.vue";
//import WorkingTime from "@/components/workingTime.vue";
import WorkingTimes from "@/components/workingTimes.vue";
import { mapGetters } from "vuex";

export default {
    name: "ConnectedComponent",
    components: {
        WorkingTimes,
        SidebarComponent,
        UserComponent,
    },

    data() {
        return {
            username: "Batman",
        };
    },

    computed: {
        ...mapGetters("component", ["getComponent"]),
        component() {
            return this.getComponent;
        },
    },
};
</script>

<style></style>
