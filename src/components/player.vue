<template>
  <slot :play="play" :isPlaying="isPlaying">
    <button class="btn-play" @click="play" :disabled="isPlaying">
      <icon-play />
    </button>
  </slot>
</template>
<script lang="coffee">
  import { ref, computed, onUnmounted } from 'vue'
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
      isPlaying = computed ->
        return false if store.getters.track?.id != id
        store.getters.track.isPlaying
      pointer = computed ->
        return 0 if !isPlaying.value
        store.getters.track.pointer
      track = computed ->
        props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest).reverse()
        .flat()
      speed = computed -> store.getters.speed
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
        await store.dispatch 'player.init'
        store.dispatch 'player.start',
          id: id
          value: track.value
        progressor.value = setInterval(updateProgress, 100)
      stop = ->
        store.dispatch 'player.end'
      onUnmounted -> stop()
      return {
        id
        track
        play
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