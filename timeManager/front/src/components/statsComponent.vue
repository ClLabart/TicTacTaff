<template>
  <div class="relative">
    <div>
      <button
          type="submit"
          class="text-white absolute left-2.5 top-2.5 bg-red-400 hover:bg-red-300 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
          @click="hide"
      >
        Retour
      </button>
    </div>
    <div
        v-if="dataLoaded"
        class="grid grid-cols-1 gap-4"
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
        <div v-if="loading">
          chargement en cours...
        </div>
        <div v-if="error">
          une erreur est survenue : {{ error }}
        </div>
        <bar-chart v-if="!loading && !error" :chart="chartDataForYear"  />
      </div>
      <div class="flex-1 p-2">
        <select
            v-model="selectedMonth"
            @change="getWorkingMonthTimes()"
        >
          <option v-for="(month, indexMonth) in monthNames" :key="indexMonth">
            {{ month }}
          </option>
        </select>
        <bar-chart :chart="chartDataForMonth"  />
      </div>
    </div>
  </div>

</template>

<script>
import BarChart from "@/components/graphs/barChart.vue";
import moment from 'moment'
import { mapGetters } from "vuex";

export default {
  name: 'StatsComponent',
  components: {
    BarChart
  },

  data() {
    return {
      selectedYear: new Date().getFullYear(),
      selectedMonth: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'][new Date().getMonth()],
      dataLoaded: false,
      yearsHours: 0,
      monthsHours: 0,
      weeksHours: 0,
      allHoursOfMonth: [],
      allHoursOfWeek: [],
      loading: false,
    }
  },

  props: {
    user: {
      type: Object,
      required: true
    }
  },

  computed : {
    ...mapGetters('component', ['getComponent']),
    generateYears () {
      const years = []
      const currentYear = new Date().getFullYear()
      for (let i = 0; i < 10; i++) {
        years.push(currentYear - i)
      }
      return years
    },
    weeksInSelectedMonth() {
      const weeks = [];
      const monthIndex = this.monthNames.indexOf(this.selectedMonth);
      let currentDate = moment().year(this.selectedYear).month(monthIndex).startOf('month');
      while (currentDate.month() === monthIndex) {
        let startOfWeek = currentDate.clone().startOf('week');
        let endOfWeek = currentDate.clone().endOf('week');
        const weekNumber = currentDate.week();

        if(startOfWeek.month() !== monthIndex) {
          startOfWeek = currentDate;
        }
        if(endOfWeek.month() !== monthIndex) {
          endOfWeek = currentDate.clone().endOf('month');
        }

        let weekStr = `Semaine ${weekNumber} - `;

        if(startOfWeek.month() !== monthIndex && endOfWeek.month() === monthIndex) {
          weeks.push(weekStr + `du ${startOfWeek.date()} ${this.monthNames[startOfWeek.month()]} au ${endOfWeek.date()} ${this.monthNames[monthIndex]}`);
        } else if (startOfWeek.month() === monthIndex && endOfWeek.month() !== monthIndex) {
          weeks.push(weekStr + `du ${startOfWeek.date()} ${this.monthNames[monthIndex]} au ${endOfWeek.date()} ${this.monthNames[endOfWeek.month()]}`);
        } else {
          weeks.push(weekStr + `du ${startOfWeek.date()} au ${endOfWeek.date()} ${this.monthNames[monthIndex]}`);
        }
        currentDate.add(1, 'week');
      }
      return weeks;
    },
    monthNames() {
      return ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    },
    chartDataForYear() {
      return this.chart('Heures travaillées en ' + this.selectedYear + ' : ' + this.yearsHours + 'h', this.monthNames, this.allHoursOfMonth)
    },
    chartDataForMonth() {
      return this.chart('Heures travaillées en ' + this.selectedMonth + ' : ' + this.monthsHours + 'h', this.weeksInSelectedMonth, this.allHoursOfWeek)
    },
    component () {
      return this.getComponent;
    }
  },

  watch: {
    'component.show':
      function (value) {
        if(!value) {
          this.hide();
        }
      }
  },


  async mounted () {
    await this.getWorkingYearTimes()
  },

  methods: {
    formatDateToSQL(date) {
      return moment(date).format('YYYY-MM-DDTHH:mm:ss');
    },
    async getWorkingTimes(start, end) {
      start = this.formatDateToSQL(start);
      end = this.formatDateToSQL(end);
      this.loading = true;
      const url = `http://localhost:4000/api/workingtimes/${this.user.id}?start=${start}&end=${end}`;

      try {
        const response = await fetch(url);
        const data = await response.json();
        this.loading = false;
        return data.data;
      } catch (e) {
        this.loading = false;
        this.error = e;
      }
    },
    estimationHours(data) {
      const startMoment = moment(data.start, 'YYYY-MM-DDTHH:mm:ssZ').valueOf();
      const endMoment = moment(data.end, 'YYYY-MM-DDTHH:mm:ssZ').valueOf();
      const result = (endMoment - startMoment) / 1000 / 60 / 60;
      return parseFloat(result.toFixed(2));
    },
    async calculateHoursForPeriod(start, end) {
      const allTimes = await this.getWorkingTimes(start, end);
      return allTimes.reduce((sum, time) => sum + this.estimationHours(time), 0);
    },
    async getWorkingYearTimes() {
      this.dataLoaded = false;
      const start = new Date(this.selectedYear, 0, 1);
      const end = new Date(this.selectedYear, 11, 31);
      this.yearsHours = await this.calculateHoursForPeriod(start, end);

      const promises = [];
      for (let i = 0; i < 11; i++) {
        const startMonth = new Date(this.selectedYear, i, 1);
        const endMonth = new Date(this.selectedYear, i + 1, 0);
        promises.push(this.calculateHoursForPeriod(startMonth, endMonth));
      }
      this.allHoursOfMonth = await Promise.all(promises);
      await this.getWorkingMonthTimes();
      this.dataLoaded = true;
    },
    async getWorkingMonthTimes() {
      this.dataLoaded = false;
      const monthIndex = this.monthNames.indexOf(this.selectedMonth);
      const start = new Date(this.selectedYear, monthIndex, 1);
      const end = new Date(this.selectedYear, monthIndex + 1, 0);
      this.monthsHours = await this.calculateHoursForPeriod(start, end);

      const promises = [];
      for (let i = 0; i < this.weeksInSelectedMonth.length; i++) {
        const startWeek = new Date(this.selectedYear, monthIndex, i * 7 + 1);
        const endWeek = new Date(this.selectedYear, monthIndex, (i + 1) * 7);
        promises.push(this.calculateHoursForPeriod(startWeek, endWeek));
      }
      this.allHoursOfWeek = await Promise.all(promises);
      this.dataLoaded = true;
    },
    chart (title, label, data) {
      return {
        data: {
          labels: label,
          datasets: [
            {
              label: title,
              backgroundColor: "#f87979",
              data: data
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
    hide () {
      this.$emit('hide', true);
    }
  },

}

</script>

<style scoped>

</style>