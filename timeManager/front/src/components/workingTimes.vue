<template>
  <div>
    <select v-model="selectedYear" @change="getWorkingYearTimes()">
      <option v-for="(year, indexYear) in generateYears" :key="indexYear">
        {{ year }}
      </option>
    </select>
    <select v-model="selectedMonth" @change="getWorkingMonthTimes()">
      <option v-for="(month, indexMonth) in chartData.labels" :key="indexMonth">
        {{ month }}
      </option>
    </select>
  </div>

  <div>
    <bar-chart :chart-data="chartData" :options="options" />
  </div>
</template>

<script>
import BarChart from "@/components/graphs/barChart.vue";

export default {
  name: 'WorkingTimes',
  components: {
    BarChart
  },

  data() {
    return {
      chartData: {
        labels: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet',
          'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
        datasets: [
          {
            label: "Data One",
            backgroundColor: "#f87979",
            data: [40, 39, 10, 40, 39, 80, 40, 10, 23, 34, 45, 67]
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales : {
          y : {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Heures'
            }
          }
        }
      },
      selectedYear: new Date().getFullYear(),
      selectedMonth: new Date().getMonth(),
    }
  },

  computed : {
    generateYears () {
      const years = []
      const currentYear = new Date().getFullYear()
      for (let i = 0; i < 10; i++) {
        years.push(currentYear - i)
      }
      return years
    }
  },

  methods: {
    formatDateToSQL(date) {
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}:${String(date.getSeconds()).padStart(2, '0')}`;
    },
    async getWorkingTimes (start, end) {
      start = this.formatDateToSQL(start)
      end = this.formatDateToSQL(end)
      const url = 'http://localhost:4000/api/workingtimes/3?' + 'start=' + start + '&end=' + end
      return await fetch(url).then(res => res.json())
    },
    getWorkingYearTimes () {
      const start = new Date(this.selectedYear, 0, 1)
      const end = new Date(this.selectedYear, 11, 31)
      this.getWorkingTimes(start, end)
    },
    getWorkingMonthTimes () {
      const index = this.chartData.labels.indexOf(this.selectedMonth)
      const start = new Date(this.selectedYear, index, 1)
      const end = new Date(this.selectedYear, index + 1, 0)
      this.getWorkingTimes(start, end)
    }
  },

}

</script>

<style scoped>

</style>