<template>
  <header class="mb-6">
    <h2 class="text-center">Equipe {{teamUser.name}}</h2>
  </header>
  <div v-if="showMembers">
    <Vue-good-table
        class="w-full"
        :columns="columns"
        :rows="users.data"
        :paginate="true"
        :lineNumbers="true"
        :search-options="{
              enabled: true,
              trigger: 'enter',
              placeholder: 'Rechercher',
            }"
        :sortable="true"
        :sort-options="{enabled: false}"
        theme="polar-bear"
    >
      <!-- En-tête du tableau -->
      <template v-slot:table-header="props">
        <div class="grid grid-cols-3 p-2">
          <div v-for="column in props.columns" :key="column.field" class="text-left">
            {{ column.label }}
          </div>
        </div>
      </template>

      <!-- Corps du tableau -->
      <template v-slot:table-row="props">
        <div class="grid grid-cols-3 p-2">
          <div v-if="props.column.field === 'actions'" class="text-left">
            <button @click="showStats(props.row.id)" class="bg-green-400 hover:bg-green-500 text-white py-1 px-3 rounded">
              Voir les statistiques
            </button>
            <button @click="deleteMember(props.row.id)" class="bg-red-400 hover:bg-red-500 text-white py-1 px-3 rounded">
              Supprimer de l'équipe
            </button>
          </div>
          <div v-else class="text-left">
            {{ props.formattedRow[props.column.field] }}
          </div>
        </div>
      </template>
    </Vue-good-table>
  </div>

  <div v-if="showStatsUser" class="grid grid-cols-1 gap-4">
    <div class="flex justify-center">
      Statistique de {{users.data.find(user => user.id === this.idUserSelected).firstname}} {{users.data.find(user => user.id === this.idUserSelected).lastname}}
    </div>
    <div class="flex justify-center">
      <input type="date" id="calendar" v-model="selectedDateStart">
    </div>
    <div>
      <StatsUserTeam :selectedDateStart="selectedDateStart" :id="idUserSelected"/>
    </div>
  </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import 'vue-good-table-next/dist/vue-good-table-next.css'
import { VueGoodTable } from 'vue-good-table-next';
import StatsUserTeam from "@/components/statsUserTeam.vue";
import moment from "moment";
export default {
  name: "EditTeam",
  components: {
    VueGoodTable,
    StatsUserTeam
  },

  data () {
    return {
      columns: [
        {
          label: "Nom",
          field: "lastname",
        },
        {
          label: "Prénom",
          field: "firstname",
        },
        {
          label: "Actions",
          field: "actions",
        },
      ],
      showMembers: true,
      showStatsUser: false,
      idUserSelected: null,
      selectedDateStart: moment().format("YYYY-MM-DD"),
    }
  },

  computed: {
  ...mapGetters("team", ["getTeam", "getAverageTime", "getMembersWithAverageTime"]),
    teamUser () {
      return this.getTeam;
    },
    users () {
      const users = this.teamUser.users.map(u => {
        return {
          id: u.id,
          firstname: u.firstname,
          lastname: u.lastname,
        }
      })
      return {data: users}
    }
  },

  methods: {
    ...mapActions("team", ["removeMember", "allHoursTeam"]),
    async showStats(id) {
      await this.allHoursTeam({id : this.getTeam.id});
      this.showMembers = !this.showMembers;
      this.showStatsUser = !this.showStatsUser;
      this.idUserSelected = id;
    },
    async deleteMember(id) {
      await this.removeMember(id);
    },
    hide() {
      this.showMembers = !this.showMembers;
      this.showStatsUser = !this.showStatsUser;
    }
  },
};
</script>

<style scoped>

</style>