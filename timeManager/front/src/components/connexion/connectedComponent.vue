<template>
    <div class="">
        <!-- Utilisez le composant Sidebar ici -->
        <SidebarComponent
            :profileImage="require('@/assets/imgs/Logo_Batman.png')"
            :username="username"
            class=""
        />
        <div class="">
          <div>
              <UserComponent v-if="component.type === 'userComponent'" />
          </div>
<!--            <div>
              <WorkingTime />
          </div>-->
          <div>
              <All-users-working-times v-if="component.type === 'workingTimes'"/>
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
import { mapGetters } from "vuex";

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
      };
    },

  computed: {
    ...mapGetters('component', ['getComponent']),
    component () {
      return this.getComponent;
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
