<template>
  <NavbarComponent/>
  <div>
    hello world
  </div>
  <div>
    <UserComponent/>
  </div>
  <div>
    <WorkingTime />
  </div>
  <div>
    <WorkingTimes />
  </div>
  <div>
    <ChartManager />
  </div>
  <div>
    <ClockManager />
  </div>




</template>

<script>
import NavbarComponent from '@/components/layout/navbarComponent.vue'
import ChartManager from "@/components/chartManager.vue";
import ClockManager from "@/components/clockManager.vue";
import UserComponent from "@/components/userComponent.vue";
import WorkingTime from "@/components/workingTime.vue";
import WorkingTimes from "@/components/workingTimes.vue";

export default {
  name: 'ConnectedComponent',
  components: {
    NavbarComponent,
    ChartManager,
    ClockManager,
    UserComponent,
    WorkingTime,
    WorkingTimes,
  },

}

</script>

<style scoped>

</style>
