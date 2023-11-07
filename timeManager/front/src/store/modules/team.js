const state = {
    team: null,
    teams: []
}

const getters = {
    getTeam: state => state.team,
    getTeams: state => state.teams
}

const mutations = {
    SET_TEAM_SELECTED (state, team) {
        state.team = team
    },
    SET_TEAMS (state, teams) {
        state.teams = teams
    }
}

const actions = {
    async createTeam ({ commit }, team) {
        try {
            const url = 'http://localhost:4000/api/teams'
            await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(team)
            })
            console.log(commit('SET_TEAM_SELECTED', team))
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