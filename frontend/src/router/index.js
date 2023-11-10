import { createRouter, createWebHistory } from 'vue-router'
import Home from '../components/Home.vue'
import Identification from '../components/Identification.vue'
import ChartManager from '../components/ChartManager.vue'
import ChartByUserManager from '../components/ChartByUserManager.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import User from '../components/User.vue'
import Teams from '../components/Teams.vue'
import AdminPanel from '../components/AdminPanel.vue'
import { GET } from '../api/axios'
import { ENDPOINTS } from '../api/endpoints'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/home',
      name: 'home',
      component: Home
    },
    {
      path: '/identification',
      name: 'identification',
      component: Identification
    },
    {
      path: '/charts',
      name: 'charts',
      component: ChartManager,
    },
    {
      path: '/usercharts/:userID',
      name: 'usercharts',
      component: ChartByUserManager
    },
    {
      path: '/workingtimes',
      name: 'workingtimes',
      component: WorkingTimes
    },
    {
      path: '/profile',
      name: 'profile',
      component: User
    },
    {
      path: '/team',
      name: 'team',
      component: Teams
    },
    {
      path: '/admin',
      name: 'admin',
      component: AdminPanel
    },
  ]
})

router.beforeEach((to, from, next) => {
  // Check if the route exists
  if (to.matched.length === 0 && localStorage.getItem('user')) next({ name: 'home' })
  else if (to.matched.length === 0 && !localStorage.getItem('user')) next({name: 'identification'})
  else if (to.name === 'admin') {
    GET(ENDPOINTS.GET_USER_BY_ID + localStorage.getItem('user'), localStorage.getItem('token'))
    .then((response) => {
      if (response.data.data.role != 'superadmin') next({name: 'home'})
      else next()
    })
  }
  else next();
});

export default router
