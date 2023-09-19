<template>
  <div class="question">
    <div class="question__answer__wrapper">
      <div class="question__answer__list">
        <div class="question__answer">
          <player :notes="isChecked?answer:notes" :use-rest="false" />
          <div class="question__answer__placeholder" v-if="!answer?.length && !isChecked">
            Choose rhythm to answer....
          </div>
          <note :index="i" :note="n" disabled
            v-for="n, i in answer" :use-rest="n == null"
            :class="{miss: isChecked && !checkResults[i]}"
            />
        </div>
        <div :class="['question__answer', 'correct', {show: isChecked}]">
          <player :notes="notes" :use-rest="false" />
          <note :index="i" :note="n" v-for="n, i in notes" disabled />
        </div>
      </div>
      <button class="btn-check" @click="checkAnswer" v-if="!isChecked">Check Anwser</button>
      <div class="result" v-else>
        <img src="@/assets/image/happy.png" v-if="checkResults.every(e=>e == true)" />
        <img src="@/assets/image/sad.png" v-else />
        <slot name="btn:next"></slot>
      </div>
    </div>
    <div class="question__options" v-if="!isChecked">
      <button v-for="option in options" @click="add(option)">
        <note :note="option" disabled />
      </button>
      <button class="btn-undo" @click="undo"><icon-backspace /></button>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
  import player from '@/components/player.vue'
  import { getRandomArrayItem } from '@/mixins/tools.coffee'
  import note from '@/components/note.vue'
  import iconXmark from '@/components/icon/xmark.vue'
  import iconPlay from '@/components/icon/play.vue'
  import iconBackspace from '@/components/icon/backspace.vue'
  export default
    props:
      modelValue:
        type: Array
        default: []
      options:
        type: Array
        default: []
      result:
        type: Boolean
        type: Array
    components:
      note: note
      player: player
      'icon-xmark': iconXmark
      'icon-play': iconPlay
      'icon-backspace': iconBackspace
    emits: ['update:modelValue', 'update:result']
    setup: (props, {emit})->
      console.log 881
      answer = ref []
      checkResults = ref []
      isChecked = ref false
      notes = computed
        get: -> props.modelValue || []
        set: (value)->
          emit 'update:modelValue', value
      undo = ()->
        answer.value.splice -1, 1
      checkAnswer = (_option)->
        checkResults.value = [0...4]?.map (i)->
          answer.value?[i] == notes.value?[i]
        answer.value?.length = 4 if answer.value?.length < 4
        isChecked.value = true
        _isAllCorrect = checkAnswer.value?.every (c)-> c == true
        emit 'update:result', _isAllCorrect
      add = (_option)->
        answer.value.push _option
      init = ->
        if !notes.value?.length
          _options = [...props.options]
          console.log 123, _options, props.options
          _notes = [0...4].map (i)->
            console.log 'get', i, _options.filter (o)->
              if i == 0 then Number(o)%2 == 1 else true
            _n = getRandomArrayItem _options.filter (o)->
              if i == 0 then Number(o)%2 == 1 else true
          notes.value = _notes
      init()
      return {
        notes
        answer
        add
        undo
        isChecked
        checkAnswer
        checkResults
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
  .beat
    width: 6rem
  .btn-undo
    +button-svg-icon
    background: var(--theme-color)!important
    color: white
    fill: white
    > *
      transform: none
  .question
    margin: 0 auto #{space(xl)*2}
    position: relative
    display: table
    max-width: 51rem
    counter-increment: question
    &:before
      content: counter(question)
      background: var(--theme-color)
      color: white
      padding: space(xs) space(sm)
      line-height: 1
    &__options
      display: flex
      flex-wrap: wrap
      justify-content: center
      align-items: center
      margin-top: space(xl)
      width: auto
      button
        +button
        color: var(--theme-color)
        border: 2px solid
        background: none
        border-radius: 3rem
        margin: space()
        width: 6.5rem
        height: 3rem
      .beat
        padding: 0 space() space()
        transform: scale(0.5) translate(0, 4px)
        transform-origin: left top
    &__answer
      display: flex
      flex-wrap: wrap
      align-items: center
      justify-content: flex-start
      background: color(powder)
      min-height: 96px
      color: color(black)
      &:before
        content: 'mine'
        writing-mode: vertical-lr
        font-size: 18px
        opacity: .5
        text-transform: uppercase
      &__wrapper &__list
        flex: 1 1 100%
      &__wrapper
        display: flex
        > .btn-check
          flex: 1 1 1%
      &__placeholder
        font-size: 24px
        line-height: 4
        color: color(gray)
        flex: 1 1 1%
      :deep(.btn-play)
        flex: 0 0 auto
        margin: 0 space()
      .beat
        padding: space()
        padding-bottom: space(xl)
        &:last-of-type
          margin-right: space()
        &.miss
          color: red
      &.correct
        min-height: 0
        height: 0
        overflow: hidden
        border-top: 1px solid transparent
        color: transparent
        transition: .2s
        &:before
          content: 'correct'
        &.show
          color: var(--theme-color)
          border-color: var(--theme-color)
          height: auto
          min-height: 96px
  .result
    display: flex
    flex-direction: column
    justify-content: center
    align-items: center
    padding: space()
    background: color(powder)
    border-radius: 4px
    margin-left: -2px
    > button
      +button-theme
      margin-top: space()
    > img
      width: 3em
      display: block
  .btn-check
    +button-theme
    border-radius: 4px
</style>