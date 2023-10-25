<template>
  <!-- <router-view /> -->
  <div>
    <user />
    <working-time />
    <working-times />
    <clock-manager />
    <chart-manager />
  </div>
</template>

<script>
import User from './components/User.vue';
import WorkingTime from './components/WorkingTime.vue';
import WorkingTimes from './components/WorkingTimes.vue';
import ClockManager from './components/ClockManager.vue';
import ChartManager from './components/ChartManager.vue';

export default {
  name: 'App',
  components: {
    User,
    WorkingTime,
    WorkingTimes,
    ClockManager,
    ChartManager
  },
}
</script>