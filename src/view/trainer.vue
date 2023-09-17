<template>
  <TransitionGroup tag="div" class="navpage" name="fade">
    <trainer-setting v-model="options" v-if="!options?.length" />
    <div class="navpage__page" v-if="options?.length">
      <trainer-question :options="options" v-model="exam[i]"
        v-for="q, i in exam" />
    </div>
    <div class="navpage__nav" v-if="options?.length">
      <player :notes="notes" :rests="rests" :use-rest="false" />
      <div class="control">
        <button><icon-play /></button>
        <button><icon-arrow-up /></button>
        <button><icon-arrow-down /></button>
        <button @click="restart"><icon-power-off /></button>
      </div>
    </div>
  </TransitionGroup>
</template>
<script lang="coffee">
  import { ref, reactive, computed, onMounted, nextTick } from 'vue'
  import { storage } from '@/mixins/tools.coffee'
  import { decodeFullnote } from '@/mixins/beat.coffee'
  import player from '@/components/player.vue'
  import iconArrowDown from '@/components/icon/arrow-down.vue'
  import iconArrowUp from '@/components/icon/arrow-up.vue'
  import iconPowerOff from '@/components/icon/power-off.vue'
  import iconPlay from '@/components/icon/play.vue'
  import trainerSetting from '@/view/trainer/setting.vue'
  import trainerQuestion from '@/view/trainer/question.vue'
  export default
    components:
      player: player
      'trainer-setting': trainerSetting
      'trainer-question': trainerQuestion
      'icon-arrow-down': iconArrowDown
      'icon-arrow-up': iconArrowUp
      'icon-power-off': iconPowerOff
      'icon-play': iconPlay
    setup: ->
      inited = ref false
      options = ref []
      exam = ref [null]
      notes = ref [1...16]
      rests = ref [6]
      config = reactive
        theme: storage 'theme', '#1c5580'
        arrow: storage 'arrow', true
        code: storage 'code', true
        rest: storage 'rest', false
      syncConfig = (codeString)->
        _codes = codeString.split ','
        if _codes.some (c)-> c.length == 4
          config.rest = true
      zeroFill = (_number, _units = 2)->
        String(_number).padStart(_units, 0)
      remove = (i)->
        notes.value.splice(i, 1)
        rests.value.splice(i, 1)
      createNote = (_fullNoteId = '0100')->
        [_note, _rest] = decodeFullnote('0100')
        notes.value.push _note
        rests.value.push _rest
      restart = ->
        options.value?.length = 0
        exam.value?.length = 0
        exam.value?.push null
      return {
        notes
        rests
        options
        config
        createNote
        remove
        inited
        restart
        exam
      }
</script>
<style lang="sass">
  @import '@/assets/sass/strumming.sass'
</style>
<style lang="sass" scoped>
  .testnote
    background: #eee
    font-size: 12px
    margin: 4px
    padding: 4px
    border-radius: 8px
    :deep(.beat)
      padding: 0
      background: white
    &__list
      display: flex
      flex-wrap: wrap
  .flex
    display: flex
    margin: -6px
    margin-top: -2px
    > .formfield
      margin: 6px
  input
    border: 0
    padding: 6px 12px
    border-radius: 4px
    transition: .2s
    width: 4em
    outline: 0
    &:hover, &:focus
      box-shadow: 0 0 0 1px #666
    &:focus
      box-shadow: 0 0 0 1px steelblue
</style>