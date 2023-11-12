<template>
  <div v-if="!statTeam" class="relative">
    <div v-if="user.id !== currentUser.id">
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
            class="flex justify-center"
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
            class="flex justify-center"
        >
          <option v-for="(month, indexMonth) in monthNames" :key="indexMonth">
            {{ month }}
          </option>
        </select>
        <bar-chart :chart="chartDataForMonth"  />
      </div>
      <div class="flex-1 p-2">
        <select
            v-model="selectedWeek"
            @change="getWorkingWeekTimes()"
            class="flex justify-center"
        >
          <option v-for="(week, indexWeek) in allWeeks" :key="indexWeek">
            {{ week }}
          </option>
        </select>
        <bar-chart :chart="chartDataForWeek"  />
      </div>
    </div>
  </div>

  <div v-else class="relative flex justify-around">
    <div v-if="showDay" class="h-72">
      <bar-chart :style="'h-full'" :chart="chartDataForDay" />
    </div>
    <div v-if="showWeek" class="h-72">
      <bar-chart :style="'h-full'" :chart="chartDataForWeek" />
    </div>
  </div>

</template>

<script>
import BarChart from "@/components/graphs/barChart.vue";
import moment from 'moment'
import 'moment/locale/fr'
import {mapGetters} from "vuex";

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
      hoursDay: 0,
      allHoursOfMonth: [],
      allHoursOfWeek: [],
      allHoursOfDay: [],
      loading: false,
      error: null,
      selectedWeek: moment().week(),
    }
  },

  props: {
    user: {
      type: Object,
      required: true
    },
    statTeam: {
      type: Boolean,
      default: false
    },
    selectedDateStart: {
      type: String,
      default: moment().format('YYYY-MM-DD')
    },
    weekSelected: {
      type: Number,
      default: moment().week()
    },
    showDay: {
      type: Boolean,
      default: false
    },
    showWeek: {
      type: Boolean,
      default: false
    },
  },

  computed : {
    ...mapGetters('component', ['getComponent']),
    ...mapGetters('user', ['currentUser']),
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
        let startOfWeek = currentDate.clone().startOf('isoWeek');
        let endOfWeek = currentDate.clone().endOf('isoWeek');
        const weekNumber = currentDate.isoWeek();
        if (startOfWeek.month() !== monthIndex) {
          startOfWeek = currentDate;
        }
        if (endOfWeek.month() !== monthIndex) {
          endOfWeek = currentDate.clone().endOf('month');
        }
        let week = {
              label: `Semaine ${weekNumber} - du ${startOfWeek.date()} au ${endOfWeek.date()} ${this.monthNames[monthIndex]}`,
              start: startOfWeek.toDate(),
              end: endOfWeek.toDate()
            }
        weeks.push(week);
        currentDate.add(1, 'week');
      }
      return weeks;
    },
    getWeekDaysByWeekNumber() {
      const startOfWeek = moment().isoWeek(this.selectedWeek).startOf('isoWeek');
      const days = [];
      for (let i = 0; i < 7; i++) {
        let day = {
          label: startOfWeek.clone().add(i, 'days').format('dddd DD/MM'),
          start: startOfWeek.clone().add(i, 'days').startOf('day').toDate(),
          end: startOfWeek.clone().add(i, 'days').endOf('day').toDate()
        }
        days.push(day);
      }
      return days;
    },
    monthNames() {
      return ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    },
    chartDataForYear() {
      return this.chart('Heures travaillées en ' + this.selectedYear + ' : ' + this.yearsHours + 'h', this.monthNames, this.allHoursOfMonth)
    },
    chartDataForMonth() {
      return this.chart('Heures travaillées en ' + this.selectedMonth + ' : ' + this.monthsHours + 'h', this.weeksInSelectedMonth.map(week => week.label), this.allHoursOfWeek);
    },
    chartDataForWeek() {
      return this.chart('Heures travaillées durant la semaine ' + this.selectedWeek + ' : ' + this.weeksHours + 'h', this.getWeekDaysByWeekNumber.map(day => day.label), this.allHoursOfDay)
    },
    chartDataForDay() {
      return this.chart('Heures travaillées le ' + this.selectedDateStart + ' : ' + this.hoursDay + 'h', [''], [this.hoursDay])
    },
    component () {
      return this.getComponent;
    },
    allWeeks () {
      const weeks = [];
      for (let i = 1; i <= 52; i++) {
        weeks.push(i);
      }
      return weeks;
    }
  },

  watch: {
    'component.show':
      function (value) {
        if(!value) {
          this.hide();
        }
      },
    'selectedDateStart': {
      handler: async function (value) {
        await this.handleDateChange(value);
      },
      deep: true,
      immediate: true
    },
    'weekSelected': {
      handler: async function (value) {
        this.selectedWeek = value;
        this.selectedMonth = this.monthNames[moment().isoWeek(value).month()];
        await this.getWorkingWeekTimes();
      },
      immediate: true,
      deep: true,
    }
  },

  async mounted () {
    if(!this.statTeam) {
      await this.getWorkingYearTimes()
      await this.getWorkingMonthTimes()
      await this.getWorkingWeekTimes()
    }
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
      const startMoment = moment(data.start);
      const endMoment = moment(data.end);
      const duration = moment.duration(endMoment.diff(startMoment));
      return parseFloat(duration.asHours().toFixed(2));
    },
    async calculateHoursForPeriod(start, end) {
      const allTimes = await this.getWorkingTimes(start, end);
      return allTimes.reduce((sum, time) => sum + this.estimationHours(time), 0);
    },
    async getWorkingYearTimes() {
      this.dataLoaded = false;
      const start = moment().year(this.selectedYear).startOf('year');
      const end = moment().year(this.selectedYear).endOf('year');
      this.yearsHours = await this.calculateHoursForPeriod(start.toDate(), end.toDate());

      const promises = [];
      for (let i = 0; i < 12; i++) {
        const startMonth = moment().year(this.selectedYear).month(i).startOf('month');
        const endMonth = moment().year(this.selectedYear).month(i).endOf('month');
        promises.push(this.calculateHoursForPeriod(startMonth.toDate(), endMonth.toDate()));
      }
      this.allHoursOfMonth = await Promise.all(promises);
      this.dataLoaded = true;
    },
    async getWorkingMonthTimes() {
      this.dataLoaded = false;
      const monthIndex = this.monthNames.indexOf(this.selectedMonth);
      const start = moment().year(this.selectedYear).month(monthIndex).startOf('month');
      const end = moment().year(this.selectedYear).month(monthIndex).endOf('month');
      this.monthsHours = await this.calculateHoursForPeriod(start.toDate(), end.toDate());

      const promises = [];
      for (let week of this.weeksInSelectedMonth) {
        const startWeek = moment(week.start);
        const endWeek = moment(week.end);
        promises.push(this.calculateHoursForPeriod(startWeek, endWeek));
      }
      this.allHoursOfWeek = await Promise.all(promises);
      this.dataLoaded = true;
    },
    async getWorkingWeekTimes() {
      this.dataLoaded = false;
      const monthIndex = this.monthNames.indexOf(this.selectedMonth);
      const firstDayOfMonth = moment([this.selectedYear, monthIndex]);
      const startOfWeek = firstDayOfMonth.clone().add(this.selectedWeek - 1, 'weeks').startOf('isoWeek');
      const endOfWeek = startOfWeek.clone().endOf('isoWeek');
      this.weeksHours = await this.calculateHoursForPeriod(startOfWeek.toDate(), endOfWeek.toDate());

      const promises = [];
      for (let day of this.getWeekDaysByWeekNumber) {
        const startDay = moment(day.start);
        const endDay = moment(day.end);
        promises.push(this.calculateHoursForPeriod(startDay, endDay));
      }

      this.allHoursOfDay = await Promise.all(promises);
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
    },
    async handleDateChange(value) {
      const start = moment(value).startOf('day');
      const end = moment(value).endOf('day');
      this.hoursDay = await this.calculateHoursForPeriod(start, end);
    }
  },
}

</script>

<style scoped>

</style>