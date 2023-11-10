<template>
    <div class="clock">
        <div class="cards-container" v-for="(computedClock, index) of computedRealClock" :key="index">
            <div class="container">
                <div class="card-clock bg-up">
                    <div class="inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.nextFormat.slice(-2, -1) }}
                        </div>
                    </div>
                </div>
                <div class="card-clock bg-down">
                    <div class="inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.currentFormat.slice(-2, -1) }}
                        </div>
                    </div>
                </div>
                <div class="flip card-clock" :style="computedClock.ifTens
                    ? `transform: rotateX(-${computedClock.degree}deg);`
                    : ''
                    ">
                    <div class="front inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.currentFormat.slice(-2, -1) }}
                        </div>
                    </div>
                    <div class="back inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.nextFormat.slice(-2, -1) }}
                        </div>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="card-clock bg-up">
                    <div class="inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.nextFormat.slice(-1) }}
                        </div>
                    </div>
                </div>
                <div class="card-clock bg-down">
                    <div class="inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.currentFormat.slice(-1) }}
                        </div>
                    </div>
                </div>
                <div class="flip card-clock" :style="`transform: rotateX(-${computedClock.degree}deg);`">
                    <div class="front inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.currentFormat.slice(-1) }}
                        </div>
                    </div>
                    <div class="back inner" :style="coreStyle">
                        <div class="content">
                            {{ computedClock.nextFormat.slice(-1) }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row-button">
        <button v-if="!clockIn" @click="startClock(true)">Start</button>
        <button v-else @click="stopClock">Stop</button>
    </div>
</template>
  
<script>
import { GET, POST } from "../api/axios"
import { ENDPOINTS } from "../api/endpoints"
export default {
    name: "FlipClock",
    props: {
        innerColor: {
            type: String,
            default: "rgb(41 128 185)",
        },
    },
    data() {
        return {
            userID: localStorage.getItem('user'),
            token: localStorage.getItem('token'),
            startDateTime: null,
            stopDateTime: null,
            clockIn: false,
            elapsedTimeEnabled: false,
            diff: 0,
            elapsedTime: 0,
            timer: null,
            curTime: new Date(0),
            realClock: [
                { max: 23, current: 0, degree: 0 },
                { max: 59, current: 0, degree: 0 },
                { max: 59, current: 0, degree: 0 },
            ],
        };
    },
    created() {
        let responseData = [];
        GET(ENDPOINTS.GET_CLOCK + this.userID, this.token)
            .then(response => {
                responseData = response.data.data;
                const data = responseData.slice(-1);
                if (data[0].status) {
                    this.clockIn = data[0].status;
                    if (this.clockIn) {
                        this.startDateTime = new Date(data[0].time);
                        this.startDateTime.setHours(this.startDateTime.getHours() + 1)
                        console.dir(this.startDateTime)
                        const currentDateTime = new Date();
                        const diff = Math.floor((currentDateTime - this.startDateTime) / 1000);

                        this.realClock[0].current = Math.floor(diff / 3600);
                        this.realClock[1].current = Math.floor((diff % 3600) / 60);
                        this.realClock[2].current = diff % 60;
                        this.startClock(false)
                    }

                }
            })
            .catch((error) => { console.dir(error) });
    },
    computed: {
        computedRealClock() {
            const { realClock, elapsedTimeEnabled } = this;
            const currentDateTime = new Date();
            if (elapsedTimeEnabled && this.startDateTime) {
                this.diff = Math.floor((currentDateTime - this.startDateTime) / 1000);
            }

            return realClock.map((clock) => ({
                ...clock,
                nextFormat: `0${clock.current + 1 > clock.max ? 0 : clock.current + 1}`,
                currentFormat: `0${clock.current}`,
                ifTens:
                    parseInt(clock.current / 10) !== parseInt((clock.current + 1) / 10),
            }));
        },
        coreStyle() {
            return "background: " + this.innerColor;
        },
    },
    methods: {
        startClock(newDate) {
            this.clockIn = true;
            this.elapsedTimeEnabled = true;
            let currentTime = new Date(this.startDateTime);
            if (newDate) {
                this.startDateTime = new Date();
                const data = {
                    clock: {
                        time: new Date(),
                        status: true,
                    }
                };
                POST(ENDPOINTS.CREATE_CLOCK + this.userID, data, this.token)
                    .then((response) => { console.dir("Created Start clock") })
                    .catch((error) => { console.dir(error) });
                currentTime.setHours(0);
                currentTime.setMinutes(0);
                currentTime.setSeconds(0);
            }

            else if (!newDate) {
                currentTime.setHours(this.realClock[0].current);
                currentTime.setMinutes(this.realClock[1].current);
                currentTime.setSeconds(this.realClock[2].current);
            }

            if (this.clockIn) {
                this.timer = setInterval(() => {
                    currentTime.setSeconds(currentTime.getSeconds() + 1);
                    const hours = currentTime.getHours();
                    const minutes = currentTime.getMinutes();
                    const seconds = currentTime.getSeconds();

                    if (hours !== this.realClock[0].current) {
                        this.realClock[0].current = hours;
                        this.flip(hours, 0);
                    }

                    if (minutes !== this.realClock[1].current) {
                        this.realClock[1].current = minutes;
                        this.flip(minutes, 1);
                    }

                    if (seconds !== this.realClock[2].current) {
                        this.realClock[2].current = seconds - 1;
                        this.flip(seconds, 2);
                    }
                }, 1000);
            }
        },
        stopClock() {
            this.stopDateTime = new Date();
            clearInterval(this.timer);
            const dataClock = {
                clock: {
                    time: this.stopDateTime,
                    status: false,
                }
            };
            const dataTime = {
                working_time: {
                    start: this.startDateTime,
                    end: this.stopDateTime,
                }
            };

            POST(ENDPOINTS.CREATE_CLOCK + this.userID, dataClock, this.token)
                .then((response) => { console.dir("Created Stop clock") })
                .catch((error) => { console.dir(error) });

            POST(ENDPOINTS.CREATE_TIME + this.userID, dataTime, this.token)
                .then((response) => { console.dir("Created working time") })
                .catch((error) => { console.dir(error) });

            this.startDateTime = null;
            this.clockIn = false;
            this.elapsedTimeEnabled = false;
            this.elapsedTime = 0;
            this.realClock[0].current = 0;
            this.realClock[1].current = 0;
            this.realClock[2].current = 0;
        },
        formatTime(seconds) {
            const mins = Math.floor(seconds / 60);
            const secs = seconds % 60;
            return `${mins < 10 ? '0' : ''}${mins}:${secs < 10 ? '0' : ''}${secs}`;
        },
        flip(newVal, index = 2) {
            const clock = this.realClock[index];

            if (clock.degree < 180) {
                clock.degree += 4;
                requestAnimationFrame(() => {
                    this.flip(newVal, index);
                });
            } else {
                clock.degree = 0;
                clock.current = newVal;
            }
        },
    },
    beforeDestroy() {
        clearInterval(this.timer);
    },
};
</script>
  
<style>
.row-button {
    display: flex;
    width: auto;
    justify-content: center;
    align-items: center;
}

.row-button button {
    margin-top: 20px;
    padding: 10px 20px;
    font-size: 18px;
    background-color: #3a669f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.row-button button:hover {
    background-color: #504ba9;
}

.clock {
    display: flex;
    align-items: center;
    justify-content: center;
}

.cards-container {
    display: flex;
    justify-content: center;
    position: relative;
}

.cards-container+.cards-container {
    margin-left: 20px;
}

.cards-container+.cards-container::before {
    width: 30px;
    text-align: center;
    z-index: 1;
    position: absolute;
    left: -26px;
    top: 50%;
    transform: translateY(-50%);
    content: ":";
    color: black;
    font-weight: bold;
    font-size: 40px;
    text-shadow: 1px 2px 2px rgb(0 0 0 / 30%);
}

.container {
    position: relative;
    width: 30px;
    height: 45px;
    perspective: 200px;
    position: relative;
    border-radius: 4px;
    box-shadow: 0 2px 5px rgb(0 0 0 / 40%);
}

.container::after {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    height: 1px;
    background: rgb(0 0 0 / 70%);
    box-shadow: 0 1px 2px 0 rgb(0 0 0 / 40%);
    top: calc(50% - 1px);
}

.container+.container {
    margin-left: 5px;
}

.card-clock {
    border-radius: 4px;
    position: absolute;
    font-size: 40px;
    text-align: center;
    line-height: 50px;
    width: 100%;
    height: 50%;
    transform-style: preserve-3d;
    transform-origin: 0% 100%;
}

.inner {
    border-radius: 4px 4px 0 0;
    position: absolute;
    width: 100%;
    height: 100%;
    box-sizing: border-box;
    backface-visibility: hidden;
    overflow: hidden;
}

.inner .content {
    color: white;
    font-weight: bold;
    text-shadow: 1px 2px 2px rgb(34 40 49 / 30%);
    cursor: context-menu;
}

.bg-down {
    top: 50%;
}

.bg-down .inner {
    border-radius: 0 0 4px 4px;
}

.bg-down .inner .content {
    transform: translateY(-48%);
    cursor: context-menu;
}

.back {
    transform: rotateY(180deg);
}

.back .content {
    transform-origin: 50% 47%;
    transform: rotate(180deg);
    cursor: context-menu;
}
</style>