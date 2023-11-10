<template>
    <div class="chart">
        <Bar :data="chartData" :options="chartOptions" />
    </div>
</template>
  
<script>
import moment from 'moment';
import { Bar } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js';
import { GET } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

export default {
    name: 'BarChart',
    components: { Bar },
    props: {
        userID: {
            type: String,
        },
    },
    data() {
        return {
            userId: this.userID || localStorage.getItem('user'),
            token: localStorage.getItem('token'),
            loaded: false,
            dataResponse: [],
            listData: [],
            currentDate: moment(),
            chartData: {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
                datasets: [
                    {
                        label: 'Weekly hours worked',
                        backgroundColor: ['#00a3e0', '#00a3e0', '#00a3e0', '#00a3e0', '#00a3e0'],
                        data: []
                    }
                ]
            },
            chartOptions: {
                maintainAspectRatio: false,
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Weekly Work Hours',
                        color: '#000',
                        font: {
                            size: 18,
                            weight: 'bold',
                        },
                    },
                },
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: 'Days of the week',
                        },
                    },
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Hours worked',
                        },
                    },
                },
            },
        };
    },
    methods: {
        getCurrentWeek() {
            const currentDate = new Date();
            const dayOfWeek = currentDate.getDay();
            const startOfWeek = new Date(currentDate);
            const endOfWeek = new Date(currentDate);

            const daysUntilMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
            // Set to the start of the week (00:00:00:000)
            startOfWeek.setDate(currentDate.getDate() - daysUntilMonday);
            startOfWeek.setHours(2);
            startOfWeek.setMinutes(0);
            startOfWeek.setSeconds(0);
            startOfWeek.setMilliseconds(0);

            const daysUntilFriday = 5 - dayOfWeek;
            // Set to the end of the week (23:59:59:999)
            endOfWeek.setDate(currentDate.getDate() + daysUntilFriday);
            endOfWeek.setHours(25);
            endOfWeek.setMinutes(59);
            endOfWeek.setSeconds(59);
            endOfWeek.setMilliseconds(999);

            return (
                {
                    start: startOfWeek.toISOString(),
                    end: endOfWeek.toISOString()
                }
            )
        },
        getWorkingTimes() {
            this.loaded = false;
            const params = this.getCurrentWeek()
            GET(ENDPOINTS.GET_ALL_TIME + this.userId, this.token, params)
                .then(response => {
                    this.dataResponse = response.data.data;

                    this.dataResponse.forEach(data => {

                        const formattedData = {
                            id: data.id,
                            start: data.start,
                            end: data.end,
                            duration: null
                        };

                        const startTime = moment(data.start);
                        const endTime = moment(data.end);
                        const duration = moment.duration(endTime.diff(startTime));
                        const hours = duration.asHours();

                        formattedData.duration = hours;

                        this.listData.push(formattedData);
                    });

                    this.loaded = true;
                    this.updateChartData();
                })
                .catch((error) => {
                    console.dir(error)
                    console.log('An error occurred while fetching the working times');
                });
        },
        updateChartData() {
            const daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
            const weeklyData = {
                Monday: 0,
                Tuesday: 0,
                Wednesday: 0,
                Thursday: 0,
                Friday: 0
            };

            this.listData.forEach(data => {
                const day = moment(data.start).format('dddd');
                weeklyData[day] += data.duration;
            });

            this.$nextTick(() => {
                this.chartData = {
                    labels: daysOfWeek,
                    datasets: [
                        {
                            label: 'Weekly hours worked',
                            backgroundColor: ["#FF5733", "#33FF57", "#5733FF", "#FFFF33", "#33FFFF"],
                            data: daysOfWeek.map(day => weeklyData[day])
                        }
                    ]
                };
            });
        },
        refresh() {
            this.getWorkingTimes();
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
        this.getWorkingTimes();
    },
};
</script>
  
<style scoped>
.chart-container .chartjs-x-axis .chartjs-tick tspan {
    font-family: 'Arial', sans-serif;
    font-size: 14px;
    font-weight: bold;
}


.chart-container .chartjs-y-axis .chartjs-tick tspan {
    font-family: 'Arial', sans-serif;
    font-size: 12px;
}

.chart {
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: rgba(255, 255, 255, 0.5);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    margin-left: 15px;
}
</style>
  