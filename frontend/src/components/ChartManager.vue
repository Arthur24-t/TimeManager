<template>
  <div>
    <ChartBar />
  </div>
  <div>
    <LinearChart />
  </div>
</template>
 
<script>
import ChartBar from './ChartBar.vue';

export default {
  name: 'ChartManager',
  components: {
    ChartBar
  }
};
import LinearChart from './LinearChart.vue';
 
export default {
  name: 'ChartManager',
  components: {
    LinearChart
  }
};
</script>