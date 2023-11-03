<template>
  <div class="card workingtime-card">
    <div class="card-header">
      <div class="working-times">
        <slot name="header">Working Times</slot>
      </div>
    </div>
    <div class="card-body working-time-body">
      <table>
        <thead>
          <tr>
            <th><h3>Date</h3></th>
            <th><h3>Start</h3></th>
            <th><h3>End</h3></th>
            <th><h3>Total</h3></th>
            <th><h3>Actions</h3></th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <working-time :creation="true" @refresh="refresh" />
          </tr>
          <tr v-if="workingTimes.length != 0" v-for="time in workingTimes" :key="time.id">
            <working-time :creation="false" @refresh="refresh" :working-time="time" />
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
  props: {
    needRefresh: {
      type: Boolean,
    },
  },
  data() {
    return {
      userId: localStorage.getItem('user'),
      token: localStorage.getItem('token'),
      workingTimes: [],
      isRotating: false,
      dayOfTheYear: '',
      endOfTheYear: '',
    };
  },
  methods: {
    getDaysOfTheYear() {
      const year = new Date().getFullYear()
      const dayYear = new Date(year, 0, 1);
      const endYear = new Date(year, 11, 31);
      return (
        {
          start: dayYear.toISOString(),
          end: endYear.toISOString()
        }
      )
    },
    getWorkingTimes() {
      const params = this.getDaysOfTheYear()
      GET(ENDPOINTS.GET_ALL_TIME + this.userId, this.token, params)
        .then(response => {
          response.data.data.map((item) => {
            const time = {
              date: '',
              id: item.id,
              start: item.start,
              end: item.end,
              total: '',
              start_init: item.start,
              end_init: item.end
            }
            const start = new Date(item.start);
            const hour_start = start.getHours();
            let minutes_start = start.getMinutes();
            if (minutes_start < 10) minutes_start = '0' + minutes_start
            const end = new Date(item.end);
            const hour_end = end.getHours();
            let minutes_end = end.getMinutes();
            if (minutes_end < 10) minutes_end = '0' + minutes_end
            const differenceEnMillisecondes = end - start;

            const differenceEnSecondes = differenceEnMillisecondes / 1000;
            const tempsTotalEnSecondes = differenceEnSecondes;
            const heures = Math.floor(tempsTotalEnSecondes / 3600);
            const minutes = Math.floor((tempsTotalEnSecondes % 3600) / 60);
            const secondes = tempsTotalEnSecondes % 60;

            let day = start.getDate();
            if (day < 10) {
              day = '0' + day
            }
            let month = (start.getMonth() + 1).toString();
            if (month < 10) {
              month = '0' + month
            }
            const year = start.getFullYear();
            const date = year + '-' + month + '-' + day
            time.date = date
            time.start = hour_start + 'h' + minutes_start
            time.end = hour_end + 'h' + minutes_end
            time.total = heures + 'h' + minutes + 'min' + secondes + 'sec'
            this.workingTimes.push(time)
          })
        })
        .catch((error) => {
          console.log(error);
        });
    },
    formatTime(dateTime) {
      return moment(dateTime).format('YYYY-MM-DD HH:mm:ss');
    },
    refresh() {
      this.workingTimes = []
      this.getWorkingTimes();
    }
  },
  created() {
    this.getWorkingTimes();
  }
};
</script>

<style scoped>
.workingtime-card {
  overflow-y: scroll;
  box-shadow: 0px 8px 13px -3px rgba(0, 0, 0, 0.07);
  border-radius: 4px;
  height: 90vh;
}

.working-time-body {
  padding: 3rem;
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
</style>
