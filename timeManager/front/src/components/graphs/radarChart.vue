<template>
  <div class="">
    <canvas ref="chartCanvas" class="bg-white"></canvas>
  </div>
</template>

<script>
import { Chart, registerables } from 'chart.js';
import {mapGetters} from "vuex";

Chart.register(...registerables);

export default {
  name: 'RadarChart',

  computed: {
    ...mapGetters("team", ["getTeam", "getAverageTime", "getMembersWithAverageTime"]),
    labels () {
      return this.getMembersWithAverageTime.map(member => 'Temps moyen de : ' + member.firstname + ' ' + member.lastname)
    },
    userAverageTime () {
      return this.getMembersWithAverageTime.map(member => member.comparaisonTime)
    },
    averageTime () {
      return this.getAverageTime
    },
  },

  mounted() {
    this.initializeChart();
    console.log(['temps total de l\'équipe', ...this.labels])
    console.log([this.getAverageTime, ...this.userAverageTime])
  },

  methods: {
    initializeChart () {
      new Chart(this.$refs.chartCanvas.getContext('2d'), {
        type: 'radar',
        data: {
          label: ['Temps moyen', ],
          datasets: [{
            label: ['Temps moyen', ...this.labels],
            data: [100, ...this.userAverageTime],
            backgroundColor: this.randomColor(this.getTeam.name + this.getTeam.id.toString()),
            borderWidth: 1,
            borderColor: '#777',
            hoverBorderWidth: 3,
            hoverBorderColor: '#000',
          }
          ]
        },
        options: {
          scales: {
            r: {
              angleLines: {
                display: false
              },
              suggestedMin: 0,
              suggestedMax: 100
            }
          }
        }
      }
      )
    },
    randomColorsForUser () {
      let colorUser = []
      for (const user of this.getMembersWithAverageTime) {
        user.color = this.randomColor(user.firstname + user.id.toString() + user.lastname )
        colorUser.push(user.color)
      }
      return colorUser
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
}

</script>

<style scoped>

</style>