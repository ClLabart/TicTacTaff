<template>
    <div class="inline-flex flex-row bg-white p-5 pl-0 rounded-3xl max-w-5xl opacity-0 transform translate-y-4 transition-all duration-500" ref="formContainer">
        <div class="w-1/12 flex items-end">
            <svg
                width="69"
                height="137"
                viewBox="0 0 69 137"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M4.88116 0.164551H-4.88116V43.3888L-21.0732 3.31196L-30.1246 6.96895L-13.513 48.084L-44.869 16.728L-51.7719 23.631L-21.7186 53.6842L-60.6654 36.668L-64.5739 45.6137L-23.3636 63.6188H-68.3354V73.3812H-23.3636L-64.5739 91.3862L-60.6654 100.332L-21.7187 83.3158L-51.7719 113.369L-44.869 120.272L-13.513 88.9159L-30.1246 130.031L-21.0732 133.688L-4.88116 93.6112V136.835H4.88116V93.6112L21.0732 133.688L30.1243 130.031L13.5133 88.9159L44.869 120.272L51.7716 113.369L21.7183 83.3158L60.6654 100.332L64.5735 91.3862L23.3639 73.3812H68.3354V63.6188H23.3632L64.5735 45.6137L60.6654 36.668L21.7183 53.6842L51.7716 23.6309L44.869 16.728L13.5133 48.0839L30.1243 6.96895L21.0732 3.31196L4.88116 43.3888V0.164551Z"
                    fill="#001F3F"
                />
            </svg>
        </div>
        <div class="w-5/12 px-10 py-20 justify-center">
            <div class="mb-5">
                <h1 class="titleFont text-7xl">Bienvenue</h1>
                <h5 class="text-gray-400 ml-5 text-xs">
                    Connectez-vous pour accéder à votre espace personnel
                </h5>
            </div>
            <!-- Div pour les inputs de connexion (email et mot de passe) -->
            <form @submit.prevent="connexion()">
                <div class="mb-4">
                    <div
                        class="flex items-center border-b-2 border-gray-200 py-2"
                    >
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="1.5"
                            stroke="currentColor"
                            class="w-6 h-6 mr-3"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75"
                            />
                        </svg>
                        <input
                            class="appearance-none border-none w-full text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm"
                            id="email"
                            type="email"
                            placeholder="Email"
                            v-model="email"
                        />
                    </div>
                </div>
                <div class="mb-4">
                    <div
                        class="flex items-center border-b-2 border-gray-200 py-2"
                    >
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="1.5"
                            stroke="currentColor"
                            class="w-6 h-6 mr-3"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M15.75 5.25a3 3 0 013 3m3 0a6 6 0 01-7.029 5.912c-.563-.097-1.159.026-1.563.43L10.5 17.25H8.25v2.25H6v2.25H2.25v-2.818c0-.597.237-1.17.659-1.591l6.499-6.499c.404-.404.527-1 .43-1.563A6 6 0 1121.75 8.25z"
                            />
                        </svg>
                        <input
                            class="appearance-none border-none w-full text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm"
                            id="password"
                            type="password"
                            placeholder="Mot de passe"
                            v-model="password"
                        />
                    </div>
                </div>

                <div class="flex items-center justify-center">
                    <button
                        class="bg-blue-950 hover:bg-yellow-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline w-full rounded-xl text-sm"
                        type="submit"
                    >
                        CONNEXION
                    </button>
                </div>
            </form>
        </div>
        <div class="w-6/12 relative">
            <img
                src="../../assets/imgs/Batman_Hand_Gun.jpg"
                alt="Batman tenant un pistolet"
                class="w-full h-full object-cover rounded-2xl"
            />
        </div>
    </div>
</template>

<script>
export default {
    name: "LoginComponent",
    data() {
        return {
            email: "",
            password: "",
            connected: false,
        };
    },

    mounted() {
        // Ajoutez la classe "appear" si l'élément "formContainer" existe
        const formContainer = this.$refs.formContainer;
        if (formContainer) {
            setTimeout(() => {
                formContainer.classList.add("appear");
            }, 100);
        }
    },

    watch: {
        connected() {
            this.$emit("connected", this.connected);
        },
    },

    methods: {
        async connexion() {
            const url =
                "http://localhost:4000/api/users?" +
                "username=" +
                this.password +
                "&email=" +
                this.email;
            const user = await fetch(url).then((res) => res.json());

            if (user.data.length > 0) {
                localStorage.setItem("user", JSON.stringify(user.data[0]));
                this.connected = true;
            }
        },
    },


};
</script>

<style scoped>
.divLoginComponent {
    max-width: 70vw;
    max-height: 60vh;
    /* width: 60vw;
    height: 60vh; */
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #f5f5f5;
    border-radius: 20px;
}

.imgContainer {
    margin: 5%;
    width: 60%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}

.horizontalAlign {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: row;
    padding: 10px;
}

#batmanRegisterImg {
    max-width: 100%;
    max-height: fit-content;
    display: block;
    border-radius: 20px;
}

.appear {
    opacity: 1;
    transform: translate(0, 0);
}
</style>
