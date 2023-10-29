
const state = {
    connexion: false,
    userId: null
}

const getters = {
    isConnected: state => state.connexion,
    userId: state => state.userId
}

const mutations = {
    SET_CONNECTION(state, isConnected) {
        state.connexion = isConnected
    },
    SET_USERID(state, userId) {
        state.userId = userId
    }
}

const actions = {
    async updateConnection({ commit }, isConnected) {
        commit('SET_CONNECTION', isConnected)
    },
    async findUserId({ commit }, userId) {
        commit('SET_USERID', userId)
    }
}

export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
}