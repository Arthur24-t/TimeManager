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
  props: {
    needRefresh: {
      type: Boolean,
    },
  },
  data() {
    return {
      userId: localStorage.getItem('user'),
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
      GET(ENDPOINTS.GET_ALL_TIME + this.userId, params)
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
      this.getWorkingTimes();
    },
  },
  watch: {
    needRefresh(newValue) {
      if (newValue) {
        this.refresh()
        this.$emit("needrefresh")
      }
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
