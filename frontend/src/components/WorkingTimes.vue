<template>
  <div class="card">
        <div class="card-header">
            <slot name="header">Working Times</slot>
        </div>
        <div class="card-body">
          <table>
            <tr v-if="workingTimes.length === 0">
                <td>No Content</td>
              </tr>
            <thead v-else>
              <tr>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Settings</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="time in workingTimes" :key="time.id">
                <working-time :working-time="time" />
              </tr>
            </tbody>
          </table>
        </div>
  </div>
</template>

<script>
import moment from 'moment';
import { ENDPOINTS } from '../api/endpoints.js'; 
import { GET } from '../api/axios.js'; 
import WorkingTime from './WorkingTime.vue';

export default {
  name: 'WorkingTimes',
  components: {
    WorkingTime
  },
  data() {
    return {
      userId: localStorage.getItem('user'),
      workingTimes: []
    };
  },
  methods: {
    getWorkingTimes(start, end) {
      GET(ENDPOINTS.GET_ALL_TIME + this.userId + '?start=' + start + '&end=' + end)
        .then(response => {
          this.workingTimes = response.data.data;
        })
        .catch(() => {
          console.log('An error occurred while fetching the working times');
        });
    },
    formatTime(dateTime) {
      return moment(dateTime).format('YYYY-MM-DD HH:mm:ss');
    }
  },
  created() {
    this.getWorkingTimes("2023-09-12T12:13:12Z", "2023-12-12T12:45:14Z");
  }
};
</script>

<style scoped>
/* Add your styles here */
</style>
