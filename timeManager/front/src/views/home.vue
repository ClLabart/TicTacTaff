<template>
  <NavbarComponent />
  <div>
    hello world
  </div>
  <div>
    <UserComponent />
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
import workingTime from "@/components/workingTime.vue";
import workingTimes from "@/components/workingTimes.vue";
export default {
  name: 'HomePage',
  components: {
    NavbarComponent,
    ChartManager,
    ClockManager,
    UserComponent,
    workingTime,
    workingTimes
  },

  async mounted() {
    const user = await fetch('http://localhost:4000/api/users/6'
    ).then(res => res.json())
    console.log('user', user)
  }
}

</script>

<style scoped>

</style>
