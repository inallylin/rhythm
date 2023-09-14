<template>
  <div>
    <button @click="createNote">+</button>
    <player :notes="notes" :rests="rests" :use-rest="useRest" />
    <div class="testnote__list">
      <div class="testnote" v-for="note, i in notes">
        <note
          :useRest="config.rest"
          :showCode="config.code"
          :showArrow="config.arrow"
          :index="i"
          :key="i"
          @remove="remove(i)"
          v-model:note="notes[i]"
          v-model:restAt="rests[i]"
          />
        <div class="flex">
          <div class="formfield">
            Note: 
            <input type="number" v-model="notes[i]" min="0" max="15" />
          </div>
          <div class="formfield">
            <div>
              Rest: 
              <input type="number" v-model="rests[i]" min="0" max="15" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, reactive, computed } from 'vue'
  import { storage } from '@/mixins/tools.coffee'
  import { decodeFullnote } from '@/mixins/beat.coffee'
  import player from '@/components/player.vue'
  import note from '@/components/note.vue'
  export default
    components:
      player: player
      note: note
    setup: ->
      useRest = ref false
      notes = ref [9]
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
      return {
        notes
        rests
        useRest
        config
        createNote
        remove
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