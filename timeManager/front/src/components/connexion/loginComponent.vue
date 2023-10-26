<template>
  <div>
    <form @submit.prevent="connexion()">
      <div>
        <label>
          <h4>
            username
          </h4>
        </label>
        <input type="text" v-model="username" />
      </div>
      <div>
        <label>
          <h4>
            Email
          </h4>
        </label>
        <input type="email" v-model="email" />
      </div>
      <div>
        <button type="submit">
          Send
        </button>
      </div>
    </form>
  </div>

</template>

<script>

import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'LoginComponent',
  data() {
    return {
      username: '',
      email: ''
    }
  },

  computed : {
    ...mapGetters('user', ['isConnected']),
    connect () {
      return this.isConnected
    }
  },

  methods: {
    ...mapActions('user', ['updateConnection']),
    async connexion() {
      if (!this.connect) {
        const url = 'http://localhost:4000/api/users?' + 'username=' + this.username + '&email=' + this.email
        const user = await fetch(url).then(res => res.json())

        await this.updateConnection(!!user)
      }
    }
  }
}

</script>

<style scoped>

</style>
