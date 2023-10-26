<template>
    <div class="chart-container">
        <div class="navigation">
            <span @click="previousWeek">&#x25C0;</span>
            <span>{{ currentWeek }}</span>
            <span @click="nextWeek">&#x25B6;</span>
        </div>
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
    data() {
        return {
            userId: localStorage.getItem('user'),
            loaded: false,
            dataResponse: [],
            listData: [],
            currentDate: moment(),
            chartData: {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
                datasets: [
                    {
                        label: 'Weekly hours worked',
                        backgroundColor: '#f87979',
                        data: []
                    }
                ]
            },
            chartOptions: {
                maintainAspectRatio: false,
                responsive: true,
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: 'Days of the week',
                        }
                    },
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Hours worked'
                        }
                    }
                }
            }
        };
    },
    computed: {
        currentWeek() {
            let startOfWeek = this.currentDate.clone().startOf('isoWeek');

            while (startOfWeek.isoWeekday() !== 1) {
                startOfWeek.add(1, 'day');
            }
            let endOfWeek = startOfWeek.clone().add(4, 'days');
            return `${startOfWeek.format('YYYY-MM-DD')} to ${endOfWeek.format('YYYY-MM-DD')}`;
        },
    },
    methods: {
        getWorkingTimes(start, end) {
            this.loaded = false;
            GET(ENDPOINTS.GET_ALL_TIME + this.userId + '?start=' + start + '&end=' + end)
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
                            backgroundColor: '#f87979',
                            data: daysOfWeek.map(day => weeklyData[day])
                        }
                    ]
                };
            });
        },
        previousWeek() {
            console.dir("Prev")
            this.currentDate.clone().subtract(7, 'days');
            //this.fetchDataForCurrentWeek();
        },

        nextWeek() {
            console.dir("Next")
            this.currentDate.clone().add(7, 'days');
            //this.fetchDataForCurrentWeek();
        },

        // fetchDataForCurrentWeek() {
        //     const startOfWeek = this.currentDate.clone().startOf('isoWeek').format();
        //     const endOfWeek = this.currentDate.clone().endOf('isoWeek').format();
        //     this.getWorkingTimes(startOfWeek, endOfWeek);
        // },
    },

    created() {
        this.getWorkingTimes("2023-09-12T12:13:12Z", "2023-12-12T12:45:14Z");
        //this.fetchDataForCurrentWeek();
    },
};
</script>
  
<style scoped>
.chart-container {
    width: 400px;
    height: 400px;
    margin: auto;
}

.navigation {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
    font-size: 20px;
}
</style>