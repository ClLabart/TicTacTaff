
const state = {
    component: {
        type: '',
        show: false,
        childrenType: ''
    }
}

const getters = {
    getComponent: state => state.component,
}

const mutations = {
    SET_COMPONENT(state, component) {
        const { type, show, childrenType } = component
        state.component.type = type
        state.component.show = show
        state.component.childrenType = childrenType
    },
}

const actions = {
    async showComponent({ commit }, component) {
        console.log(component)
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