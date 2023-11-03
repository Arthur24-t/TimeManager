<template>
    <div>
        <div class="user">
            <div class="card">
                <div class="card-header">
                    <slot name="header">User Info</slot>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label for="username">Username :</label>
                        <input id="username" type="text" disabled class="form-control" v-model="user.username" />
                    </div>
                    <div class="form-group">
                        <label for="email">E-mail :</label>
                        <input id="email" type="email" disabled class="form-control" v-model="user.email" />
                    </div>
                </div>
            </div>
        </div>
        <div class="clock">
            <div class="card">
                <div class="card-header">
                    <slot name="header">ClockManager</slot>
                </div>
                <div class="card-body">
                    <flip-clock />
                </div>
            </div>
        </div>
        <div class="chart">
            <div class="card">
                <div class="card-header">
                    <slot name="header">Dashboard</slot>
                    <select v-model="selectedChart">
                        <option value="pie">Pie</option>
                        <option value="bar">Bar</option>
                        <option value="linear">Linear</option>
                    </select>
                </div>
                <div class="card-body">
                    <chart-bar v-if="selectedChart === 'bar'" />
                    <pie-chart v-if="selectedChart === 'pie'" />
                    <linear-chart v-if="selectedChart === 'linear'" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import ClockManager from './ClockManager.vue';
import FlipClock from './FlipClock.vue';
import ChartBar from './ChartBar.vue';
import PieChart from './PieChart.vue';
import LinearChart from './LinearChart.vue';
import { GET } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';

export default {
    name: 'Home',
    components: {
        ClockManager,
        ChartBar,
        PieChart,
        LinearChart,
        FlipClock
    },
    data() {
        return {
            userID: localStorage.getItem('user'),
            token: localStorage.getItem('token'),
            user: {
                username: '',
                email: ''
            },
            selectedChart: 'pie'
        }
    },
    methods: {
        getUser() {
            GET(ENDPOINTS.GET_USER_BY_ID + this.userID, this.token)
                .then((response) => {
                    this.user.username = response.data.data.username
                    this.user.email = response.data.data.email
                })
                .catch((error) => {
                    console.dir(error)
                })
        },
    },
    mounted() {
        this.getUser();
    },
}
</script>

<style scoped>
.form-group {
    margin: 10px 0;
}

.form-control {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}
</style>