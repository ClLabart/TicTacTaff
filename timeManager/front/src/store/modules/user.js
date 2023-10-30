
const state = {
    connexion: false,
    userSelected: null,
    currentUser: null
}

const getters = {
    isConnected: state => state.connexion,
    userSelected: state => state.userSelected
}

const mutations = {
    SET_CONNECTION(state, isConnected) {
        state.connexion = isConnected
    },
    SET_USER_SELECTED(state, user) {
        state.userSelected = user
        console.log(state.userSelected)
    }
}

const actions = {
    updateConnection({ commit }, isConnected) {
        commit('SET_CONNECTION', isConnected)
    },
    async create (user) {
        try {
            const url = 'http://localhost:4000/api/users'
            await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
        } catch (error) {
            console.log(error)
        }
    },
    async getUser ({ commit } , id) {
        try {
            const url = 'http://localhost:4000/api/users/' + id
            const response = await fetch(url, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                },
            })
            const data = await response.json()
            commit('SET_USER_SELECTED', data)
        } catch (error) {
            console.log(error)
        }
    },
    async update ({ commit }, {id, user}) {
        try {
            const url = 'http://localhost:4000/api/users/' + id
            await fetch(url, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
            commit('SET_USER_SELECTED', user)
        } catch (error) {
            console.log(error)
        }
    },
    refreshUser({ commit }) {
        commit('SET_USER_SELECTED', null)
    },
    async delete ({ actions }, id) {
        try {
            const url = 'http://localhost:4000/api/users/' + id
            await fetch(url, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                },
            })
            actions.refreshUser()
        } catch (error) {
            console.log(error)
        }
    }
}

export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
}