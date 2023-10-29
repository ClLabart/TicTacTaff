<template>
  <div v-if="isLoading">
    Chargement...
  </div>
  <div v-else-if="error">
    {{ error }}
  </div>
  <div v-else>
    <div v-if="show" class="flex items-center justify-center h-screen">
      <Vue-good-table
          class="bg-white divide-y divide-gray-200 w-full"
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
              <button @click="editProfile('userComponent', props.row.id)" class="bg-blue-400 hover:bg-blue-500 text-white py-1 px-3 rounded">
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
    <working-times
        :user="users.data.find(user => user.id === this.id)"
        @hide='hide'
    />
  </div>

</template>

<script>
import WorkingTimes from "@/components/workingTimes.vue";
import { VueGoodTable } from 'vue-good-table-next';
import { mapActions } from "vuex";
export default {
  name: "allUsersWorkingTimes",
  components: {
    WorkingTimes,
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
    ...mapActions('user', ['findUserId']),
    async allUsers () {
      const url = "http://localhost:4000/api/users";
      try {
        return await fetch(url).then((res) => res.json());
      } catch (e) {
        console.log(e);
      }
    },
    editProfile(type, id) {
      this.findUserId(id);
      this.showComponent({type: type, show: true});
    },
    showStats(id) {
      this.show = false;
      this.id = id;
      this.showWorkingTimes = true;
    },
    hide (value) {
      this.show = value;
      this.showWorkingTimes = !value;
    }
  }
}
</script>

<style scoped>

</style>