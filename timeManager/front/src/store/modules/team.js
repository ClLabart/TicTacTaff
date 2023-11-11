import moment from "moment";

const state = {
    team: null,
    teams: [],
    allHours: [],
    membersWithAverageTime: [],
    averageTime: null,
    totalHoursTeam: null
}

const getters = {
    getTeam: state => state.team,
    getTeams: state => state.teams,
    getAllHours: state => state.allHours,
    getMembersWithAverageTime: state => state.membersWithAverageTime,
    getAverageTime: state => state.averageTime,
    getTotalHoursTeam: state => state.totalHoursTeam
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
    },
    SET_HOURS (state, hours) {
        state.allHours = hours
    },
    SET_MEMBERS_WITH_AVERAGE_TIME (state, members) {
        state.membersWithAverageTime = members
    },
    SET_AVERAGETIME (state, averageTime) {
        state.averageTime = averageTime
    },
    SET_TOTAL_HOURS_TEAM (state, totalHoursTeam) {
        state.totalHoursTeam = totalHoursTeam
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
    },
    async allHoursTeam ({dispatch, commit, getters}, payload) {
        try {
            const url = (payload.start && payload.end) ? `http://localhost:4000/api/workingtimes/teams/${encodeURIComponent(payload.id)}?start=${encodeURIComponent(payload.start)}&end=${encodeURIComponent(payload.end)}` : `http://localhost:4000/api/workingtimes/teams/${encodeURIComponent(payload.id)}`
            const response = await fetch(url)
            const hours = await response.json()
            commit('SET_HOURS', hours.data)
            let userWithTimeCalculated = []
            const userFilteredByType = hours.data.filter(user => user.type === 'worked')
            for (const user of userFilteredByType) {
                user.time = await dispatch('averageTime', user.start, user.end)
                userWithTimeCalculated.push(user)
            }
            let userWithAllTime = []
            for(const user of getters.getTeam.users) {
                const deepCopyUser = JSON.parse(JSON.stringify(userWithTimeCalculated))
                let allTime = 0
                const userWithTime = deepCopyUser.filter(userTime => userTime.user === user.id)
                for(const time of userWithTime) {
                    allTime += time.time
                }
                user.allTime = allTime
                userWithAllTime.push(user)
            }
            commit('SET_TOTAL_HOURS_TEAM', userWithAllTime.reduce((acc, user) => acc + user.allTime, 0))
            const averageTimeTeam = userWithAllTime.reduce((acc, user) => acc + user.allTime, 0) / getters.getTeam.users.length
            console.log(averageTimeTeam)
            for (const user of userWithAllTime) {
                user.comparaisonTime = (user.allTime / averageTimeTeam)*100
            }
            commit('SET_MEMBERS_WITH_AVERAGE_TIME', userWithAllTime)
            commit('SET_AVERAGETIME', averageTimeTeam)

        } catch (error) {
            console.log(error)
        }
    },
    averageTime ({commit}, start, end) {
        const startTimestamp = moment(start).unix()
        const endTimestamp = moment(end).unix()
        console.log(commit('SET_AVERAGETIME', endTimestamp - startTimestamp))
        return endTimestamp - startTimestamp
    }
}

export default {
    namespaced: true,
    state,
    getters,
    mutations,
    actions
}