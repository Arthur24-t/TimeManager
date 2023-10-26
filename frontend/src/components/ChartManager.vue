<template>
  <div>
    <ChartBar />
    <LinearChart />
  </div>
</template>
 
<script>
import ChartBar from './ChartBar.vue';
import LinearChart from './LinearChart.vue';

export default {
  name: 'ChartManager',
  components: {
    ChartBar,
    LinearChart
  }
};
</script>