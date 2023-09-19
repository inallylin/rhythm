<template>
  <TransitionGroup tag="div" class="navpage" name="fade">
    <trainer-setting v-model="options" v-if="!options?.length" />
    <div class="navpage__page" v-if="options?.length">
      {{results}}
      <trainer-question
        v-for="q, i in exam"
        :options="options"
        v-model="exam[i]"
        @update:result="(e)=>results[i]"
        >
        <template #btn:next v-if="i == exam.length - 1">
          <button class="btn-theme" @click="add">Next</button>
        </template>
      </trainer-question>
    </div>
    <div class="navpage__nav" v-if="options?.length">
      <div class="control">
        <button style="border: 0; line-height: 1;">
          4 / 5
          <span style="color: #999; display: block">
            (80%)
          </span>
        </button>
        <button @click="add"><icon-plus /></button>
        <button @click="restart"><icon-power-off /></button>
      </div>
      <teleport to=".preference">
        <!-- <input type="range" v-model="speed" min="100" max="300" step="50"> -->
        <select v-model="speed">
          <option :value="s" v-for="s in [150, 200, 250, 300]">
            {{60000/(s*4)}}bpm
          </option>
        </select>
      </teleport>
    </div>
  </TransitionGroup>
</template>
<script lang="coffee">
  import { ref, reactive, computed, onMounted, nextTick } from 'vue'
  import { useStore } from 'vuex'
  import { storage } from '@/mixins/tools.coffee'
  import { decodeFullnote } from '@/mixins/beat.coffee'
  import player from '@/components/player.vue'
  import iconArrowDown from '@/components/icon/arrow-down.vue'
  import iconArrowUp from '@/components/icon/arrow-up.vue'
  import iconPowerOff from '@/components/icon/power-off.vue'
  import iconPlus from '@/components/icon/plus.vue'
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
      'icon-plus': iconPlus
      'icon-power-off': iconPowerOff
      'icon-play': iconPlay
    setup: ->
      store = useStore()
      inited = ref false
      options = ref []
      exam = ref [null]
      results = ref [null]
      speed = computed
        get: -> store.getters.speed
        set: (value)->
          store.dispatch 'preference.set',
            speed: value
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
      add = (i)->
        exam.value.push null

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
      console.log 987
      return {
        results
        options
        config
        createNote
        remove
        inited
        restart
        add
        exam
        speed
      }
</script>
<style lang="sass">
  @import '@/assets/sass/strumming.sass'
</style>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
  .navpage__page
    counter-reset: question
  .flex
    display: flex
    margin: -6px
    margin-top: -2px
    > .formfield
      margin: 6px
  .btn-theme
    +button-theme
    margin-top: space()
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