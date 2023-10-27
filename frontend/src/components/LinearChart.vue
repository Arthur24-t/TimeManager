<template>
  <div class="chart-container">
    <Line :data="chartData" :options="chartOptions" />
  </div>
</template>

<script>
import { GET } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';
import { Line } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, CategoryScale, LinearScale, LineElement, PointElement } from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, CategoryScale, LinearScale, LineElement, PointElement);

export default {
  name: 'LineChart',
  components: { Line },
  data() {
    return {
      status: [],
      userID: localStorage.getItem('user'),
      chartData: {
        labels: [0, 8, 10, 12, 14, 16, 18],
        datasets: [
          {
            label: 'Niveau d activité',
            borderColor: '#00a3e0',
            borderWidth: 2,
            pointRadius: 5,
            pointBackgroundColor: '#00a3e0',
            pointBorderColor: '#00a3e0',
            data: [],
            fill: false
          }
        ]
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {
            type: 'category',
            beginAtZero: true,
            title: {
              display: true,
              text: 'Hours'
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Activity Level'
            }
          }
        }
      }
    };
  },
  methods: {
    getClock() {
      GET(ENDPOINTS.GET_CLOCK + this.userID)
        .then((response) => {
          const today = new Date();
          const data = response.data.data.map(item => ({
            status: item.status ? 1 : 0,
            time: new Date(item.time).getHours(),
            date: new Date(item.time).getDate()
          }));

          const currentDate = today.getDate();
          this.status = data.filter(item => item.time >= 7 && item.time < 19 && item.date === currentDate);
          console.dir(this.status)
          this.$nextTick(() => {
            this.chartData = {
              labels: this.status.map(item => item.time),
              datasets: [
                {
                  label: 'Activity Level',
                  borderColor: '#00a3e0',
                  borderWidth: 2,
                  pointRadius: 5,
                  pointBackgroundColor: '#00a3e0',
                  pointBorderColor: '#00a3e0',
                  data: this.status.map(item => item.status),
                  fill: false
                }
              ]
            };
          });

          // this.chartData.labels = this.status.map(item => item.time);
          // this.chartData.datasets[0].data = this.status.map(item => item.status);
        })
        .catch((error) => {
          console.dir(error);
        });
    }
  }
  ,
  created() {
    this.getClock();
  }
};
</script>

<style>
.chart-container {
  width: 400px;
  height: 300px;
  margin: 20px auto;
}
</style>
