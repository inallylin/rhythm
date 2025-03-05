<template>
  <slot :play="play" :stop="stop" :isPlaying="isPlaying">
    <button class="btn-play" @click="play" :disabled="isPlaying">
      <icon-play />
    </button>
  </slot>
</template>
<script lang="coffee">
  import { ref, computed, onUnmounted, watch } from 'vue'
  import { useStore } from 'vuex'
  import { createBeats } from '@/mixins/beat.coffee'
  import iconPlay from '@/components/icon/play.vue'
  import { v4 as uuidV4 } from 'uuid'
  export default
    props:
      notes:
        type: Array
        default: []
      rests:
        type: Array
        default: []
      useRest:
        type: Boolean
        default: false
      configurable:
        type: Boolean
        default: true
    components:
      'icon-play': iconPlay
    setup: (props)->
      id = uuidV4()
      store = useStore()
      progressor = ref null
      progress = ref 0
      track = ref([])
      config = computed -> store.getters.preference
      isPlaying = ref false
      storeIsPlaying = computed ->
        return false if store.getters.track?.id != id
        store.getters.track.isPlaying
      pointer = computed ->
        return 0 if !isPlaying.value
        store.getters.track.pointer
      notesLength = computed -> props.notes?.length || 0
      speed = computed -> store.getters.speed
      getTrack = ->
        track.value = props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest, !config.value?.type).reverse()
        .flat()
      updateProgress = (i)->
        if progress.value >= 1
          clearInterval progressor.value
          progressor.value = null
          progress.value = 1
          setTimeout ->
            progress.value = 0
          , speed.value
          return
        _step = 100 / (speed.value*16)
        _progress = progress.value + _step
        progress.value = if _progress < 1 then _progress else 1
      play = ->
        isPlaying.value = true
        await store.dispatch 'player.init'
        # sending ref track to store player, for keep playing on track change
        store.dispatch 'player.start',
          id: id
          value: track
        progressor.value = setInterval(updateProgress, 100)
      stop = ->
        store.dispatch 'player.end'
      a = computed () ->
        console.log('a', props.notes)
        props.note.join()
      watch (() -> props.notes?.join()) ,getTrack
      watch storeIsPlaying, (n) ->
        isPlaying.value = !!n
      getTrack()
      onUnmounted -> stop()
      return {
        id
        track
        play
        stop
        isPlaying
        progress
        pointer
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
  .btn-play
    +button
    +button-round
    +button-svg-icon
    +button-disabled
    background: white
    display: block
    margin: 0 auto
</style>