<template>

  <div class="flex justify-between">
    <div>
      <PieChart :id="id" />
    </div>
    <div>
      <RadarChart :id="id" />
    </div>
  </div>
</template>

<script>
import PieChart from "@/components/graphs/pieChart.vue";
import RadarChart from "@/components/graphs/radarChart.vue";
import {mapGetters} from "vuex";
export default  {
  name: 'StatUserTeam',

  components: {
    PieChart,
    RadarChart
  },

  props: {
    id: {
      type: Number,
      required: true
    }
  },

  computed: {
    ...mapGetters("team", ["getTeam"]),
    user () {
      return this.getTeam.users.find(member => member.id === this.id)
    }
  }
}

</script>

<style scoped>

</style>