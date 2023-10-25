<template>
  <!-- <router-view /> -->
  <div v-if="!authentified">
    <identification @authentication="updateAuthentication(true)" />
  </div>
  <div v-else class="main-view">
    <div>
      <user @authentication="updateAuthentication(false)" />
      <working-time />
      <working-times />
      <clock-manager />
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
      authentified: false
    }
  },
  methods: {
    updateData(e) {
      this.user_data = e.data;
      if (this.user_data) this.updateAuthentication(true)
    },
    updateAuthentication(e) {
      this.authentified = e
    }
  },
}
</script>

<style>

.main-view {
  display: flex;
  gap: 1.5rem;
}

.card {
    border: 1px solid #ccc;
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

</style>