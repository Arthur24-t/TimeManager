<template>
    <div class="card teams-card">
        <div class="card-header">
            <div class="teams">
                <slot name="header">My Teams</slot>
            </div>
        </div>
        <div class="card-body teams-body">
            <div v-for="(team, team_index) in teams">
                <div @click="toggleCollapse(team.name)" class="team-collapse">
                    <h1 class="team-name">Team {{ team.name }}</h1>
                    <svg :class="{ 'rotation': isCollapsed[team.name] }" xmlns="http://www.w3.org/2000/svg" width="20"
                        height="20" viewBox="0 0 32 20" fill="none">
                        <path
                            d="M14.7564 18.9047L0.515134 4.6633C-0.171711 3.97646 -0.171711 2.86291 0.515134 2.17613L2.17615 0.515117C2.86182 -0.170556 3.9731 -0.171875 4.66039 0.512185L16 11.7987L27.3396 0.512185C28.0269 -0.171875 29.1382 -0.170556 29.8238 0.515117L31.4849 2.17613C32.1717 2.86298 32.1717 3.97653 31.4849 4.6633L17.2437 18.9047C16.5568 19.5914 15.4433 19.5914 14.7564 18.9047Z"
                            fill="#A4AABD" />
                    </svg>
                </div>
                <table v-if="isCollapsed[team.name]">
                    <thead>
                        <tr>
                            <th>
                                <h3>Username</h3>
                            </th>
                            <th>
                                <h3>Email</h3>
                            </th>
                            <th>
                                <h3>Function</h3>
                            </th>
                            <th v-if="myRole === 'admin'">
                                <h3>Actions</h3>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="myRole === 'admin'">
                            <td>
                                <Dropdown filter v-model="team.newUser" optionLabel="username" :options="users"
                                    placeholder="Select a Username" class="w-full md:w-20rem" />
                            </td>
                            <td>
                                <Dropdown filter optionLabel="email" v-model="team.newUser" :options="users"
                                    placeholder="Select an Email" class="w-full md:w-20rem" />
                            </td>
                            <td><span class="items role">{{ team.newUser.role }}</span></td>
                            <td><button @click="addToTeam(team_index)" class="btn btn-create">Add User</button></td>
                        </tr>
                        <tr v-for="(user, user_index) in team.users">
                            <td><span class="items">{{ user.username }}</span></td>
                            <td><span class="items email">{{ user.email }}</span></td>
                            <td><span class="items role">{{ user.role }}</span></td>
                            <td class="actions" v-if="myRole === 'admin'">
                                <div class="action" @click="showUserChart(user.id)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="29" height="22" viewBox="0 0 29 22"
                                        fill="none">
                                        <path
                                            d="M26.2812 0H2.71875C1.21721 0 0 1.03901 0 2.32073V19.3394C0 20.6211 1.21721 21.6602 2.71875 21.6602H26.2812C27.7828 21.6602 29 20.6211 29 19.3394V2.32073C29 1.03901 27.7828 0 26.2812 0ZM12.6875 18.5658H3.625V6.18862H12.6875V18.5658ZM25.375 18.5658H16.3125V6.18862H25.375V18.5658Z"
                                            fill="black" />
                                    </svg>
                                </div>
                                <div class="action" @click="deleteUserInTeam(team_index, user_index)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="26" viewBox="0 0 30 26"
                                        fill="none">
                                        <rect width="29.8096" height="25.1074" fill="white" />
                                        <path
                                            d="M22.7764 3.45235H19.1899V2.78543C19.1899 1.60852 18.072 0.666992 16.6747 0.666992H13.0883C11.6909 0.666992 10.5731 1.60852 10.5731 2.78543V3.45235H6.98661C5.63586 3.45235 4.51801 4.39388 4.51801 5.53156V6.70847C4.51801 7.57153 5.12351 8.27768 6.00848 8.59152L6.75372 21.5768C6.84688 23.1852 8.43051 24.4406 10.3402 24.4406H19.3762C21.2859 24.4406 22.8695 23.1852 22.9627 21.5768L23.7545 8.55229C24.6395 8.23845 25.245 7.49307 25.245 6.66923V5.49232C25.245 4.39387 24.1271 3.45235 22.7764 3.45235ZM12.7156 2.78543C12.7156 2.58928 12.9019 2.43236 13.1348 2.43236H16.7213C16.9542 2.43236 17.1405 2.58928 17.1405 2.78543V3.45235H12.7622V2.78543H12.7156ZM6.66057 5.53156C6.66057 5.37463 6.8003 5.21771 7.03319 5.21771H22.7764C22.9627 5.21771 23.149 5.3354 23.149 5.53156V6.70847C23.149 6.86539 23.0093 7.02231 22.7764 7.02231H7.03319C6.84688 7.02231 6.66057 6.90462 6.66057 6.70847V5.53156ZM19.4228 22.6752H10.3868C9.59495 22.6752 8.94286 22.1652 8.89629 21.4591L8.19763 8.74844H21.6585L20.9599 21.4591C20.8667 22.126 20.2146 22.6752 19.4228 22.6752Z"
                                            fill="#64748B" />
                                        <path
                                            d="M14.9048 12.7109C14.3458 12.7109 13.8335 13.1032 13.8335 13.6132V18.5955C13.8335 19.0663 14.2993 19.4978 14.9048 19.4978C15.4637 19.4978 15.9761 19.1055 15.9761 18.5955V13.6132C15.9761 13.1032 15.4637 12.7109 14.9048 12.7109Z"
                                            fill="#64748B" />
                                        <path
                                            d="M18.631 13.4952C18.0255 13.4559 17.5597 13.809 17.5131 14.319L17.2337 17.7713C17.1871 18.242 17.6063 18.6736 18.2118 18.7128C18.2584 18.7128 18.2584 18.7128 18.3049 18.7128C18.8639 18.7128 19.3296 18.3597 19.3296 17.889L19.6091 14.4367C19.6091 13.9267 19.1899 13.5344 18.631 13.4952Z"
                                            fill="#64748B" />
                                        <path
                                            d="M11.132 13.4952C10.5731 13.5344 10.1073 13.9659 10.1539 14.4367L10.4799 17.889C10.5265 18.3597 10.9923 18.7128 11.5046 18.7128C11.5512 18.7128 11.5512 18.7128 11.5978 18.7128C12.1567 18.6736 12.6225 18.242 12.5759 17.7713L12.2499 14.319C12.2499 13.809 11.7375 13.4559 11.132 13.4952Z"
                                            fill="#64748B" />
                                    </svg>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>

