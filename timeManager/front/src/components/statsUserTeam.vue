<template>
  <div class="flex">
    <div>
      <PieChart />
    </div>
    <div>
      <RadarChart />
    </div>
  </div>
</template>

<script>
import PieChart from "@/components/graphs/pieChart.vue";
import RadarChart from "@/components/graphs/radarChart.vue";

export default  {
  name: 'StatUserTeam',
  components: {
    PieChart,
    RadarChart
  },
}

</script>

<style scoped>

</style>