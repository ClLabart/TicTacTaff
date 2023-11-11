<template>
  <div class="">
    <canvas ref="chartCanvas" class=""></canvas>
  </div>
</template>

<script>
import { Chart, registerables } from 'chart.js';
import {mapGetters} from "vuex";
import moment from "moment";

Chart.register(...registerables);

export default {
  name: 'PieChart',

  props: {
    id: {
      type: Number,
      required: true
    }
  },

  data() {
    return {
      myChart: null
    }
  },

  computed: {
    ...mapGetters("team", ["getTeam", "getAverageTime", "getMembersWithAverageTime"]),
    labels () {
      return this.getMembersWithAverageTime.map(member => member.firstname + ' ' + member.lastname)
    },
    totalUserTime () {
      return this.getMembersWithAverageTime.map(member => member.allTime)
    },
  },

  mounted () {
    this.initializeChart()
  },

  methods: {
    initializeChart() {
      const self = this;
      this.myChart = new Chart(this.$refs.chartCanvas.getContext('2d'), {
        type: 'pie',
        data: {
          labels: self.labels,
          datasets: [{
            data: self.totalUserTime,
            backgroundColor: self.randomColorsForUser().map(color => color.backgroundColor),
            borderWidth: self.randomColorsForUser().map(color => color.borderWidth),
            borderColor: self.randomColorsForUser().map(color => color.borderColor),
            hoverBorderWidth: 3,
            hoverBorderColor: '#000',
          }]
        },
        options: {
          plugins: {
            tooltip: {
              callbacks: {
                label: function(context) {
                  return moment.utc(context.raw * 1000).format('HH:mm:ss');
              }
            }
          }
        }
      }
      })

    },
    randomColorsForUser() {
      let colors = [];
      for (const user of this.getMembersWithAverageTime) {
        let color = this.randomColor(user.firstname + user.id.toString() + user.lastname);
        colors.push({
          backgroundColor: color,
          borderColor: '#777',
          borderWidth: 1
        });
      }
      return colors;
    },
    randomColor (string) {
      let colorHash = 0;
      string.split('').forEach(e => {
        colorHash = e.charCodeAt(0) + ((colorHash << 5) - colorHash)
      })
      let color = '#'
      for (let i = 0; i < 3; i++) {
        const value = (colorHash >> (i * 8)) & 0xff
        color += value.toString(16).padStart(2, '0')
      }
      return color
    }
  }
};

</script>

<style scoped>

</style>