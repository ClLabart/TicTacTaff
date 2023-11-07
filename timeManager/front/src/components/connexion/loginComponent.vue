<template>
    <div class="divLoginComponent">
        <form @submit.prevent="connexion()">
            <div>
                <label>
                    <h4>username</h4>
                </label>
                <input type="text" v-model="username" />
            </div>
            <div>
                <label>
                    <h4>Email</h4>
                </label>
                <input type="email" v-model="email" />
            </div>
            <div>
                <button type="submit">Send</button>
            </div>
        </form>
    </div>
</template>

<script>
export default {
    name: "LoginComponent",
    data() {
        return {
            username: "",
            email: "",
            connected: false,
        };
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
                this.username +
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
    height: 100%;
}
</style>