
playBeat = (context)->
  
  # pointer.value += 1
  context.commit 'pinter.add'
import { sleep } from '@/mixins/tools.coffee'
export default
  state:
    player: null
    track:
      id: null
      value: null
      pointer: 0
      progress: 0
      isPlaying:false
  mutations:
    'pinter.add': (state) ->
      state.track.pointer += 1
    'player.init': (state) ->
      sound.init()
    'play.stop': (state) ->
      clearInterval state.player
      state.track.pointer = 0
      await sleep state.preference.speed
      await sound.stop()
      state.track.isPlaying = false
    'play.start': (state)->
      state.track.isPlaying = true
    'track.init': (context, _id, _track)->
      state.track.id = _id
      state.track.value = _track
  actions:
    'player.init': (context) ->
      context.commit 'player.init'
    'player.start': (context, _track) ->
      context.dispatch 'track.init', _uuid, _track
      context.commit 'play.start' 
      setInterval ()->
        _g = context.getters
        _currentNote = _g.track.value[_g.track.pointer]
        if _g.track.pointer >= _g.track.value?.length
          return context.dispatch 'player.end'
        if _currentNote == 1
          sound.start(_g.preference.wave, _g.preference.hz)
        else if _currentNote == -1
          sound.stop(0)
      , _g.speed)
    'player.end': (context) ->
      context.commit 'play.stop'
  getters:
    trackPointer: (state)-> state.track.pointer
    track: (state)-> state.track