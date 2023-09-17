<template>
  <div class="navpage">
    {{measure}}
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
      <div class="control">
        <button @click="createRamdon()">
          <icon-random />
        </button>
        <button class="btn-add" @click="add">
          <icon-plus />
        </button>
      </div>
    </div>
  </div>
</template>
<script lang="coffee">
import { computed, watch, onMounted, ref, reactive } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import note from '@/components/note.vue'
import { storage } from '@/mixins/tools.coffee'
import iconRandom from '@/components/icon/random.vue'
import iconPlus from '@/components/icon/plus.vue'
export default
  components:
    note: note
    'icon-random': iconRandom
    'icon-plus': iconPlus
  setup: ->
    store = useStore()
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
    # bar = computed
    #   get: -> notes.value.length
    #   set: (value)->
    #     _diff = Number(value) - notes.value.length
    #     for i in [0...Math.abs(_diff)]
    #       if _diff > 0 then add() else notes.value.splice -1, 1
    measure = computed
      get: -> store.getters.preference?.measure
      set: (value)->
        store.dispatch 'preference.set',
          measure: value
    createRamdon = ->
      for n in noteInstance.value
        n?.createNote()
    add = ->
      notes.value.push null
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
    # watch bar, (n)->
    #   noteInstance.value.length = 0
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
    watch measure, (n)->
      console.log 8
      _diff = Number(n) - notes.value.length
      for i in [0...Math.abs(_diff)]
        if _diff > 0 then add() else notes.value.splice -1, 1
    getUrlCode()
    measure.value = 4 if !measure.value
    return {
      noteInstance
      createRamdon
      config
      getNoteInstance
      add
      notes
      rests
      getUrlCode
      remove
      measure
    }
</script>