<template>
    <div class="Piechart">
      <Pie :data="chartData" :options="chartOption" />
    </div>
  </template>
  
  <script>
  import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
  import { Pie } from 'vue-chartjs'
  import { GET } from '../api/axios'
  import { ENDPOINTS } from '../api/endpoints'
  
  ChartJS.register(ArcElement, Tooltip, Legend)
  
  export default {
    name: 'PieChart',
    components: {
      Pie
    },
    props: {
      needRefresh: {
        type: Boolean,
      },
    },
    data() {
      return {
        userId: localStorage.getItem('user'),
            token: localStorage.getItem('token'),
        chartData: {
          labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
          datasets: [
            {
              backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16', '#ADD1C7'],
              data: []
            }
          ]
        },
        chartOption: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            title: {
              display: true,
              text: 'Percentage of Work Time per Day',
              color: '#000',
              font: {
                size: 18,
                weight: 'bold',
              },
            },
          }
        }
      }
    },
    methods: {
      getDayOfTheWeek() {
        const currentDate = new Date();
        const dayOfWeek = currentDate.getDay();
        const startOfWeek = new Date(currentDate);
        const endOfWeek = new Date(currentDate);
  
        const daysUntilMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
        startOfWeek.setDate(currentDate.getDate() - daysUntilMonday);
        startOfWeek.setHours(2);
        startOfWeek.setMinutes(0);
        startOfWeek.setSeconds(0);
        startOfWeek.setMilliseconds(0);
  
        const daysUntilFriday = 5 - dayOfWeek;
        endOfWeek.setDate(currentDate.getDate() + daysUntilFriday);
        endOfWeek.setHours(25);
        endOfWeek.setMinutes(59);
        endOfWeek.setSeconds(59);
        endOfWeek.setMilliseconds(999);
  
        return {
          start: startOfWeek.toISOString(),
          end: endOfWeek.toISOString()
        };
      },
      getTime() {
        const params = this.getDayOfTheWeek();
  
        GET(ENDPOINTS.GET_ALL_TIME + this.userId, this.token, params)
          .then((response) => {
            const totalWorkHours = {
              1: 0, // Monday
              2: 0, // Tuesday
              3: 0, // Wednesday
              4: 0, // Thursday
              5: 0, // Friday
            };
  
            response.data.data.forEach((item) => {
              const start = new Date(item.start);
              const end = new Date(item.end);
              while (start <= end) {
                const dayOfWeek = start.getDay();
                totalWorkHours[dayOfWeek] += 1 / 60;
                start.setMinutes(start.getMinutes() + 1);
              }
            });
  
            let totalHours = 0;
            const percentages = {};
            for (const hour in totalWorkHours) {
              totalHours += totalWorkHours[hour];
            }
  
            for (const day in totalWorkHours) {
              const hoursWorked = totalWorkHours[day];
              const percentage = (hoursWorked / totalHours) * 100;
              percentages[day] = percentage;
            }
  
            this.$nextTick(() => {
              this.chartData = {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
                datasets: [
                  {
                    backgroundColor: ['#FF5733', '#33FF57', '#5733FF', '#FFFF33', '#33FFFF'],
                    data: Object.values(percentages)
                  }
                ]
              };
            });
          })
          .catch((error) => {
            console.dir(error);
          });
      },
      refresh() {
        this.getTime();
      },
    },
    watch: {
      needRefresh(newValue) {
        if (newValue) {
          this.refresh();
          this.$emit('needrefresh');
        }
      }
    },
    created() {
      this.getTime();
    }
  };
  </script>
  
  <style scoped>
  .Piechart {
    background-color: rgb(255, 255, 255, 0.5);
    border: 1px solid #ccc;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    width: 400px;
    height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  @media (max-width: 700px) {
    .Piechart {
      width: 80%;
    }
}
  </style>
  