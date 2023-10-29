<template>
  <div v-if="show" class="p-6 text-amber-50 grid grid-cols-3 gap-x-4 gap-y-4">
    <div v-for="user in users.data" :key="user.id" class="border-2 bg-white text-gray-700 border-gray-700 grid grid-cols-2">
      <card-user-working-times :user="user" class="m-2"/>
      <button @click="showStats(user.id)" class="text-white bg-red-400 hover:bg-red-300">Voir les statistiques</button>
    </div>
  </div>
  <div v-if="showWorkingTimes" class="p-6">
    <working-times :user="users.data.find(user => user.id === this.id)"/>
  </div>

</template>

<script>
import CardUserWorkingTimes from "@/components/cards/cardUserWorkingTimes.vue";
import WorkingTimes from "@/components/workingTimes.vue";

export default {
  name: "allUsersWorkingTimes",
  components: {WorkingTimes, CardUserWorkingTimes},
  data() {
    return {
      users: [],
      id: null,
      show: true,
      showWorkingTimes: false
    };
  },

  async mounted() {
      this.users = await this.allUsers();
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

    }
  }
}
</script>

<style scoped>

</style>