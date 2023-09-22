<template>
  <audio ref="sound" preload>
    <source src="@/assets/sound/mixkit-cowbell-sharp-hit-1743.wav" type="audio/wav">
  </audio>
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
      inited = ref false
      sound = ref null
      player = ref null
      isPlaying = computed -> !!player.value
      pointer = ref 0
      progress = ref 0
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
          return
        if track.value[pointer.value] == 1
          sound.value.currentTime = 0
          sound.value.play()
        else if track.value[pointer.value] == -1
          sound.value.pause()
        pointer.value += 1
      prepare = ->
        new Promise (resolve)->
          sound.value.muted = true
          sound.value.load()
          sound.value.play()
          setTimeout ->
            sound.value.pause()
            sound.value.currentTime = 0
            sound.value.muted = false
            resolve()
          , 500
      play = ->
        clearInterval(player.value)
        await prepare()
        pointer.value = 0
        player.value = setInterval(playBeat, speed.value)
      onMounted ->
        await nextTick()
        await prepare()
        inited.value = true
      return {
        track
        play
        sound
        speed
        isPlaying
        pointer
        inited
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