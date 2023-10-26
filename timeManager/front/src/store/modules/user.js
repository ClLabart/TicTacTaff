
const state = {
    connexion: false
}

const getters = {
    isConnected: state => state.connexion
}

const mutations = {
    SET_CONNECTION(state, isConnected) {
        state.connexion = isConnected
    }
}

const actions = {
    async updateConnection({ commit }, isConnected) {
        commit('SET_CONNECTION', isConnected)
    }
}

export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
}