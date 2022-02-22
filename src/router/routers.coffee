import { createRouter, createWebHistory } from 'vue-router'

# routes
import Strumming from '@/view/strumming.vue'

routes = [
  {
    path: '/'
    name: 'home'
    component: Strumming
  }
]
export default (store) ->
  router = createRouter {
    history: createWebHistory()
    routes
  }
  router