<template>
    <Pie :data="chartData" :options="chartOption" />
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
    data() {
        return {
            userId: localStorage.getItem('user'),
            chartData: {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Not Work'],
                datasets: [
                    {
                        backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16', '#ADD1C7'],
                        data: []
                    }
                ]
            },
            chartOption: {
                responsive: false,
                maintainAspectRatio: false,
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

            const daysUntilFriday = 5 - dayOfWeek;
            endOfWeek.setDate(currentDate.getDate() + daysUntilFriday);

            return (
                {
                    start: startOfWeek.toISOString(),
                    end: endOfWeek.toISOString()
                }
            )
        },
        getTime() {
            const params = this.getDayOfTheWeek()

            GET(ENDPOINTS.GET_ALL_TIME + this.userId, params)
                .then((response) => {
                    const totalWorkHours = {
                        1: 0, // Lundi
                        2: 0, // Mardi
                        3: 0, // Mercredi
                        4: 0, // Jeudi
                        5: 0, // Vendredi
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

                    let totalHours = 0
                    const percentages = {};
                    for (const hour in totalWorkHours) {
                        totalHours += totalWorkHours[hour]
                    }

                    for (const day in totalWorkHours) {
                        const hoursWorked = totalWorkHours[day];
                        const percentage = (hoursWorked / totalHours) * 100;
                        percentages[day] = percentage;
                    }

                    this.$nextTick(() => {
                        this.chartData = {
                            labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Not Work'],
                            datasets: [
                                {
                                    backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16', '#ADD1C7'],
                                    data: Object.values(percentages)
                                }
                            ]
                        };
                    });
                })
                .catch((error) => {
                    console.dir(error)
                })
        }
    },
    created() {
        this.getTime();
    },
}
</script>

<style scoped></style>