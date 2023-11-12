<template>
  <div class="">
    <div v-if="showStatDay">
      <div class="my-2">
        <Stats
            :user="user"
            :stat-team="true"
            :show-day="true"
            :selected-date-start="selectedDateStart"
            @hide='hide'
        />
      </div>
      <h2 class="flex justify-center">
        Statistiques de {{user.firstname}} {{user.lastname}} comparé aux autres membres de l'équipe (jour {{selectedDateStart}})
      </h2>
      <div class="flex justify-around">
        <div>
          <PieChart :id="id" />
        </div>
        <div>
          <RadarChart :id="id" />
        </div>
      </div>
    </div>

    <div v-if="showStatWeek">
      <div class="my-2">
        <Stats
            :user="user"
            :stat-team="true"
            :show-week="true"
            :week-selected="weekSelected"
            @hide='hide'
        />
      </div>
      <h2 class="flex justify-center">
        Statistiques de {{user.firstname}} {{user.lastname}} comparé aux autres membres de l'équipe (semaine {{weekSelected}})
      </h2>
      <div class="flex justify-around">
        <div>
          <PieChart :id="id" />
        </div>
        <div>
          <RadarChart :id="id" />
        </div>
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

  data() {
    return {
      showStatDay: false,
      showStatWeek: false,
    }
  },

  props: {
    id: {
      type: Number,
      required: true
    },
    selectedDateStart: {
      type: String,
      default: moment().format("YYYY-MM-DD")
    },
    weekSelected: {
      type: Number,
      default: moment().week()
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
      handler: async function (newVal, oldVal) {
        if(newVal && newVal !== oldVal) {
          await this.handleChangeDate(newVal, 'day');
          this.showStatWeek = false;
          this.showStatDay = true;
        }
      },
      immediate: true,
      deep: true,
    },
    'weekSelected': {
      handler: async function (newVal, oldVal) {
        if(newVal && newVal !== oldVal) {
          await this.handleChangeDate(newVal, 'week');
          this.showStatDay = false;
          this.showStatWeek = true;
        }
      },
      deep: true,
    }
  },

  methods: {
    ...mapActions("team", ["allHoursTeam"]),
    hide () {
      this.$emit('hide', true);
    },
    async handleChangeDate(value, type) {
      if(type === 'week') {
        const start = moment().week(value).startOf(type).format("YYYY-MM-DDTHH:mm:ss");
        const end = moment().week(value).endOf(type).format("YYYY-MM-DDTHH:mm:ss");
        await this.allHoursTeam({id : this.getTeam.id, start, end});
      } else if (type === 'day') {
        const start = moment(value).startOf(type).format("YYYY-MM-DDTHH:mm:ss");
        const end = moment(value).endOf(type).format("YYYY-MM-DDTHH:mm:ss");
        await this.allHoursTeam({id : this.getTeam.id, start, end});
      }
    }
  }
}

</script>

<style scoped>

</style>