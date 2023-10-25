<template>
  <div class="clock-manager">
    <div v-if="clockIn">
      <p>Current start date time: {{ startDateTime }}</p>
      <p>Elapsed Time: {{ formatTime(elapsedTime) }}</p>
      <button @click="stopClock">Clock Out</button>
    </div>
    <div v-else>
      <p>No work period in progress</p>
      <p>Elapsed Time: {{ formatTime(elapsedTime) }}</p>
      <button @click="startClock">Clock In</button>
    </div>
  </div>
</template>

<script>
import { POST } from "../api/axios"
import { ENDPOINTS } from "../api/endpoints"
export default {
  name: 'ClockManager',
  props: {
    userID: {
      type: Number,
      required: true
    },
  },
  data() {
    return {
      startDateTime: null,
      clockIn: false,
      elapsedTime: 0,
      timer: null,
    };
  },
  methods: {
    startClock() {
      this.startDateTime = new Date().toLocaleDateString();
      this.clockIn = true;
      this.timer = setInterval(() => {
        this.elapsedTime++;
      }, 1000);
    },
    stopClock() {
      clearInterval(this.timer);
      const data = {
        time: new Date().toLocaleDateString(),
        status: false,
      };
      POST(ENDPOINTS.CREATE_CLOKC + this.userID, data);
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
.clock-manager {
  width: 500px;
  border: 2px solid #3a669f;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
  font-size: 24px;
  text-align: center;
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