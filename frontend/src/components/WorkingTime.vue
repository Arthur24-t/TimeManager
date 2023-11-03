<template>
  <td v-if="creation">
    <input class="input date" type="text" disabled :value="getToday()" />
  </td>
  <td v-if="creation">
    <input class="input" placeholder="YYYY-MM-DD HH:MM:SS" type="text" v-on:change="updateTotal" v-model="workingTime_Data.start" />
  </td>
  <td v-if="creation">
    <input class="input" placeholder="YYYY-MM-DD HH:MM:SS" type="text" v-on:change="updateTotal" v-model="workingTime_Data.end" />
  </td>
  <td v-if="creation">
    <input class="input" type="text" v-model="workingTime_Data.total" disabled />
  </td>
  <td v-if="creation" class="settings">
    <button @click="createWorkingTime" class="btn btn-create">Create</button>
  </td>
  <td v-if="!creation">
    <input class="input-table" type="date" v-model="workingTime.date" />
  </td>
  <td v-if="!creation">
    <input class="input-table" type="text" v-model="workingTime.start" />
  </td>
  <td v-if="!creation">
    <input class="input-table end" type="text" v-model="workingTime.end" />
  </td>
  <td v-if="!creation">
    {{ workingTime.total }}
  </td>
  <td v-if="!creation" class="actions">
    <div @click="updateWorkingTime(workingTime.id)" class="btn-update">
      <svg xmlns="http://www.w3.org/2000/svg" width="21" height="18" viewBox="0 0 21 18" fill="none">
        <path
          d="M16.805 6.73358L16.5359 7.23801C16.4374 7.42497 16.2274 7.50257 16.0404 7.42849C15.6532 7.27328 15.2988 7.05105 14.987 6.77238C14.8361 6.63833 14.7967 6.40199 14.8951 6.21856L15.1642 5.71413C14.9378 5.43193 14.7606 5.10387 14.6425 4.74759H14.101C13.9041 4.74759 13.7335 4.59591 13.7007 4.38426C13.635 3.96095 13.6317 3.51649 13.7007 3.07555C13.7335 2.8639 13.9041 2.70869 14.101 2.70869H14.6425C14.7606 2.35241 14.9378 2.02435 15.1642 1.74215L14.8951 1.23772C14.7967 1.05429 14.8328 0.817945 14.987 0.6839C15.2988 0.405227 15.6564 0.182994 16.0404 0.0277833C16.2274 -0.0462944 16.4374 0.0313108 16.5359 0.218269L16.805 0.722702C17.1495 0.65568 17.5007 0.65568 17.8452 0.722702L18.1143 0.218269C18.2127 0.0313108 18.4228 -0.0462944 18.6098 0.0277833C18.997 0.182994 19.3514 0.405227 19.6632 0.6839C19.8141 0.817945 19.8535 1.05429 19.7551 1.23772L19.486 1.74215C19.7124 2.02435 19.8896 2.35241 20.0077 2.70869H20.5492C20.7461 2.70869 20.9167 2.86037 20.9495 3.07202C21.0152 3.49532 21.0185 3.93979 20.9495 4.38073C20.9167 4.59238 20.7461 4.74759 20.5492 4.74759H20.0077C19.8896 5.10387 19.7124 5.43193 19.486 5.71413L19.7551 6.21856C19.8535 6.40199 19.8174 6.63833 19.6632 6.77238C19.3514 7.05105 18.9938 7.27328 18.6098 7.42849C18.4228 7.50257 18.2127 7.42497 18.1143 7.23801L17.8452 6.73358C17.5039 6.8006 17.1495 6.8006 16.805 6.73358ZM16.4604 4.6594C17.7238 5.70354 19.1644 4.15497 18.1931 2.79688C16.9297 1.74921 15.4891 3.30131 16.4604 4.6594ZM12.6768 10.0882L13.7827 10.6809C14.1141 10.8855 14.2585 11.3193 14.1273 11.7074C13.8352 12.561 13.2609 13.3441 12.7293 14.0285C12.4865 14.3424 12.0665 14.42 11.735 14.2154L10.7801 13.6228C10.2551 14.1061 9.6447 14.4906 8.97855 14.741V15.9263C8.97855 16.3355 8.70618 16.6882 8.33209 16.7588C7.52484 16.9069 6.6782 16.914 5.84142 16.7588C5.46404 16.6882 5.18511 16.339 5.18511 15.9263V14.741C4.51896 14.487 3.9086 14.1061 3.38356 13.6228L2.42863 14.2119C2.10048 14.4165 1.67717 14.3389 1.43433 14.0249C0.902726 13.3406 0.341586 12.5575 0.0495309 11.7074C-0.0817299 11.3229 0.062657 10.889 0.394091 10.6809L1.48684 10.0882C1.35886 9.35099 1.35886 8.59257 1.48684 7.8518L0.394091 7.25565C0.062657 7.05105 -0.0850114 6.61717 0.0495309 6.23267C0.341586 5.37901 0.902726 4.59591 1.43433 3.91157C1.67717 3.59762 2.0972 3.52002 2.42863 3.72461L3.38356 4.31723C3.9086 3.83396 4.51896 3.44947 5.18511 3.19901V2.01024C5.18511 1.60458 5.4542 1.25183 5.82829 1.18128C6.63554 1.03312 7.48546 1.02607 8.32225 1.17775C8.69962 1.2483 8.97855 1.59752 8.97855 2.01024V3.19549C9.6447 3.44947 10.2551 3.83044 10.7801 4.31371L11.735 3.72108C12.0632 3.51649 12.4865 3.59409 12.7293 3.90804C13.2609 4.59238 13.8188 5.37549 14.1108 6.22914C14.2421 6.61364 14.1141 7.04752 13.7827 7.25565L12.6768 7.84827C12.8048 8.58905 12.8048 9.34746 12.6768 10.0882ZM8.81776 10.8325C10.7604 8.11636 7.87596 5.01568 5.34919 7.10396C3.40653 9.82015 6.29098 12.9208 8.81776 10.8325ZM16.805 17.2773L16.5359 17.7817C16.4374 17.9687 16.2274 18.0463 16.0404 17.9722C15.6532 17.817 15.2988 17.5948 14.987 17.3161C14.8361 17.1821 14.7967 16.9457 14.8951 16.7623L15.1642 16.2578C14.9378 15.9756 14.7606 15.6476 14.6425 15.2913H14.101C13.9041 15.2913 13.7335 15.1396 13.7007 14.928C13.635 14.5047 13.6317 14.0602 13.7007 13.6193C13.7335 13.4076 13.9041 13.2524 14.101 13.2524H14.6425C14.7606 12.8961 14.9378 12.5681 15.1642 12.2859L14.8951 11.7814C14.7967 11.598 14.8328 11.3617 14.987 11.2276C15.2988 10.9489 15.6564 10.7267 16.0404 10.5715C16.2274 10.4974 16.4374 10.575 16.5359 10.762L16.805 11.2664C17.1495 11.1994 17.5007 11.1994 17.8452 11.2664L18.1143 10.762C18.2127 10.575 18.4228 10.4974 18.6098 10.5715C18.997 10.7267 19.3514 10.9489 19.6632 11.2276C19.8141 11.3617 19.8535 11.598 19.7551 11.7814L19.486 12.2859C19.7124 12.5681 19.8896 12.8961 20.0077 13.2524H20.5492C20.7461 13.2524 20.9167 13.4041 20.9495 13.6157C21.0152 14.039 21.0185 14.4835 20.9495 14.9244C20.9167 15.1361 20.7461 15.2913 20.5492 15.2913H20.0077C19.8896 15.6476 19.7124 15.9756 19.486 16.2578L19.7551 16.7623C19.8535 16.9457 19.8174 17.1821 19.6632 17.3161C19.3514 17.5948 18.9938 17.817 18.6098 17.9722C18.4228 18.0463 18.2127 17.9687 18.1143 17.7817L17.8452 17.2773C17.5039 17.3443 17.1495 17.3443 16.805 17.2773ZM16.4604 15.1996C17.7238 16.2437 19.1644 14.6952 18.1931 13.3371C16.9297 12.2929 15.4891 13.8415 16.4604 15.1996Z"
          fill="black" />
      </svg>
    </div>
    <div @click="deleteWorkingTime(workingTime.id)" class="btn-delete">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" fill="none">
        <rect width="18" height="18" fill="white" />
        <path
          d="M13.753 2.4749H11.5874V1.99678C11.5874 1.15303 10.9124 0.478027 10.0687 0.478027H7.90303C7.05928 0.478027 6.38428 1.15303 6.38428 1.99678V2.4749H4.21865C3.40303 2.4749 2.72803 3.1499 2.72803 3.96553V4.80928C2.72803 5.42803 3.09365 5.93428 3.62803 6.15928L4.07803 15.4687C4.13428 16.6218 5.09053 17.5218 6.24365 17.5218H11.6999C12.853 17.5218 13.8093 16.6218 13.8655 15.4687L14.3437 6.13115C14.878 5.90615 15.2437 5.37178 15.2437 4.78115V3.9374C15.2437 3.1499 14.5687 2.4749 13.753 2.4749ZM7.67803 1.99678C7.67803 1.85615 7.79053 1.74365 7.93115 1.74365H10.0968C10.2374 1.74365 10.3499 1.85615 10.3499 1.99678V2.4749H7.70615V1.99678H7.67803ZM4.02178 3.96553C4.02178 3.85303 4.10615 3.74053 4.24678 3.74053H13.753C13.8655 3.74053 13.978 3.8249 13.978 3.96553V4.80928C13.978 4.92178 13.8937 5.03428 13.753 5.03428H4.24678C4.13428 5.03428 4.02178 4.9499 4.02178 4.80928V3.96553ZM11.728 16.2562H6.27178C5.79365 16.2562 5.3999 15.8905 5.37178 15.3843L4.9499 6.27178H13.078L12.6562 15.3843C12.5999 15.8624 12.2062 16.2562 11.728 16.2562Z"
          fill="#64748B" />
        <path
          d="M8.9999 9.1123C8.6624 9.1123 8.35303 9.39355 8.35303 9.75918V13.3311C8.35303 13.6686 8.63428 13.9779 8.9999 13.9779C9.3374 13.9779 9.64678 13.6967 9.64678 13.3311V9.75918C9.64678 9.39355 9.3374 9.1123 8.9999 9.1123Z"
          fill="#64748B" />
        <path
          d="M11.2499 9.67498C10.8843 9.64686 10.6031 9.89998 10.5749 10.2656L10.4062 12.7406C10.3781 13.0781 10.6312 13.3875 10.9968 13.4156C11.0249 13.4156 11.0249 13.4156 11.0531 13.4156C11.3906 13.4156 11.6718 13.1625 11.6718 12.825L11.8406 10.35C11.8406 9.98436 11.5874 9.70311 11.2499 9.67498Z"
          fill="#64748B" />
        <path
          d="M6.72172 9.67498C6.38422 9.70311 6.10297 10.0125 6.13109 10.35L6.32797 12.825C6.35609 13.1625 6.63734 13.4156 6.94672 13.4156C6.97484 13.4156 6.97484 13.4156 7.00297 13.4156C7.34047 13.3875 7.62172 13.0781 7.59359 12.7406L7.39672 10.2656C7.39672 9.89998 7.08734 9.64686 6.72172 9.67498Z"
          fill="#64748B" />
      </svg>
    </div>
  </td>
