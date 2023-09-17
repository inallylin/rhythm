<template>
  <audio ref="sound" src="src/assets/sound/mixkit-cowbell-sharp-hit-1743.wav" />
  <slot :play="play" :isPlaying="isPlaying"></slot>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
  import { createBeats } from '@/mixins/beat.coffee'
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
    setup: (props)->
      sound = ref null
      player = ref null
      isPlaying = computed -> !!player.value
      playerPointer = ref 0
      track = computed ->
        props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest).reverse()
        .flat()
      speed = ref 250 #150
      playBeat = ->
        if playerPointer.value >= track.value.length
          clearInterval(player.value)
          player.value = null
          return
        if track.value[playerPointer.value] == 1
          sound.value.currentTime = 0
          sound.value.play()
        else if track.value[playerPointer.value] == -1
          sound.value.pause()
        playerPointer.value += 1
      play = ->
        clearInterval(player.value)
        playerPointer.value = 0
        player.value = setInterval(playBeat, speed.value)
      return {
        track
        play
        sound
        speed
        isPlaying
        playerPointer
      }
</script>