<template>
    <td v-if="creation">
      <input class="input" type="text" v-model="workingTime_Data.start" />
    </td>
    <td v-if="creation">
      <input class="input" type="text" v-model="workingTime_Data.end" />
    </td>
    <td v-if="creation" class="settings">
      <button @click="createWorkingTime" class="btn btn-create">Create</button>
    </td>
    <td v-if="!creation">
      <input class="input" type="text" v-model="workingTime.start" />
    </td>
    <td v-if="!creation">
      <input class="input" type="text" v-model="workingTime.end" />
    </td>
    <td v-if="!creation" class="settings">
      <button @click="updateWorkingTime(workingTime.id)" class="btn btn-update">Update</button>
      <button @click="deleteWorkingTime(workingTime.id)" class="btn btn-delete">Delete</button>
    </td>
</template>

<script>
import { ENDPOINTS } from '../api/endpoints.js'; 
import { POST, PUT, DELETE } from '../api/axios.js';
import { createToast } from 'mosha-vue-toastify';

export default {
  props: {
    workingTime: {
      type: Object,
    },
    creation: {
      type: Boolean
    }
  },
  data() {
    return {
      userId: localStorage.getItem('user'),
      workingTime_Data: {
        start: '',
        end: ''
      },
    };  
  },
  methods: {
    createWorkingTime() {
      const data = {
        working_time: this.workingTime_Data
      }
      POST(ENDPOINTS.CREATE_TIME + this.userId, data)
        .then(() => {
          createToast({ title: 'Creation Success', description: `You have sucessfully created a working time` }, { type: 'success', position: 'bottom-right' });
          this.$emit('refresh')
          this.workingTime_Data.start = ''
          this.workingTime_Data.end = ''
        })
        .catch(() => {
          createToast({ title: 'Creation Failed', description: 'Please try again... Or respect the correct syntaxe' }, { type: 'danger', position: 'bottom-right' });
        });
    },
    updateWorkingTime(timeId) {
      const data = { working_time: this.workingTime}
      // Vous devez fournir les données à mettre à jour
      PUT(ENDPOINTS.MODIFY_TIME + timeId, data)
        .then(() => {
          createToast({ title: 'Update Success', description: `You have sucessfully updated the ${timeId} working time` }, { type: 'success', position: 'bottom-right' });
          this.$emit('refresh')
        })
        .catch(() => {
          createToast({ title: 'Update Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
        });
    },
    deleteWorkingTime(timeId) {
      DELETE(ENDPOINTS.DELETE_TIME + timeId)
        .then(() => {
          createToast({ title: 'Delete Success', description: `You have sucessfully deleted the ${timeId} working time` }, { type: 'success', position: 'bottom-right' });
          this.$emit('refresh')
        })
        .catch(() => {
          createToast({ title: 'Delete Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
        });
    },
  },
};
</script>

<style scoped>

.input {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
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
