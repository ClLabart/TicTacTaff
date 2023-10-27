<template>
  <div>
    <select v-model="selectedYear" @change="getWorkingYearTimes()">
      <option v-for="(year, indexYear) in generateYears" :key="indexYear">
        {{ year }}
      </option>
    </select>
    <select v-model="selectedMonth" @change="getWorkingMonthTimes()">
      <option v-for="(month, indexMonth) in chartDataYear.labels" :key="indexMonth">
        {{ month }}
      </option>
    </select>
  </div>

  <div v-if="dataLoaded">
    <bar-chart :chart-data="chartDataYear" :options="options" />
  </div>
</template>

<script>
import BarChart from "@/components/graphs/barChart.vue";
import moment from 'moment'

export default {
  name: 'WorkingTimes',
  components: {
    BarChart
  },

  data() {
    return {
      chartDataForYear: {
        labels: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet',
          'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
        datasets: [
          {
            label: "Data One",
            backgroundColor: "#f87979",
            data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
          }
        ]
      },
      options : {
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
      selectedMonth: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'][new Date().getMonth()],
      dataLoaded: false
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
    },
    chartDataYear () {
      return this.chartDataForYear
    }
  },

  async mounted () {
  await this.getWorkingYearTimes()
  this.dataLoaded = true
  },

  methods: {
    formatDateToSQL(date) {
      return moment(date).format('YYYY-MM-DDTHH:mm:ss');
    },
    async getWorkingTimes (start, end) {
      start = this.formatDateToSQL(start)
      end = this.formatDateToSQL(end)
      const url = 'http://localhost:4000/api/workingtimes/3?' + 'start=' + start + '&end=' + end
      return await fetch(url).then(res => res.json())
    },
    async getWorkingYearTimes () {
      const start = new Date(this.selectedYear, 0, 1)
      const end = new Date(this.selectedYear, 11, 31)
      const allTimes = await this.getWorkingTimes(start, end)
      let hoursForYear = 0
      let allHoursOfMonth = []
      for (const element of allTimes.data) {
        hoursForYear += this.estimationHours(element)
      }
      for (let i = 0; i < this.chartDataYear.datasets[0].data.length; i++) {
        const startMonth = new Date(this.selectedYear, i, 1)
        const endMonth = new Date(this.selectedYear, i + 1, 0)
        allHoursOfMonth.push(await this.estimationHoursInMonth(startMonth, endMonth))
      }
      this.chartDataForYear.datasets[0].data = allHoursOfMonth
    },
    async getWorkingMonthTimes () {
    },
    async estimationHoursInMonth (start, end) {
      const allTimes  = await this.getWorkingTimes(start, end)
      let hoursForMonth = 0
      for (const element of allTimes.data) {
        hoursForMonth += this.estimationHours(element)
      }
      return hoursForMonth
    },
    estimationHours (data) {
      const startMoment = moment(data.start, 'YYYY-MM-DDTHH:mm:ssZ').valueOf()
      const endMoment = moment(data.end, 'YYYY-MM-DDTHH:mm:ssZ').valueOf()
      return (endMoment - startMoment) / 1000 / 60 / 60
    }
  },

}

</script>

<style scoped>

</style>