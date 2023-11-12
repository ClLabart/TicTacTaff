<template>
  <div v-if="isLoading" class="flex items-center justify-center h-screen">
    Chargement...
  </div>
  <div v-else-if="error" class="flex items-center justify-center h-screen">
    {{ error }}
  </div>
  <div v-else>
    <div v-if="show" class="">
      <button @click="createProfile" class="bg-blue-400 hover:bg-blue-500 text-white py-1 px-3 rounded">
        Créer un utilisateur
      </button>
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
              <button @click="showStats(props.row.id)" class="bg-red-400 hover:bg-red-500 text-white py-1 px-3 rounded">
                Voir les statistiques
              </button>
              <button @click="editProfile(props.row.id)" class="bg-blue-400 hover:bg-blue-500 text-white py-1 px-3 rounded">
                editer le profil
              </button>
            </div>
            <div v-else class="text-left">
              {{ props.formattedRow[props.column.field] }}
            </div>
          </div>
        </template>
      </Vue-good-table>
    </div>
  </div>


  <div v-if="showWorkingTimes" class="p-6">
    <Stats
        :user="users.data.find(user => user.id === this.id)"
        @hide='hide'
        :stat-team="false"
    />
  </div>

</template>

<script>
import Stats from "@/components/stats.vue";
import 'vue-good-table-next/dist/vue-good-table-next.css'
import { VueGoodTable } from 'vue-good-table-next';
import { mapActions } from "vuex";
export default {
  name: "WorkingTimes",
  components: {
    Stats,
    VueGoodTable
  },

  data() {
    return {
      users: {data: []},
      id: null,
      show: true,
      showWorkingTimes: false,
      isLoading: true,
      error: null,
      columns: [
        {
          label: 'Username',
          field: 'username'
        },
        {
          label: 'Email',
          field: 'email'
        },
        {
          label: 'Actions',
          field: 'actions',
          html: true
        }
      ]
    };
  },

  async created() {
    try {
      this.users = await this.allUsers();
      this.isLoading = false;
    } catch (e) {
      this.error = e;
      this.isLoading = false;
    }
  },

  methods : {
    ...mapActions('component', ['showComponent']),
    ...mapActions('user', ['getUser']),
    async allUsers () {
      const url = "http://localhost:4000/api/users";
      try {
        return await fetch(url).then((res) => res.json());
      } catch (e) {
        console.log(e);
      }
    },
    async editProfile(userId) {
      await this.getUser(userId);
      this.showComponent({type: 'userComponent', show: true, childrenType: 'edit'});
    },
    showStats(id) {
      this.show = false;
      this.id = id;
      this.showWorkingTimes = true;
    },
    hide (value) {
      this.show = value;
      this.showWorkingTimes = !value;
    },
    createProfile() {
      this.showComponent({type: 'userComponent', show: true, childrenType: 'create'});
    }
  }
}
</script>

<style scoped>

</style>