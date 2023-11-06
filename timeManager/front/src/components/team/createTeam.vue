<template>
  <section class="m-6">
    <header class="mb-6">
      <h2 class="text-center">Créer une équipe</h2>
    </header>
    <form @submit.prevent="" class="flex flex-col gap-5">
      <div>
        <label
            for="nom"
            class="block text-sm font-medium leading-6 text-gray-900"
        >
          Nom
        </label>
        <div class="relative mt-2 rounded-md shadow-sm">
          <div
              class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
          >
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth="{1.5}"
                stroke="currentColor"
                className="w-3 h-3"
                style="margin-left: -0.3em"
                height="1em"
            >
              <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"
              />
            </svg>
          </div>

          <input
              type="text"
              name="teamname"
              id="teamname"
              class="block w-full rounded-md border-0 py-1.5 pl-7 pr-20 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              placeholder="vérification du mot de passe"
              v-model="teamname"
          />
        </div>
      </div>

      <div class="flex gap-10 mt-5">
        <button
            @click="createTeam"
            class="bg-[#001F3F] text-white flex-1 rounded p-1"
        >
          Créer
        </button>
      </div>
    </form>
  </section>
</template>

<script>
import { mapActions } from "vuex";
export default {
  name: "CreateTeam",
  components: {

  },

  data() {
    return {
      teamname: "",
    };
  },

  methods: {
    ...mapActions("team", ["createTeam"]),
    async create() {
      await this.createTeam({
        team: {
          name: this.teamname,
        }
      });
    },
  },
};

</script>

<style scoped>

</style>
