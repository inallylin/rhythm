<template>
  <TransitionGroup tag="div" class="navpage" name="fade">
    <trainer-setting v-model="options" v-if="!options?.length" />
    <div class="navpage__page" v-if="options?.length">
      <trainer-question
        v-for="q, i in exam"
        :options="options"
        v-model="exam[i]"
        @update:result="(e)=> results[i] = e"
        >
      </trainer-question>
      <button class="btn-theme" @click="add"
        v-if="results.length == exam.length"
        >Next</button>
    </div>
    <div class="navpage__nav" v-if="options?.length">
      <div class="control">
        <div class="exam-result" style="border: 0; line-height: 1;">
          {{resultsState.correct}} / {{resultsState.total}}
          <small>
            {{resultsState.correctRatio}}
          </small>
        </div>
        <button @click="restart"><icon-door-open /></button>
      </div>
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
  import iconDoorOpen from '@/components/icon/door-open.vue'
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
      'icon-door-open': iconDoorOpen
      'icon-play': iconPlay
    setup: ->
      store = useStore()
      inited = ref false
      options = ref []
      exam = ref [null]
      results = ref []
      resultsState = reactive
        total: computed ->
          results.value?.length
        correct: computed ->
          results.value?.filter (r)->
            !!r
          .length
        correctRatio: computed ->
          return '-' if !resultsState.total
          _ratio = resultsState.correct / resultsState.total
          return 0 if isNaN(_ratio)
          "#{(_ratio * 100).toFixed(2)}%"
      highlight = computed
        get: -> store.getters.highlight
        set: (value)->
          store.dispatch 'preference.set',
            highlight: value
      scroll = ->
        _domQuestions = document.querySelectorAll('.question')
        _lastDomQuestion = Array.from(_domQuestions).pop()
        _shift = document.body.clientHeight / 2
        window.scrollTo
          top: _lastDomQuestion.offsetTop + _shift
          behavior: 'smooth'
      add = (i)->
        exam.value.push null
        await nextTick()
        scroll()
      remove = (i)->
        notes.value.splice(i, 1)
        rests.value.splice(i, 1)
      restart = ->
        options.value?.length = 0
        results.value?.length = 0
        exam.value?.length = 0
        exam.value?.push null
      return {
        results
        resultsState
        options
        remove
        inited
        restart
        add
        exam
        highlight
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
    margin: space() auto
    display: table
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
  .exam-result
    font-size: 18px
    font-weight: bold
    display: inline-block
    white-space: nowrap
    padding-top: space(lg)
    +max-screen(414)
      position: absolute
      right: 100%
      bottom: 0
      font-size: 14px
      padding-top: space()
    small
      font-weight: normal
      font-size: 12px
      display: block
      font-size: .75em
      color: color(dark)
      +min-screen(415)
        margin-top: space(sm)
</style>