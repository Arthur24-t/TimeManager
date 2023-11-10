import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import 'primevue/resources/themes/lara-light-teal/theme.css'
import './assets/main.css'
import 'mosha-vue-toastify/dist/style.css'
import PrimeVue from 'primevue/config';


const app = createApp(App)

app.use(router).use(PrimeVue)

app.mount('#app')