</template>

<script>
import { ENDPOINTS } from '../api/endpoints.js';
import { POST, PUT, DELETE } from '../api/axios.js';
import { createToast } from 'mosha-vue-toastify';

export default {
  name: 'WorkingTimes',
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
      token: localStorage.getItem('token'),
      workingTime_Data: {
        start: '',
        end: '',
        total: ''
      },
    };
  },
  methods: {
    getToday() {
      const today = new Date();
      const day = today.getDate().toString().padStart(2, '0');
      const month = (today.getMonth() + 1).toString().padStart(2, '0');
      const year = today.getFullYear();

      return (day + '/' + month + '/' + year);
    },
    updateTotal() {
      if (this.workingTime_Data.start && this.workingTime_Data.end) {
        const start = new Date(this.workingTime_Data.start)
        const end = new Date(this.workingTime_Data.end)
        const differenceEnMillisecondes = end - start;
        const differenceEnSecondes = differenceEnMillisecondes / 1000;
        const tempsTotalEnSecondes = differenceEnSecondes;
        const heures = Math.floor(tempsTotalEnSecondes / 3600);
        const minutes = Math.floor((tempsTotalEnSecondes % 3600) / 60);
        const secondes = tempsTotalEnSecondes % 60;
        this.workingTime_Data.total = heures + 'h' + minutes + 'min' + secondes + 'sec'
      }
    },
    createWorkingTime() {
      const data = {
        working_time: {
          start: this.workingTime_Data.start,
          end: this.workingTime_Data.end
        }
      }
      POST(ENDPOINTS.CREATE_TIME + this.userId, data, this.token)
        .then(() => {
          createToast({ title: 'Creation Success', description: `You have sucessfully created a working time` }, { type: 'success', position: 'bottom-right' });
          this.$emit('refresh')
          this.workingTime_Data.start = ''
          this.workingTime_Data.end = ''
          this.workingTime_Data.total = ''
        })
        .catch(() => {
          createToast({ title: 'Creation Failed', description: 'Please try again... Or respect the correct syntaxe : YYYY-MM-DD HH:MM:SS' }, { type: 'danger', position: 'bottom-right' });
        });
    },
    updateWorkingTime(timeId) {
      const data = {
        working_time: {
          start: '',
          end: ''
        }
      }
      // Utilisez une expression régulière pour extraire les heures et les minutes
      const regex = /(\d{1,2})h(\d{1,2})/;
      const start = this.workingTime.start.match(regex);
      const end = this.workingTime.end.match(regex)

      if (start && end) {
        // match[1] contiendra les heures et match[2] contiendra les minutes
        let hour_start = parseInt(start[1], 10);
        if (hour_start < 10) hour_start = '0' + hour_start
        let minute_start = parseInt(start[2], 10);
        if (minute_start < 10) minute_start = '0' + minute_start

        let hour_end = parseInt(end[1], 10);
        if (hour_end < 10) hour_end = '0' + hour_end
        let minute_end = parseInt(end[2], 10);
        if (minute_end < 10) minute_end = '0' + minute_end
        data.working_time.start = this.workingTime.date + ' ' + hour_start + ':' + minute_start + ':' + '00'
        data.working_time.end = this.workingTime.date + ' ' + hour_end + ':' + minute_end + ':' + '00'
        PUT(ENDPOINTS.MODIFY_TIME + timeId, data, this.token)
          .then(() => {
            createToast({ title: 'Update Success', description: `You have sucessfully updated the ${timeId} working time` }, { type: 'success', position: 'bottom-right' });
            this.$emit('refresh')
          })
          .catch(() => {
            createToast({ title: 'Update Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
          });
      }
    },
    deleteWorkingTime(timeId) {
      DELETE(ENDPOINTS.DELETE_TIME + timeId, this.token)
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
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  text-align: center;
}

.end {
  font-weight: bold;
  background: rgba(33, 150, 83, 0.08);
}

.input-table {
  border: none;
  text-align: center;
  width: 50%;
  padding: 8px;
  border-radius: 30px;
  font-family: Karla;
  font-size: 16px;
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

.btn-update,
.btn-delete {
  cursor: pointer;
}

.btn-update:hover,
.btn-delete:hover {
  opacity: 0.5;
}

.actions {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
  padding-top: 10px;
  height: 80px;
}
</style>
