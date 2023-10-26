<template>
    <td>{{ formatTime(workingTime.start) }}</td>
    <td>{{ formatTime(workingTime.end) }}</td>
    <td class="settings">
      <button @click="updateWorkingTime(workingTime.id)" class="btn btn-update">Update</button>
      <button @click="deleteWorkingTime(workingTime.id)" class="btn btn-delete">Delete</button>
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

.btn {
  margin-top: 10px;
    padding: 5px 20px;
    font-size: 15px;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-update {
    background-color: #FFB90F;
}

.btn-update:hover {
  background-color: #CC940C;
}

.btn-delete {
  background-color: #DD3224;
}

.btn-delete:hover {
    background-color: #9A2319;
}

.settings {
  display: flex;
  gap: 0.5rem;
}

</style>
