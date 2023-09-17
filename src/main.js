import { createApp } from 'vue'
import router from '@/router/routers.coffee'
import store from '@/store/store.coffee'
import App from './App.vue'

const app = createApp(App)
app.use(router())
app.use(store)
app.mount('#app')