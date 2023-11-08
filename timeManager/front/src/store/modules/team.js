const state = {
    team: null,
    teams: []
}

const getters = {
    getTeam: state => state.team,
    getTeams: state => state.teams
}

const mutations = {
    SET_TEAM (state, team) {
        state.team = team
    },
    SET_TEAMS (state, teams) {
        state.teams = teams
    },
    SET_MEMBER (state, members) {
        state.team.users = members
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
            console.log(commit('SET_TEAM', team))
        } catch (error) {
            console.log(error)
        }
    },
    async get ({commit}, id) {
        try {
            const url = `http://localhost:4000/api/teams/${id}`
            const response = await fetch(url)
            const team = await response.json()
            commit('SET_TEAM', team.data)
        } catch (error) {
            console.log(error)
        }
    },
    async getAll ({commit}) {
        try {
            const url = 'http://localhost:4000/api/teams'
            const response = await fetch(url)
            const teams = await response.json()
            commit('SET_TEAMS', teams.data)
        } catch (error) {
            console.log(error)
        }
    },
    async update ({commit}, team) {
        try {
            const url = `http://localhost:4000/api/teams/${team.id}`
            await fetch(url, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(team)
            })
            commit('SET_TEAM', team)
        } catch (error) {
            console.log(error)
        }
    },
    async delete ({commit}, id) {
        try {
            const url = `http://localhost:4000/api/teams/${id}`
            await fetch(url, {
                method: 'DELETE'
            })
            commit('SET_TEAM', null)
        } catch (error) {
            console.log(error)
        }
    },
    async addMember ({commit}, member) {
        try {
            const url = `http://localhost:4000/api/teams/${member.teamId}/members`
            await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(member)
            })
            commit('SET_TEAM', member)
        } catch (error) {
            console.log(error)
        }
    },
    async removeMember ({getters, commit}, id) {
        try {
            const url = `http://localhost:4000/api/users/` + id +'/team/' + '0'
            await fetch(url, {
                method: 'UPDATE',
            })
            const members = getters.getTeam.users.filter(user => user.id !== id)

            commit('SET_MEMBER', members)
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