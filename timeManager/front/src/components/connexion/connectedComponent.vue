<template>
    <div class="mainGrid">
        <!-- Utilisez le composant Sidebar ici -->
        <SidebarComponent
            :profileImage="require('@/assets/imgs/Logo_Batman.png')"
            :username="username"
            class="div1"
            @type="type"
        />
        <div class="div2">
            <div>
                <UserComponent v-if="componentType === 'userComponent'" />
            </div>
<!--            <div>
                <WorkingTime />
            </div>-->
            <div>
                <All-users-working-times v-if="componentType === 'workingTimes'" />
            </div>
<!--            <div>
                <ChartManager />
            </div>-->
<!--            <div>
                <ClockManager />
            </div>-->
        </div>
    </div>
</template>

<script>
import SidebarComponent from "@/components/sidebarComponent.vue";
//import ChartManager from "@/components/chartManager.vue";
//import ClockManager from "@/components/clockManager.vue";
import UserComponent from "@/components/userComponent.vue";
//import WorkingTime from "@/components/workingTime.vue";
import AllUsersWorkingTimes from "@/components/allUsersWorkingTimes.vue";

export default {
    name: "ConnectedComponent",
    components: {
      AllUsersWorkingTimes,
      SidebarComponent,
      UserComponent

    },

    data() {
      return {
        username: "Batman",
        componentType: null
      };
    },

  methods : {
    type(value) {
      this.componentType = value;
    }
  }
};
</script>

<style scoped>
.mainGrid {
    display: grid;
    grid-template-columns: 15% 85%;
    grid-template-rows: 1fr;
    grid-column-gap: 0px;
    grid-row-gap: 0px;
    height: 100vh;
}

.div1 {
    grid-area: 1 / 1 / 2 / 2;
}
.div2 {
    grid-area: 1 / 2 / 2 / 3;
}
</style>
