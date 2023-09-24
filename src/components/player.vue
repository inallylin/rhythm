<template>
  <slot :play="play" :isPlaying="isPlaying">
    <button class="btn-play" @click="play" :disabled="isPlaying">
      <icon-play />
    </button>
  </slot>
</template>
<script lang="coffee">
  import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
  import { useStore } from 'vuex'
  import { createBeats } from '@/mixins/beat.coffee'
  import mixinSound from '@/mixins/sound.coffee'
  import iconPlay from '@/components/icon/play.vue'
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
      store = useStore()
      player = ref null
      progressor = ref null
      isPlaying = computed -> !!player.value
      pointer = ref 0
      progress = ref 0
      sound = mixinSound()
      settings = computed ->
        return
          hz: Number(store.getters.preference?.hz)
          wave: store.getters.preference?.wave
          highlight: Number(store.getters.preference?.highlight)
      track = computed ->
        props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest).reverse()
        .flat()
      speed = computed -> store.getters.speed
      playBeat = (i)->
        if pointer.value >= track.value.length
          clearInterval(player.value)
          player.value = null
          pointer.value = 0
          setTimeout ->
            sound.destroy()
          , speed.value
          return
        if track.value[pointer.value] == 1
          sound.start(settings.value?.wave, settings.value?.hz)
        else if track.value[pointer.value] == -1
          sound.stop(0)
        pointer.value += 1
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
        sound.init()
        clearInterval(player.value)
        pointer.value = 0
        player.value = setInterval(playBeat, speed.value)
        progress.value = 0
        progressor.value = setInterval(updateProgress, 100)
      return {
        track
        play
        speed
        isPlaying
        pointer
        progress
        settings
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