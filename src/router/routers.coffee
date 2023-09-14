import { defineAsyncComponent } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'

RhythmGenerator = () => import('@/view/rhythm-generator.vue')
Guess = () => import('@/view/guess.vue')
Choice = () => import('@/view/choice.vue')
About = () => import('@/view/about.vue')


routes = [
  {
    path: '/'
    name: 'home'
    component: RhythmGenerator
  }
  {
    path: '/guess'
    name: 'guess'
    component: Guess
  }
  {
    path: '/choice'
    name: 'choice'
    component: Choice
  }
  {
    path: '/about'
    name: 'about'
    component: About
  }
]
export default (store) ->
  router = createRouter {
    history: createWebHistory()
    routes
  }
  router