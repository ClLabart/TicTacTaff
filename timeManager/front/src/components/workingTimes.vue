<template>
  <div
      v-if="dataLoaded"
      class="flex"
  >
    <div class="flex-1 p-2">
      <select
          v-model="selectedYear"
          @change="getWorkingYearTimes()"
      >
        <option v-for="(year, indexYear) in generateYears" :key="indexYear">
          {{ year }}
        </option>
      </select>
      <bar-chart :chart-data="chartDataYear" :options="optionsForYear" />
    </div>
    <div class="flex-1 p-2">
      <select
          v-model="selectedMonth"
          @change="getWorkingMonthTimes()"
      >
        <option v-for="(month, indexMonth) in chartDataYear.labels" :key="indexMonth">
          {{ month }}
        </option>
      </select>
      <bar-chart :chart-data="chartDataMonth" :options="optionsForMonth" />
    </div>
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
      chartDataForMonth: {
        labels: [],
        datasets: [
          {
            label: "Data One",
            backgroundColor: "#f87979",
            data: []
          }
        ]
      },
      selectedYear: new Date().getFullYear(),
      selectedMonth: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'][new Date().getMonth()],
      dataLoaded: false,
      yearsHours: 0,
      monthsHours: 0,
      weeksHours: 0
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
    },
    chartDataMonth () {
      return this.chartDataForMonth
    },
    weeksInSelectedMonth() {
      const weeks = [];
      const monthIndex = this.monthNames.indexOf(this.selectedMonth);
      let currentDate = moment().year(this.selectedYear).month(monthIndex).startOf('month');
      while (currentDate.month() === monthIndex) {
        let startOfWeek = currentDate.clone().startOf('week');
        let endOfWeek = currentDate.clone().endOf('week');
        if(startOfWeek.month() !== monthIndex) {
          startOfWeek = currentDate;
        }
        if(endOfWeek.month() !== monthIndex) {
          endOfWeek = currentDate.clone().endOf('month');
        }
        if(startOfWeek.month() !== monthIndex && endOfWeek.month() === monthIndex) {
          weeks.push(`Semaine du ${startOfWeek.date()} ${this.monthNames[startOfWeek.month()]} au ${endOfWeek.date()} ${this.monthNames[monthIndex]}`);
        } else if (startOfWeek.month() === monthIndex && endOfWeek.month() !== monthIndex) {
          weeks.push(`Semaine du ${startOfWeek.date()} ${this.monthNames[monthIndex]} au ${endOfWeek.date()} ${this.monthNames[endOfWeek.month()]}`);
        } else {
          weeks.push(`Semaine du ${startOfWeek.date()} au ${endOfWeek.date()} ${this.monthNames[monthIndex]}`);
        }
        currentDate.add(1, 'week');
      }
      return weeks;
    },
    monthNames() {
      return ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    },
    optionsForYear() {
      return this.options('Heures travaillées en ' + this.selectedYear + ' : ' + this.yearsHours + 'h')
    },
    optionsForMonth() {
      return this.options('Heures travaillées en ' + this.selectedMonth + ' : ' + this.monthsHours + 'h')
    }
  },

  watch: {
    selectedMonth: {
      handler() {
        this.chartDataForMonth.labels = this.weeksInSelectedMonth;
      },
      immediate: true
    }
  },

  async mounted () {
    await this.getWorkingYearTimes()
    await this.getWorkingMonthTimes()
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
      let allHoursOfMonth = []
      for (const element of allTimes.data) {
        this.yearsHours += this.estimationHours(element)
      }
      for (let i = 0; i < this.chartDataYear.datasets[0].data.length; i++) {
        const startMonth = new Date(this.selectedYear, i, 1)
        const endMonth = new Date(this.selectedYear, i + 1, 0)
        allHoursOfMonth.push(await this.estimationHoursInMonth(startMonth, endMonth))
      }
      this.chartDataForYear = {
        ...this.chartDataForYear,
        datasets: [
          {
            ...this.chartDataForYear.datasets[0],
            data: allHoursOfMonth
          }
        ]
      };
    },
    async getWorkingMonthTimes () {
      const start = new Date(this.selectedYear, this.monthNames.indexOf(this.selectedMonth), 1)
      const end = new Date(this.selectedYear, this.monthNames.indexOf(this.selectedMonth) + 1, 0)
      const allTimes = await this.getWorkingTimes(start, end)
      let allHoursOfWeek = []
      for (const element of allTimes.data) {
        this.monthsHours += this.estimationHours(element)
      }
      for (let i = 0; i < this.weeksInSelectedMonth.length; i++) {
        const startWeek = new Date(this.selectedYear, this.monthNames.indexOf(this.selectedMonth), i * 7 + 1)
        const endWeek = new Date(this.selectedYear, this.monthNames.indexOf(this.selectedMonth), (i + 1) * 7)
        allHoursOfWeek.push(await this.estimationHoursInWeek(startWeek, endWeek))
      }
      this.chartDataForMonth = {
        ...this.chartDataForMonth,
        datasets: [
          {
            ...this.chartDataForMonth.datasets[0],
            data: allHoursOfWeek
          }
        ]
      };
    },
    async estimationHoursInMonth (start, end) {
      const allTimes  = await this.getWorkingTimes(start, end)
      let hoursForMonth = 0
      for (const element of allTimes.data) {
        hoursForMonth += this.estimationHours(element)
      }
      return hoursForMonth
    },
    async estimationHoursInWeek (start, end) {
      const allTimes  = await this.getWorkingTimes(start, end)
      let hoursForWeek = 0
      for (const element of allTimes.data) {
        hoursForWeek += this.estimationHours(element)
      }
      return hoursForWeek
    },
    estimationHours (data) {
      const startMoment = moment(data.start, 'YYYY-MM-DDTHH:mm:ssZ').valueOf()
      const endMoment = moment(data.end, 'YYYY-MM-DDTHH:mm:ssZ').valueOf()
      return (endMoment - startMoment) / 1000 / 60 / 60
    },
    options (title) {
      return {
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
        },
        plugins: {
          title: {
            display: true,
            text: title
          }
        }
      }
    }
  },

}

</script>

<style scoped>

</style>