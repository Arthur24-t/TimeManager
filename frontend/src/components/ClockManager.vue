<template>
  <div class="card clock-manager">
    <div class="card-header">
      <slot name="header">Clock Manager</slot>
    </div>
    <div class="card-body clock-manager-text">
      <div v-if="clockIn">
        <p>Work period in Progress</p>
        <p>Elapsed Time: {{ formatTime(elapsedTime) }}</p>
        <button @click="stopClock">Clock Out</button>
      </div>
      <div v-else>
        <p>No work period in progress</p>
        <p>Elapsed Time: {{ formatTime(elapsedTime) }}</p>
        <button @click="startClock">Clock In</button>
      </div>
    </div>
  </div>
</template>

<script>
import { POST } from "../api/axios"
import { ENDPOINTS } from "../api/endpoints"
export default {
  name: 'ClockManager',
  data() {
    return {
      userID: localStorage.getItem('user'),
      startDateTime: null,
      stopDateTime: null,
      clockIn: false,
      elapsedTime: 0,
      timer: null,
    };
  },
  methods: {
    startClock() {
      const data = {
        clock: {
          time: new Date(),
          status: true,
        }
      };
      POST(ENDPOINTS.CREATE_CLOCK + this.userID, data)
        .then((response) => { console.dir("Created Start clock") })
        .catch((error) => { console.dir(error) });
      this.startDateTime = new Date();
      this.clockIn = true;
      this.timer = setInterval(() => {
        this.elapsedTime++;
      }, 1000);
    },
    stopClock() {
      this.stopDateTime = new Date();
      clearInterval(this.timer);
      const dataClock = {
        clock: {
          time: this.stopDateTime,
          status: false,
        }
      };
      const dataTime = {
        working_time: {
          start: this.startDateTime,
          end: this.stopDateTime,
        }
      };
      POST(ENDPOINTS.CREATE_CLOKC + this.userID, dataClock)
        .then((response) => { console.dir("Created Stop clock") })
        .catch((error) => { console.dir(error) });

      POST(ENDPOINTS.CREATE_TIME + this.userID, dataTime)
        .then((response) => { console.dir("Created working time") })
        .catch((error) => { console.dir(error) });
      this.startDateTime = null;
      this.clockIn = false;
      this.elapsedTime = 0;
    },
    formatTime(seconds) {
      const mins = Math.floor(seconds / 60);
      const secs = seconds % 60;
      return `${mins < 10 ? '0' : ''}${mins}:${secs < 10 ? '0' : ''}${secs}`;
    },
  },
  beforeDestroy() {
    clearInterval(this.timer);
  },
};
</script>

<style scoped>

.clock-manager-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  text-align: center;
}

.clock-manager {
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border: 2px solid #3a669f;
  border-radius: 4px;
}

button {
  margin-top: 20px;
  padding: 10px 20px;
  font-size: 18px;
  background-color: #3a669f;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

button:hover {
  background-color: #504ba9;
}
</style>