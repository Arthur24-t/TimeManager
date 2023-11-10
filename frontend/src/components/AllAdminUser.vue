<template>
    <table>
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
                <th>
                    <h3>Teams</h3>
                </th>
                <th>
                    <h3>Actions</h3>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><input class="items" v-model="newUser.username" /></td>
                <td><input class="items email" v-model="newUser.email" /></td>
                <td>
                    <Dropdown v-model="newUser.role" :options="roleOption"
                                placeholder="Select a Role" class="w-full md:w-20rem" />
                </td>
                <td>
                    <MultiSelect v-model="newUser.teams" display="chip" :options="allTeams" optionLabel="name"
                        placeholder="Select Teams" :maxSelectedLabels="3" class="w-full md:w-20rem" />
                </td>
                <td>
                    <button @click="createUser" class="btn btn-create">Create</button>
                </td>
            </tr>
            <tr v-if="users.length != 0" v-for="user in users" :key="user.id">
                <admin-user :user="user" :teams="allTeams" @needrefresh="getUsers()" />
            </tr>
        </tbody>
    </table>
</template>

<script>
import { ENDPOINTS } from '../api/endpoints.js';
import { GET, POST } from '../api/axios.js';
import AdminUser from './AdminUser.vue';
import MultiSelect from 'primevue/multiselect';
import Dropdown from 'primevue/dropdown'
import { createToast } from 'mosha-vue-toastify';

export default {
    name: 'TeamsAdmin',
    components: {
        AdminUser,
        MultiSelect,
        Dropdown
    },
    data() {
        return {
            users: [],
            token: localStorage.getItem('token'),
            allTeams: [],
            newUser: {
                username: '',
                email: '',
                password: '1234',
                teams: [],
                role: 'user'
            },
            roleOption: ['user', 'admin', 'superadmin']
        }
    },
    methods: {
        getUsers() {
            GET(ENDPOINTS.GET_ALL_USER, this.token)
                .then(response => {
                    this.users = response.data.data;
                })
                .catch(error => console.dir(error))
        },
        getAllTeam() {
            GET(ENDPOINTS.GET_ALL_TEAM, this.token)
                .then((response) => {
                    this.allTeams = response.data.data
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
        createUser() {
            const data = {
                user: {
                    username: this.newUser.username,
                    email: this.newUser.email,
                    password: this.newUser.password,
                    role: this.newUser.role
                }
            }
            POST(ENDPOINTS.ADMIN_CREATE_USER, data, this.token)
                .then((response) => {
                    for (let i = 0; i < this.newUser.teams.length; i++) {
                        POST(ENDPOINTS.ADD_USER_TO_TEAM + response.data.user.id + '/teams/' + this.newUser.teams[i].id, null, this.token)
                        .then(() => {
                            this.getUsers()
                        })    
                        .catch((error) => {
                                console.dir(error)
                            })
                    }})
                .then(() => {
                    createToast({ title: 'Creation Success', description: `You have sucessfully created the ${this.newUser.username} profile` }, { type: 'success', position: 'bottom-right' });
                    this.newUser = {
                        username: '',
                        email: '',
                        password: '1234',
                        teams: [],
                        role: 'user'
                    }
                })
                .catch((error) => {
                    createToast({ title: 'Creation Failed', description: 'Please try again' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        }
    },
    created() {
        this.getAllTeam();
        this.getUsers();
    }
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
    width: 25%;
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
    border: 1px solid #007C62;
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

.btn {
    margin-top: 10px;
    padding: 5px 20px;
    font-size: 15px;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-create {
    background-color: #00B28C;
}

.btn-create:hover {
    background-color: #007C62;
}
</style>