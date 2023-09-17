<template>
  <audio ref="sound" src="src/assets/sound/mixkit-cowbell-sharp-hit-1743.wav" />
  <slot :play="play" :isPlaying="isPlaying"></slot>
  <teleport to=".preference" v-if="inited && configurable">
    <!-- <input type="range" v-model="speed" min="100" max="300" step="50"> -->
    <select v-model="speed">
      <option :value="s" v-for="s in [100, 150, 200, 250, 300]">
        {{60000/(s*4)}}bpm
      </option>
    </select>
  </teleport>
</template>
<script lang="coffee">
  import { ref, computed, onMounted, nextTick } from 'vue'
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
      configurable:
        type: Boolean
        default: true
    setup: (props)->
      inited = ref false
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
      onMounted ->
        await nextTick()
        inited.value = true
        console.log 444
      return {
        track
        play
        sound
        speed
        isPlaying
        playerPointer
        inited
      }
</script>