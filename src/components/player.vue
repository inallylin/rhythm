<template>
  <audio ref="sound" preload>
    <source v-if="settings.sound == 2" src="@/assets/sound/mixkit-attention-bell-ding-586.wav" type="audio/wav">
    <source v-if="settings.sound == 1" src="@/assets/sound/mixkit-cowbell-sharp-hit-1743.wav" type="audio/wav">
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
      progressor = ref null
      isPlaying = computed -> !!player.value
      pointer = ref 0
      progress = ref 0
      settings = computed ->
        return
          hz: Number(store.getters.preference?.hz)
          stype: store.getters.preference?.stype
          sound: Number(store.getters.preference?.sound)
          highlight: Number(store.getters.preference?.highlight)
      useWebAudio = computed -> settings.value.sound < 1
      track = computed ->
        props.notes?.map (_note, i)->
          createBeats(_note, props.rests?[i], props.useRest).reverse()
        .flat()
      speed = computed -> store.getters.speed
      eSound =
        context: null
        o: null
        g: null
      hit = (_type = 'triangle', _frequency = 820, _x = 1.5)->
        {context, o, g} = eSound
        o = context.createOscillator()
        g = context.createGain()
        o.type = _type
        o.frequency.value = _frequency
        o.connect(g)
        g.connect(context.destination)
        o.start(0)
        g.gain.exponentialRampToValueAtTime(
          0.00001, context.currentTime + _x
        )
      playBeat = (i)->
        if pointer.value >= track.value.length
          clearInterval(player.value)
          player.value = null
          pointer.value = 0
          return
        if track.value[pointer.value] == 1
          if useWebAudio.value
            hit(settings.value?.stype, settings.value?.hz)
          else
            sound.value.currentTime = 0
            sound.value.play()
        else if !useWebAudio.value && track.value[pointer.value] == -1
          sound.value.pause()
        pointer.value += 1
      prepare = ->
        if useWebAudio.value
          return eSound.context = new AudioContext()
        new Promise (resolve)->
          sound.value.muted = true
          sound.value.load()
          sound.value.play()
          setTimeout ->
            sound.value.pause()
            sound.value.currentTime = 0
            sound.value.muted = false
            resolve()
          , 200
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
        clearInterval(player.value)
        await prepare()
        pointer.value = 0
        player.value = setInterval(playBeat, speed.value)
        progress.value = 0
        progressor.value = setInterval(updateProgress, 100)
      onMounted ->
        await nextTick()
        inited.value = true
      return {
        track
        play
        sound
        speed
        isPlaying
        pointer
        inited
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