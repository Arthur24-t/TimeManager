<template>
    <td>{{ workingTime.start }}</td>
    <td>{{ workingTime.end }}</td>
    <td>
      <button @click="updateWorkingTime(workingTime.id)" >Modifier</button>
      <button @click="deleteWorkingTime(workingTime.id)">Supprimer</button>
    </td>
</template>

<script>
import { ENDPOINTS } from '../api/endpoints.js'; 
import { POST, PUT, DELETE } from '../api/axios.js'; 

export default {
  props: {
    workingTime: {
      type: Object,
      required:true
    }
  },
  data() {
    return {
      userId: localStorage.getItem('user'),
    };  
  },
  methods: {
    createWorkingTime(newTime) {
      POST(`${ENDPOINTS.CREATE_TIME}${this.userId}`, newTime)
        .then(() => {
          this.getWorkingTimes("2023-01-12T12:45:14Z", "2023-12-12T12:45:14Z");
        })
        .catch(() => {
          console.log('An error occurred while creating the working time');
        });
    },
    updateWorkingTime(timeId) {
      // Vous devez fournir les données à mettre à jour
      PUT(`${ENDPOINTS.UPDATE_TIME}${this.userId}/${timeId}`, { /* données à mettre à jour */ })
        .then(() => {
          this.getWorkingTimes("2023-01-12T12:45:14Z", "2023-12-12T12:45:14Z");
        })
        .catch(() => {
          console.log('An error occurred while updating the working time');
        });
    },
    deleteWorkingTime(timeId) {
      DELETE(`${ENDPOINTS.DELETE_TIME}${this.userId}/${timeId}`)
        .then(() => {
          this.getWorkingTimes("2023-01-12T12:45:14Z", "2023-12-12T12:45:14Z");
        })
        .catch(() => {
          console.log('An error occurred while deleting the working time');
        });
    },
  },
};
</script>

<style scoped>
/* Add your styles here */
</style>
