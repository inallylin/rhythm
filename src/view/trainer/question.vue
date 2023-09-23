<template>
  <div class="question">
    <div class="question__answer__wrapper">
      <div class="question__answer__list">
        <div :class="['question__answer', {pending: !isChecked}]">
          <player ref="componentPlayer"
            :notes="isChecked?answer:notes" :use-rest="false" />
          <div class="beat__list">
            <div class="question__answer__placeholder" v-if="!answer?.length && !isChecked">
              Choose rhythm to answer....
            </div>
            <note :index="i" :note="n" disabled v-else
              v-for="n, i in answer" :use-rest="n == null"
              :class="{miss: isChecked && !checkResults[i]}"
              />
            <span v-if="hasHighlight" class="beat__pointer"
              :style="pointerStyle(componentPlayer)" />
          </div>
        </div>
        <div :class="['question__answer', 'correct', {show: isChecked}]">
          <player ref="componentPlayerCorrect"
            :notes="notes" :use-rest="false" />
          <div class="beat__list">
            <note :index="i" :note="n" v-for="n, i in notes" disabled />
            <span v-if="hasHighlight" class="beat__pointer"
              :style="pointerStyle(componentPlayerCorrect)" />
          </div>
        </div>
      </div>
      <div class="question__result btn-check" v-if="!isChecked"
        @click="checkAnswer">
        <div class="img">
          <img src="@/assets/image/neutral.png" />
        </div>
        Check Anwser
      </div>
      <div v-else :class="['question__result', `score-${score}`]">
        <div class="img">
          <img src="@/assets/image/happy.png" v-if="score == 4" />
          <img src="@/assets/image/sad.png" v-else />
        </div>
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
  import { useStore } from 'vuex'
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
    components:
      note: note
      player: player
      'icon-xmark': iconXmark
      'icon-play': iconPlay
      'icon-backspace': iconBackspace
    emits: ['update:modelValue', 'update:result']
    setup: (props, {emit})->
      store = useStore()
      answer = ref []
      checkResults = ref []
      isChecked = ref false
      highlight = computed ->
        Number store.getters.preference.highlight
      hasHighlight = computed ->
        highlight.value > 0
      componentPlayer = ref null
      componentPlayerCorrect = ref null
      speed = computed -> store.getters.speed
      notes = computed
        get: -> props.modelValue || []
        set: (value)->
          emit 'update:modelValue', value
      score = computed ->
        checkResults.value?.filter (r)->
          !!r
        .length
      undo = ()->
        answer.value.splice -1, 1
      checkAnswer = (_option)->
        checkResults.value = [0...4]?.map (i)->
          answer.value?[i] == notes.value?[i]
        answer.value?.length = 4 if answer.value?.length < 4
        isChecked.value = true
        _isAllCorrect = checkResults.value?.every (c)-> c == true
        emit 'update:result', _isAllCorrect
      add = (_option)->
        answer.value.push _option if answer.value?.length < 4
      pointerStyle = (_player)->
        if highlight.value == 2 # progress
          return
            width: "#{_player?.progress*100}%"
        _current = 0
        _current = _player?.pointer if _player?.pointer
        if !_current
          return
            transition: 0
            left: 0
        _offset = if _current then Math.ceil(_current/4)-1 else 0
        return
          width: "25%"
          left: "#{_offset*25}%"
        # _offset = if _current then Math.ceil(_current/4)-1 else 0
        # _percentage = (_current - 1) / 16
        # return
          # left: "#{_offset*25}%"
          # transition: "#{speed.value/4/100}s linear"
          # left: if !_current then 0 else "calc(#{_percentage} * 100%)"
          # left: if !_current then 0 else "calc(#{_percentage} * 100%)"

      init = ->
        if !notes.value?.length
          _options = [...props.options]
          _notes = [0...4].map (i)->
            _n = getRandomArrayItem _options.filter (o)->
              if i == 0 then Number(o)%2 == 1 else true
          notes.value = _notes
      init()
      console.log 23
      return {
        notes
        answer
        add
        undo
        isChecked
        checkAnswer
        checkResults
        score
        componentPlayer
        componentPlayerCorrect
        pointerStyle
        hasHighlight
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
  .beat
    width: 6rem
    +max-screen(991)
      min-width: 7rem
    &__list
      display: flex
      align-items: center
      justify-content: flex-start
      flex: 1 1 100%
      position: relative
      align-self: stretch
      transform-origin: center bottom
      +max-screen(576)
        transform: scale(0.85)
        margin-left: -7.5%
        margin-right: -7.5%
        margin-top: space()
      +max-screen(576)
        width: 100vw
        overflow: hidden
      +max-screen(320)
        transform: scale(0.7)
        margin-left: -20%
        margin-right: -20%
    &__pointer
      width: 25%
      transition: .2s
      position: absolute
      bottom: 0
      border-bottom: 2px solid var(--theme-color)
      // width: calc(100% / 16)
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
    max-width: 51rem
    counter-increment: question
    &:before
      content: counter(question)
      background: var(--theme-color)
      color: white
      padding: space(xs) space(sm)
      line-height: 1
      +max-screen(768)
        margin-left: auto
        display: table
        color: var(--theme-color)
        background: none
        font-size: 4rem
        padding-bottom: 0
        margin-bottom: -1rem
        z-index: 1
        right: 1.25rem
        position: relative
        opacity: .25
      +max-screen(576)
        margin-bottom: -2rem
        right: 0
    &__options
      display: flex
      flex-wrap: wrap
      justify-content: center
      align-items: center
      margin-top: space(xl)
      width: auto
      max-width: 100vw
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
      align-items: center
      justify-content: flex-start
      background: color(powder)
      min-height: 96px
      color: color(black)
      position: relative
      &:before
        content: 'mine'
        font-size: 12px
        opacity: .5
        text-transform: uppercase
        +min-screen(769)
          writing-mode: vertical-lr
        +max-screen(768)
          position: absolute
          top: .5em
          left: .25em
          width: 5em
          text-align: center
        +max-screen(576)
          text-align: left
          left: space()
      &.pending:before
        color: transparent
      &__wrapper &__list
        flex: 1 1 100%
      &__wrapper
        display: flex
        +max-screen(576)
          flex-wrap: wrap
        > .btn-check
          +min-screen(577)
            flex: 1 1 1%
      &__placeholder
        font-size: 1.8rem
        color: color(gray)
        flex: 1 1 1%
        +max-screen(576)
          text-align: center
      :deep(.btn-play)
        flex: 0 0 auto
        margin: 0 space()
        +max-screen(576)
          position: absolute
          top: 0
          left: 0
          padding: 0
          background: none!important
          width: 100%
          border-radius: 0
          height: 100%
          margin: 0
          border-color: transparent!important
          z-index: 1
          box-shadow: none!important
          > svg
            right: .5em
            left: auto
            top: auto
            bottom: .5em
            font-size: 1em
      .beat
        padding: 0 space() space(xl) space()
        flex: 0 0 25%
        box-sizing: border-box
        &.miss
          color: red
          :deep(.note.rest:only-child:before)
            content: '?'
            font-weight: normal
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
          border-color: color(gray)
          height: auto
          min-height: 96px
          > .beat__list
            border-color: var(--theme-color)
    &__result
      flex: 0 0 auto
      display: flex
      flex-direction: column
      justify-content: center
      align-items: center
      padding: space()
      box-sizing: border-box
      background: color(powder)
      border-radius: 4px
      margin-left: -2px
      transition: .2s
      .img
        width: 3em
        padding: space(xs)
        border-radius: 50%
        margin-bottom: space(xs)
        transition: inherit
        margin-left: 2px
        > img
          width: 100%
          display: block
      &:not(.btn-check)
        padding-left: 0
        .img
          padding: space()
          background: white
          border-radius: 50%
          border: 2px solid color(gray)
          +max-screen(576)
            box-shadow: 8px 8px color(light)
            border-width: 4px
        &[class*='score']
          > .img
            transform: rotate(45deg)
            +max-screen(576)
              box-shadow: 12px 0px color(light)
            > img
              transform: rotate(-45deg)
        &.score-1 > .img
          border-left-color: var(--theme-color)
        &.score-2 > .img
          border-bottom-color: var(--theme-color)
          border-left-color: var(--theme-color)
        &.score-3 > .img
          border-right-color: var(--theme-color)
          border-bottom-color: var(--theme-color)
          border-left-color: var(--theme-color)
        &.score-4 > .img
          border-color: var(--theme-color)
      &.btn-check
        text-align: center
        text-transform: uppercase
        cursor: pointer
        +min-screen(577)
          font-size: 12px
          line-height: 1
        .img
          opacity: .5
          +max-screen(576)
            opacity: 1
            background: white
            > img
              opacity: .25
        &:hover
          +min-screen(577)
            background: var(--theme-color)
            color: white
            .img
              filter: invert(1)
              opacity: 1
      &, &.bth-check
        +max-screen(576)
          position: relative
          z-index: 1
          margin: -#{space(sm)} auto 0
          padding: space()
          background: none
          padding-top: 0
          .img
            padding: space()
            border: 2px solid var(--theme-color)
            +min-screen(577)
              border-right-color: color(light)
              border-top-color: color(light)
            +max-screen(576)
              box-shadow: 8px 8px color(light)
              border-width: 4px

</style>