<template>
  {{track}}
  <audio ref="sound" src="src/assets/sound/mixkit-cowbell-sharp-hit-1743.wav" />
  <button @click="play">play</button>
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
      player = null
      track = computed ->
        props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest).reverse()
        .flat()
      speed = ref 250
      play = ->
        _playerPointer = 0
        _play = ()->
          if _playerPointer >= track.value.length
            return clearInterval(player)
          if track.value[_playerPointer] == 1
            sound.value.currentTime = 0
            sound.value.play()
          else if track.value[_playerPointer] == -1
            sound.value.pause()
          _playerPointer += 1
        _play()
        # player = setInterval(_play, 150)
        player = setInterval(_play, 250)
      return {
        track
        play
        sound
        speed
      }
</script>