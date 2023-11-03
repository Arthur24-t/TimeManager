<template>
  <div class="card clock-manager">
    <div class="card-header">
      <slot name="header">Clock Manager</slot>
    </div>
    <flip-clock ref="flipClock"/>
  </div>
</template>

<script>
import FlipClock from "./FlipClock.vue"
export default {
  name: 'ClockManager',
  components: {
    FlipClock,
  },
  data() {
    return {
      userID: localStorage.getItem('user'),
      token: localStorage.getItem('token'),
      startDateTime: null,
      stopDateTime: null,
      clockIn: false,
      elapsedTime: 0,
      timer: null,
    };
  },
  methods: {
    startClock() {
            this.$refs.flipClock.startClock();
        },
        stopClock() {
            this.$refs.flipClock.stopClock();
        },
    formatTime(seconds) {
      const hours = Math.floor(seconds / 3600);
      const mins = Math.floor(seconds / 60);
      const secs = seconds % 60;
      this.finalTime = {
        hours : hours,
        minutes : mins,
        secondes : secs,

      }
      //return `${hours < 24 ? '0' : ''}${hours}:${mins < 10 ? '0' : ''}${mins}:${secs < 10 ? '0' : ''}${secs}`;
    },
  },
  beforeDestroy() {
    clearInterval(this.timer);
  },
};
</script>

<style scoped>
.flip-container {
  perspective: 1000px;
  display: inline-block;
  margin: 5px;
}

.flip {
  position: relative;
  width: 40px;
  height: 30px;
  text-align: center;
  transition: transform 0.5s;
  transform-style: preserve-3d;
}

.flip div {
  backface-visibility: hidden;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.flip .back {
  transform: rotateX(-180deg);
}
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

.flip-container {
  perspective: 1000px;
  display: inline-block;
}

.flip {
  position: relative;
  width: 120px;
  height: 30px;
  text-align: center;
  transition: transform 0.5s;
  transform-style: preserve-3d;
}

.flip div {
  backface-visibility: hidden;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.flip .back {
  transform: rotateX(-180deg);
}
</style>