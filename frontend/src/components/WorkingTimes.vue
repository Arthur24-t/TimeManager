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
            <td>{{ time.start }}</td>
            <td>{{ time.end }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>
  import { ENDPOINTS } from '../api/endpoints.js'; 
  import { GET } from '../api/axios.js'; 

  export default {
    data() {
      return {
        userId: 'd46350c0-1971-414b-b5d2-90ed541c7255',
        workingTimes: []
      };
    },
    methods: {
      getWorkingTimes(start, end) {
        GET(ENDPOINTS.GET_ALL_TIME + this.userId+'?start=' +start +'&end=' +end)
          .then(response => {
            this.workingTimes = response.data.data;
            console.log(response.data.data)
          })
          .catch(() => {
            console.log('An error occurred while fetching the working times');
          });
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
  