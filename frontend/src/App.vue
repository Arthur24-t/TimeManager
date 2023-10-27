<template>
  <!-- <router-view /> -->
  <div v-if="!authentified" class="identification-view">
    <identification @authentication="updateAuthentication(true)" />
  </div>
  <div v-else class="main-view">
    <div class="left-view">
      <div class="user-clock">
        <user @authentication="updateAuthentication(false)" />
        <clock-manager @needrefresh="updateNeedRefresh(true)" />
      </div>
      <working-times @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh" />
    </div>
    <chart-manager />
  </div>
</template>

<script>
import Identification from './components/Identification.vue';
import User from './components/User.vue';
import WorkingTime from './components/WorkingTime.vue';
import WorkingTimes from './components/WorkingTimes.vue';
import ClockManager from './components/ClockManager.vue';
import ChartManager from './components/ChartManager.vue';

export default {
  name: 'App',
  components: {
    Identification,
    User,
    WorkingTime,
    WorkingTimes,
    ClockManager,
    ChartManager
  },
  data() {
    return {
      user_data: null,
      authentified: false,
      needrefresh: false
    }
  },
  methods: {
    updateData(e) {
      this.user_data = e.data;
      if (this.user_data) this.updateAuthentication(true)
    },
    updateAuthentication(e) {
      this.authentified = e
    },
    updateNeedRefresh(e) {
      this.needrefresh = e
    }
  },
}
</script>

<style>
.identification-view {
  display: flex;
  align-items: center;
  justify-content: center;
}

.main-view {
  display: grid;
  grid-template-columns: 40vw 55vw;
  gap: 1.5rem;
}

.left-view {
  display: grid;
  grid-template-rows: 45vh 50vh;
}

.card {
  border: 1px solid #ccc;
  background-color: white;
  border-radius: 4px;
  padding: 16px;
  margin: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-header {
  font-size: 1.2rem;
  font-weight: bold;
}

.card-body {
  margin-top: 10px;
}

.card-footer {
  margin-top: 10px;
  color: #666;
}

.user-clock {
  display: grid;
  grid-template-columns: 50% 50%;
  gap: 0.5rem;
}

:-webkit-scrollbar {
  width: 3px;
}

/* Track */
:-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px grey;
  border-radius: 10px;
}

/* Handle */
:-webkit-scrollbar-thumb {
  background: grey;
  border-radius: 10px;
}
</style>