
const state = {
    connexion: false,
    userSelected: null,
    currentUser: null
}

const getters = {
    isConnected: state => state.connexion,
    userSelected: state => state.userSelected,
    currentUser: state => state.currentUser
}

const mutations = {
    SET_CONNECTION(state, isConnected) {
        state.connexion = isConnected
    },
    SET_USER_SELECTED(state, user) {
        state.userSelected = user
    },
    SET_CURRENT_USER(state, user) {
        state.currentUser = user
    }
}

const actions = {
    updateConnection({ commit }, isConnected) {
        commit('SET_CONNECTION', isConnected)
    },
    updateCurrentUser({ commit }, user) {
        commit('SET_CURRENT_USER', user)
        commit('SET_USER_SELECTED', user)
    },
    async create ({ commit }, user) {
        try {
            const url = 'http://localhost:4000/api/users'
            await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
            console.log('User created', commit('SET_USER_SELECTED', user))
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
            const res = await fetch(url, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
            commit('SET_USER_SELECTED', res)
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