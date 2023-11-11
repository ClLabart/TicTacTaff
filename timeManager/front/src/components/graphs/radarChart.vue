<template>
  <div class="">
    <canvas ref="chartCanvas" class=""></canvas>
  </div>
</template>

<script>
import { Chart, registerables } from 'chart.js';
import {mapGetters} from "vuex";

Chart.register(...registerables);

export default {
  name: 'RadarChart',

  props: {
    id: {
      type: Number,
      required: true
    }
  },

  computed: {
    ...mapGetters("team", ["getTeam", "getAverageTime", "getTotalHoursTeam", "getMembersWithAverageTime"]),
    userName () {
      return this.getMembersWithAverageTime.find(member => member.id === this.id)
    },
    userAverageTime () {
      return this.getMembersWithAverageTime.find(member => member.id === this.id).comparaisonTime
    },
    averageTimeNormalized () {
      return this.getAverageTime / this.getTotalHoursTeam * 100
    },
  },

  mounted() {
    this.initializeChart();
  },

  methods: {
    initializeChart () {
      new Chart(this.$refs.chartCanvas.getContext('2d'), {
        type: 'radar',
        data: {
          labels: [
            'Temps total de l\'équipe',
            'Temps moyen d\'un employé',
            'Temps de ' + this.userName.firstname + ' ' + this.userName.lastname
          ],
          datasets: [{
            label: 'Données en %',
            data: [100, this.averageTimeNormalized, this.userAverageTime],
            borderWidth: 1,
            borderColor: '#777',
            hoverBorderWidth: 3,
            hoverBorderColor: '#000',
          }]
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
      });
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