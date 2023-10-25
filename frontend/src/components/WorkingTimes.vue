<template>
  <div>
    <h1>Working Times</h1>
    <table>
      <thead>
        <tr>
          <th>Start Time</th>
          <th>End Time</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="time in workingTimes" :key="time.id">
          <working-time :working-time="time" />
          <!-- <td>{{ formatTime(time.start) }}</td>
          <td>{{ formatTime(time.end) }}</td> -->
        </tr>
      </tbody>
    </table>
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
    this.getWorkingTimes("2023-01-12T12:45:14Z", "2023-12-12T12:45:14Z");
  }
};
</script>

<style scoped>
/* Add your styles here */
</style>
