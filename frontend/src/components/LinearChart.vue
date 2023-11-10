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
    userID: {
      type: String,
    },
  },
  data() {
    return {
      status: [],
      userId: this.userID || localStorage.getItem('user'),
      token: localStorage.getItem('token'),
      chartData: {
        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        datasets: [
          {
            label: 'Monthly Work Hours',
            borderColor: '#00a3e0',
            borderWidth: 2,
            pointRadius: 5,
            pointBackgroundColor: 'rgba(0, 163, 224, 0.7)', // Couleur des points du graphique (bleu semi-transparent)
            pointBorderColor: 'rgba(0, 163, 224, 0.7)',
            data: [],
            fill: false
          }
        ]
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            title: {
              display: true,
              text: 'Monthly Work Hours',
              color: '#000',
              font: {
                size: 18,
                weight: 'bold',
              },
            },
          },
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
      GET(ENDPOINTS.GET_ALL_TIME + this.userId, this.token, params)
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

<style scoped>
.chart-container {
  width: 100%;
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: rgba(255, 255, 255, 0.5); /* Fond semi-transparent */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}


.chartjs-title {
  font-size: 18px;
  color: #00a3e0; 
}

.chartjs-legend {
  font-size: 14px;
  color: #777; 
}

.chartjs-x-axis-label {
  font-size: 16px;
  color: #00a3e0; 
}

.chartjs-y-axis-label {
  font-size: 16px;
  color: #00a3e0; 
}
</style>

