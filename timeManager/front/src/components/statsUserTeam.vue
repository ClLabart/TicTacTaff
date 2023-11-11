<template>
  <div class="">
    <div>
      <Stats
          :user="user"
          :stat-team="true"
          :selected-date-start="selectedDateStart"
          @hide='hide'
      />
    </div>
    <div class="flex justify-between">
      <div>
        <PieChart :id="id" />
      </div>
      <div>
        <RadarChart :id="id" />
      </div>
    </div>
  </div>
</template>

<script>
import PieChart from "@/components/graphs/pieChart.vue";
import RadarChart from "@/components/graphs/radarChart.vue";
import {mapGetters, mapActions} from "vuex";
import Stats from "@/components/stats.vue";
import moment from "moment";
export default  {
  name: 'StatUserTeam',

  components: {
    Stats,
    PieChart,
    RadarChart
  },

  props: {
    id: {
      type: Number,
      required: true
    },
    selectedDateStart: {
      type: String,
      default: moment().format("YYYY-MM-DD")
    }
  },

  computed: {
    ...mapGetters("team", ["getTeam"]),
    user () {
      return this.getTeam.users.find(member => member.id === this.id)
    }
  },

  watch: {
    'selectedDateStart': {
      handler: function (val) {
        this.handleChangeDate(val);
      },
      deep: true
    }
  },

  methods: {
    ...mapActions("team", ["allHoursTeam"]),
    hide () {
      this.$emit('hide', true);
    },
    async handleChangeDate(value) {
      const start = moment(value).startOf('day').format("YYYY-MM-DDTHH:mm:ss");
      const end = moment(value).endOf('day').format("YYYY-MM-DDTHH:mm:ss");
      await this.allHoursTeam({id : this.getTeam.id, start, end});
    }
  }
}

</script>

<style scoped>

</style>