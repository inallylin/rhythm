import { createStore } from 'vuex'
import preferenceStore from '@/store/modules/preference.coffee'
import playerStore from '@/store/modules/player.coffee'

export default createStore {
  modules: {
    preferenceStore
    playerStore
  }
}