<script>
import { DELETE, GET, POST } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';
import MultiSelect from 'primevue/multiselect';
import Dropdown from 'primevue/dropdown';
import { createToast } from 'mosha-vue-toastify';

export default {
    name: 'Teams',
    components: {
        MultiSelect,
        Dropdown
    },
    data() {
        return {
            userID: localStorage.getItem('user'),
            token: localStorage.getItem('token'),
            isCollapsed: {},
            teams: [],
            users: [],
            myRole: ''
        }
    },
    methods: {
        toggleCollapse(team) {
            this.isCollapsed[team] = !this.isCollapsed[team];
        },
        showUserChart(user_id) {
            this.$router.replace(`/usercharts/${user_id}`)
        },
        getAllUser() {
            GET(ENDPOINTS.GET_ALL_USER, this.token)
                .then((response) => {
                    this.users = response.data.data
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        getMyTeams() {
            GET(ENDPOINTS.GET_USER_BY_ID + this.userID, this.token)
                .then((response) => {
                    this.teams = response.data.data.teams
                    this.myRole = response.data.data.role
                    for (let i = 0; i < this.teams.length; i++) {
                        this.teams[i]['newUser'] = {
                            username: '',
                            email: '',
                            role: ''
                        }
                        this.isCollapsed[this.teams[i].name] = false
                        GET(ENDPOINTS.GET_ALL_USER_IN_TEAM + this.teams[i].id, this.token)
                            .then((response) => {
                                this.teams[i]['users'] = response.data.data
                            })
                            .catch((error) => {
                                console.dir(error)
                            })

                    }
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        addToTeam(team_index) {
            POST(ENDPOINTS.ADD_USER_TO_TEAM + this.teams[team_index].newUser.id + '/teams/' + this.teams[team_index].id, null, this.token)
                .then((response) => {
                    this.teams[team_index]['newUser'] = {
                            username: '',
                            email: '',
                            role: ''
                        }
                    createToast({ title: 'Add Success', description: `You have sucessfully added the ${this.teams[team_index].newUser.username} profile to the ${this.teams[team_index].name} team` }, { type: 'success', position: 'bottom-right' });
                    GET(ENDPOINTS.GET_ALL_USER_IN_TEAM + this.teams[team_index].id, this.token)
                        .then((response) => {
                            this.teams[team_index]['users'] = response.data.data
                        })
                        .catch((error) => {
                            console.dir(error)
                        })
                })
                .catch((error) => {
                    createToast({ title: 'Add Failed', description: 'Please try again' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        },
        deleteUserInTeam(team_index, user_index) {
            DELETE(ENDPOINTS.DELETE_USER_TO_TEAM + this.teams[team_index]['users'][user_index].id + '/teams/' + this.teams[team_index].id, this.token)
                .then((response) => {
                    createToast({ title: 'Deletion Success', description: `You have sucessfully deleted the ${this.teams[team_index]['users'][user_index].username} profile from the ${this.teams[team_index].name} team` }, { type: 'success', position: 'bottom-right' });
                    GET(ENDPOINTS.GET_ALL_USER_IN_TEAM + this.teams[team_index].id, this.token)
                        .then((response) => {
                            this.teams[team_index]['users'] = response.data.data
                        })
                        .catch((error) => {
                            console.dir(error)
                        })
                })
                .catch((error) => {
                    createToast({ title: 'Deletion Failed', description: 'Please try again' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        },
    },
    created() {
        this.getMyTeams();
        this.getAllUser()
    },
}
</script>

<style scoped>
.teams-card {
    overflow-y: scroll;
    box-shadow: 0px 8px 13px -3px rgba(0, 0, 0, 0.07);
    border-radius: 4px;
    height: 90vh;
}

.teams-body {
    padding: 3rem;
}

.teams-card::-webkit-scrollbar {
    width: 3px;
}

/* Track */
.teams-card::-webkit-scrollbar-track {
    box-shadow: inset 0 0 5px grey;
    border-radius: 10px;
}

/* Handle */
.teams-card::-webkit-scrollbar-thumb {
    background: grey;
    border-radius: 10px;
}

/* Handle on hover */
.teams-card::-webkit-scrollbar-thumb:hover {
    background: #b30000;
}

.teams {
    display: flex;
    justify-content: space-between;
    font-size: 1.2rem;
    font-weight: bold;
}

table {
    width: 100%;
    border: none;
    font-size: 16px;
}

thead {
    background-color: #F7F9FC;
    border: none;
}

td {
    text-align: center;
    vertical-align: middle;
}

tr {
    text-align: center;
    height: 80px;
}

.actions {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    padding-top: 10px;
    height: 80px;
}

.items {
    border: none;
    text-align: center;
    width: 50%;
    padding: 8px;
    border-radius: 30px;
    font-family: Karla;
    font-size: 16px;
}

.email {
    font-weight: bold;
    background: rgba(33, 150, 83, 0.08);
}

.action {
    cursor: pointer;
}

.action:hover {
    opacity: 0.5;
}

.team-collapse {
    display: flex;
    align-items: center;
    gap: 3rem;
}

.rotation {
    transform: rotate(-180deg);
    transition: transform 0.3s;
}

.role {
    font-weight: bold;
    text-transform: uppercase;
}

.btn {
    padding: 10px 20px;
    font-size: 18px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    color: white;
}

.btn-create {
    background-color: #00B28C;
}

.btn-create:hover {
    background-color: #007C62;
}
</style>