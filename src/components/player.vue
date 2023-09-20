<template>
  <audio ref="sound" src="src/assets/sound/mixkit-cowbell-sharp-hit-1743.wav" />
  <slot :play="play" :isPlaying="isPlaying">
    <button class="btn-play" @click="play" :disabled="isPlaying">
      <icon-play />
    </button>
  </slot>
</template>
<script lang="coffee">
  import { ref, computed, onMounted, nextTick } from 'vue'
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
      playerPointer = ref 0
      track = computed ->
        props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest).reverse()
        .flat()
      # speed = ref 250 #150
      speed = computed ->
        store.getters.speed
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