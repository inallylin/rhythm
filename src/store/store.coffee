import { createStore } from 'vuex'
import preferenceStore from '@/store/modules/preference.coffee'
import playerStore from '@/store/modules/player.coffee'
import viewStore from '@/store/modules/view.coffee'

export default createStore {
  modules: {
    preferenceStore
    playerStore
    viewStore
  }
}