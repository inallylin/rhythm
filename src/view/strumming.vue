<template>
  <div class="navpage" :style="style">
    <div class="navpage__page">
      <TransitionGroup tag="div" class="bar" name="list" mode="out-in">
        <note
          :ref="getNoteInstance"
          :useRest="config.rest"
          :showCode="config.code"
          :showArrow="config.arrow"
          :index="i"
          :key="i"
          @remove="remove(i)"
          v-model:note="notes[i]"
          v-model:restAt="rests[i]"
          v-for="note, i in notes" />
      </TransitionGroup>
    </div>
    <div class="navpage__nav">
      <div class="preference">
        <div class="color-picker">
          <input id="color-picker" type="color" v-model="config.theme">
          <label for="color-picker" :style="style"></label>
        </div>
        <div class="input">
          <label for="measure">Measure</label>
          <input id="measure" type="Number" min="1" max="100" onfocus="this.select()" v-model="bar">
        </div>
        <div class="checkbox">
          <input id="toggle-code" type="checkbox" v-model="config.code">
          <label for="toggle-code">Code</label>
        </div>
        <div class="checkbox">
          <input id="toggle-arrow" type="checkbox" v-model="config.arrow">
          <label for="toggle-arrow">Arrow</label>
        </div>
        <div class="checkbox">
          <input id="toggle-rest" type="checkbox" v-model="config.rest">
          <label for="toggle-rest">Rest</label>
        </div>
      </div>
      <div class="control">
        <button @click="createRamdon()">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--! Font Awesome Pro 6.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M403.8 34.4c12-5 25.7-2.2 34.9 6.9l64 64c6 6 9.4 14.1 9.4 22.6s-3.4 16.6-9.4 22.6l-64 64c-9.2 9.2-22.9 11.9-34.9 6.9s-19.8-16.6-19.8-29.6V160H352c-10.1 0-19.6 4.7-25.6 12.8L284 229.3 244 176l31.2-41.6C293.3 110.2 321.8 96 352 96h32V64c0-12.9 7.8-24.6 19.8-29.6zM164 282.7L204 336l-31.2 41.6C154.7 401.8 126.2 416 96 416H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H96c10.1 0 19.6-4.7 25.6-12.8L164 282.7zm274.6 188c-9.2 9.2-22.9 11.9-34.9 6.9s-19.8-16.6-19.8-29.6V416H352c-30.2 0-58.7-14.2-76.8-38.4L121.6 172.8c-6-8.1-15.5-12.8-25.6-12.8H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H96c30.2 0 58.7 14.2 76.8 38.4L326.4 339.2c6 8.1 15.5 12.8 25.6 12.8h32V320c0-12.9 7.8-24.6 19.8-29.6s25.7-2.2 34.9 6.9l64 64c6 6 9.4 14.1 9.4 22.6s-3.4 16.6-9.4 22.6l-64 64z"/></svg>
        </button>
        <button class="btn-add" @click="add"></button>
      </div>
    </div>
  </div>
</template>
<script lang="coffee">
import { useRouter } from 'vue-router'
import { computed, watch, onMounted, ref, reactive } from 'vue'
import note from '@/components/note.vue'
import { storage } from '@/mixins/tools.coffee'
export default
  components:
    note: note
  setup: ->
    router = useRouter()
    config = reactive
      theme: storage 'theme', '#1c5580'
      arrow: storage 'arrow', true
      code: storage 'code', true
      rest: storage 'rest', false
    noteInstance = ref []
    notes = ref []
    rests = ref []
    style = computed -> "color: #{config.theme}; fill: #{config.theme}; "
    url = computed
      get: ->
        codes = notes.value.map (note, i)->
          encode note, rests.value[i]
        codes.join()
      set: (value)->
        codes = value.split(',')
        codes.forEach (code, i)-> decode code, i
    bar = computed
      get: -> notes.value.length
      set: (value)->
        _diff = Number(value) - notes.value.length
        for i in [0...Math.abs(_diff)]
          if _diff > 0 then add() else notes.value.splice -1, 1
    createRamdon = ->
      for n in noteInstance.value
        n?.createNote()
    add = ->
      notes.value.push 0
    getNoteInstance = (instance)->
      noteInstance.value.push instance
    getUrlCode =->
      search = location.search.replace '?', ''
      params = {}
      search.split("&").forEach (param)->
        [key, value] = param.split "="
        params[key] = value
      return if !params.code
      syncConfig params.code
      url.value = params.code
    watch bar, (n)->
      noteInstance.value.length = 0
    watch url, (n)->
      router.replace
        name: router.currentRoute.value.name
        query:
          code: n
    decode = (code, i)->
      [_note, _rest] = String(code).match(/.{1,2}/g)
      rests.value[i] = null
      notes.value[i] = parseInt Number(_note)
      rests.value[i] = parseInt Number(_rest) if _rest
    encode = (note, rest)->
      noteCode = String(note).padStart(2, 0)
      restCode = String(rest).padStart(2, 0)
      restCode = '' if !rest
      "#{noteCode}#{restCode}"
    syncConfig = (codeString)->
      _codes = codeString.split ','
      if _codes.some (c)-> c.length == 4
        config.rest = true
    remove = (i)->
      notes.value.splice i, 1
      rests.value.splice i, 1
    getUrlCode()
    bar.value = 4 if !bar.value
    return {
      noteInstance
      style
      bar
      createRamdon
      config
      getNoteInstance
      add
      notes
      rests
      getUrlCode
      remove
    }
</script>
<style lang="sass">
  @import '@/assets/sass/strumming.sass'
</style>