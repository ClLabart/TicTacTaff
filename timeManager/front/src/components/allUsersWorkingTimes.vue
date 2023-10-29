<template>
  <div v-if="isLoading">
    Chargement...
  </div>
  <div v-else-if="error">
    {{ error }}
  </div>
  <div v-else>
    <div v-if="show" class="flex items-center justify-center h-screen">
      <!--    <div class="bg-white divide-y divide-gray-200 w-full">
            <div class="grid grid-cols-3 p-2 ">
              <div class="text-left">username</div>
              <div class="text-left">email</div>
              <div class="text-left">statistiques</div>
            </div>

            <div v-for="user in users.data" :key="user.id" class="grid grid-cols-3 p-2">
              <div class="text-left">{{ user.username }}</div>
              <div class="text-left">{{ user.email }}</div>
              <div class="text-left">
                <button @click="showStats(user.id)" class="bg-red-400 hover:bg-red-500 text-white py-1 px-3 rounded">
                  Voir les statistiques
                </button>
              </div>
            </div>
          </div>-->
      <Vue-good-table
          class="w-full  bg-white text-sm text-left text-gray-500"
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
        <template v-slot:table-row="props">
              <td v-if="props.column.field === 'statistiques'" class="m-4 px-6 py-4 font-medium text-gray-900 whitespace-nowrap">
                <button @click="showStats(props.row.id)" class="bg-red-400 hover:bg-red-500 text-white py-1 px-3 rounded">
                  Voir les statistiques
                </button>
              </td>
              <td v-else class="p-2 text-left ">
                {{ props.formattedRow[props.column.field] }}
              </td>

        </template>

        <template v-slot:table-header="props">
          <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 ">
            <tr v-for="column in props.columns" :key="column.field" class="px-6 py-3 bg-gray-200">
              <th>
                {{ column.label }}
              </th>
            </tr>

          </thead>

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
          label: 'Statistiques',
          field: 'statistiques',
          html: true
        }
      ]
    };
  },

  async created() {
    try {
      this.users = await this.allUsers();
      console.log(this.users)

      this.isLoading = false;
    } catch (e) {
      this.error = e;
      this.isLoading = false;
    }
  },

  methods : {
    async allUsers () {
      const url = "http://localhost:4000/api/users";
      try {
        return await fetch(url).then((res) => res.json());
      } catch (e) {
        console.log(e);
      }
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