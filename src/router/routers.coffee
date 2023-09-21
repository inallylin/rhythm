import { defineAsyncComponent } from 'vue'
import { createRouter, createWebHashHistory } from 'vue-router'

Generator = () => import('@/view/generator.vue')
Trainer = () => import('@/view/trainer.vue')
Challenge = () => import('@/view/challenge.vue')
About = () => import('@/view/about.vue')


routes = [
  {
    path: '/'
    name: 'home'
    component: Generator
  }
  {
    path: '/trainer'
    name: 'trainer'
    component: Trainer
  }
  {
    path: '/challenge'
    name: 'challenge'
    component: Challenge
  }
  {
    path: '/about'
    name: 'about'
    component: About
  }
]
export default (store) ->
  router = createRouter {
    history: createWebHashHistory()
    routes
  }
  router