import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import { pb } from '@/pocketbase/pocketbase';

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView
  },
  {
    path: '/credit',
    name: 'credit',
    component: HomeView
  },
  {
    path: '/debit',
    name: 'debit',
    component: HomeView
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})



router.beforeEach((to, from,next) => {
  if(to.path != "/login") {
    if(!pb.authStore.isValid) {
      pb.authStore.clear();
      router.push({ path: 'login' });
      return;
    }
  }
  next();
});

export default router
