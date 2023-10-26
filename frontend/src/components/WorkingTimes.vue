<template>
  <div class="card workingtime-card">
        <div class="card-header">
          <div class="working-times">
            <slot name="header">Working Times</slot>
            <button @click="refresh">
              Refresh
            </button>
          </div>
        </div>
        <div class="card-body">
          <table>
            <thead>
              <tr>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Settings</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <working-time :creation="true" @refresh="refresh" />
              </tr>
              <tr v-if="workingTimes.length != 0" v-for="time in workingTimes" :key="time.id">
                <working-time :creation="false" :working-time="time" @refresh="refresh" />
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
      workingTimes: [],
      isRotating: false
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
    },
    refresh() {
      this.getWorkingTimes('2023-09-12T12:13:12Z', '2023-12-12T12:45:14Z');
    },
  },
  created() {
    this.getWorkingTimes("2023-09-12T12:13:12Z", "2023-12-12T12:45:14Z");
  }
};
</script>

<style scoped>

.workingtime-card {
  overflow-y: scroll;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border-radius: 4px;
}
.workingtime-card::-webkit-scrollbar {
  width: 3px;
}

/* Track */
.workingtime-card::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px grey; 
  border-radius: 10px;
}
 
/* Handle */
.workingtime-card::-webkit-scrollbar-thumb {
  background: grey; 
  border-radius: 10px;
}

/* Handle on hover */
.workingtime-card::-webkit-scrollbar-thumb:hover {
  background: #b30000; 
}

.working-times {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
  font-weight: bold;
}

table {
  width: 100%;
}

td {
    text-align: center;
    vertical-align: middle;
}

tr {
    text-align: center;
}

</style>
