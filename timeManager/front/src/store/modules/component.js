
const state = {
    component: {
        type: '',
        show: false
    }
}

const getters = {
    getComponent: state => state.component,
}

const mutations = {
    SET_COMPONENT(state, component) {
        const { type, show } = component
        state.component.type = type
        state.component.show = show
    },

}

const actions = {
    async showComponent({ commit }, component) {
        commit('SET_COMPONENT', component)
    }
}

export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
}