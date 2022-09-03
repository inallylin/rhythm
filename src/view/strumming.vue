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
        <button @click="createRamdon()">Random</button>
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
    style = computed -> "color: #{config.theme}"
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
        n.createNote()
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
      url.value = params.code if params.code
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