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
  props: {
    needRefresh: {
      type: Boolean,
    },
  },
  data() {
    return {
      status: [],
      userID: localStorage.getItem('user'),
      chartData: {
        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        datasets: [
          {
            label: 'Monthly Work Hours',
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
              text: 'Annualy Work Hours'
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Hours'
            }
          }
        }
      }
    };
  },
  methods: {
    getDaysOfTheYear() {
      const year = new Date().getFullYear()
      const dayYear = new Date(year, 0, 1);
      const endYear = new Date(year, 11, 31);
      return (
        {
          start: dayYear.toISOString(),
          end: endYear.toISOString()
        }
      )
    },
    getTime() {
      const params = this.getDaysOfTheYear()
      GET(ENDPOINTS.GET_ALL_TIME + this.userID, params)
        .then((response) => {
          const currentYear = new Date().getFullYear();
          const totalWorkMonth = {
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
            9: 0,
            10: 0,
            11: 0,
            12: 0
          };

          response.data.data.forEach((item) => {
            const start = new Date(item.start);
            const end = new Date(item.end);
            while (start <= end && start.getFullYear() === currentYear) {
              const month = start.getMonth() + 1;
              totalWorkMonth[month] += 1 / 60;
              start.setMinutes(start.getMinutes() + 1);
            }
          });

          this.$nextTick(() => {
            this.chartData = {
              labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
              datasets: [
                {
                  label: 'Monthly Work Hours',
                  borderColor: '#999999',
                  borderWidth: 2,
                  pointRadius: 5,
                  pointBackgroundColor: ['#0000FF', '#800080', '#00FF00', '#FFC0CB', '#FFFF00', '#00FF80', '#FF0000', '#FFA500', '#87CEEB', '#8B4513', '#808080', '#FFFFFF'],
                  pointBorderColor: ['#0000FF', '#800080', '#00FF00', '#FFC0CB', '#FFFF00', '#00FF80', '#FF0000', '#FFA500', '#87CEEB', '#8B4513', '#808080', '#FFFFFF'],
                  data: [],
                  fill: false,
                  data: Object.values(totalWorkMonth)
                }
              ]
            };
          });

        })
        .catch((error) => {
          console.dir(error)
        })
    },
    refresh() {
      this.getTime();
    },
  },
  watch: {
    needRefresh(newValue) {
      if (newValue) {
        this.refresh()
        this.$emit("needrefresh")
      }
    }
  },
  created() {
    this.getTime();
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
