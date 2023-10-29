<template>
    <section class="m-6">
        <header class="mb-6">
            <h2>{{title}}</h2>
        </header>
        <form @submit.prevent="" class="flex flex-col gap-5">
            <div>
                <label
                    for="pseudonyme"
                    class="block text-sm font-medium leading-6 text-gray-900"
                >
                    Pseudonyme
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
                        name="pseudonyme"
                        id="pseudonyme"
                        class="block w-full rounded-md border-0 py-1.5 pl-7 pr-20 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                        placeholder="pseudonyme"
                        v-model="username"
                    />
                </div>
            </div>
            <div>
                <label
                    for="mail"
                    class="block text-sm font-medium leading-6 text-gray-900"
                >
                    E-mail
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
                        name="mail"
                        id="mail"
                        class="block w-full rounded-md border-0 py-1.5 pl-7 pr-20 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                        placeholder="e-mail"
                        v-model="email"
                    />
                </div>
            </div>
            <div>
                <label
                    for="password"
                    class="block text-sm font-medium leading-6 text-gray-900"
                >
                    Mot de passe
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
                        type="password"
                        name="password"
                        id="password"
                        class="block w-full rounded-md border-0 py-1.5 pl-7 pr-20 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                        placeholder="Mot de passe"
                        v-model="password"
                    />
                </div>
            </div>
            <div class="flex gap-10 mt-5">
                <button
                    @click="deleteUser"
                    class="bg-[#E26D5A] text-white flex-1 rounded p-1"
                >
                    Supprimer
                </button>
                <button
                    @click="createUser"
                    class="bg-[#001F3F] text-white flex-1 rounded p-1"
                >
                    Créer
                </button>
            </div>
        </form>
    </section>
</template>

<script>

import {mapGetters} from "vuex";

export default {
    name: "UserComponent",

    data() {
        return {
            username: "",
            email: "",
            password: "",
          title: '',
        };
    },

    props: {
      id: Number,
    },

    computed: {
        ...mapGetters('user', ['userId']),
        getUserId () {
          return this.userId;
        }
    },

    async mounted () {
      if(this.getUserId){
        const user = await this.getUser();
        this.username = user.data.username;
        this.email = user.data.email;
        this.title = 'editer le profil'
        return;
      }
      this.title = 'créer un profil'
    },

    methods: {
        async createUser() {
            // TODO rajouter id user
            const url = 'http://localhost:4000/api/users' + '?username=' + this.username + '&email=' + this.email
            const body = {
                users: {
                    username: this.username,
                    email: this.email,
                    password: this.password
                }
            };
            const res = await fetch(url, {
                method: 'POST',
                body: JSON.stringify(body),
            }).then(res => res.json())
            console.log(res)
        },

        async deleteUser() {
            // TODO rajouter id user
            const url = 'http://localhost:4000/api/users/' + this.getUserId
            const res = await fetch(url, {
                method: 'DELETE',
            }).then(res => res.json())
            console.log(res)
        },

        async getUser() {
          const url = 'http://localhost:4000/api/users/' + this.getUserId
          return await fetch(url).then(res => res.json());
        },

        async updateUser() {

        },

        async authenticate() {

        }
    },
};
</script>

<style scoped></style>
