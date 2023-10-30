import { sleep } from '@/mixins/tools.coffee'
export default ->
  audioContext = null
  audioOscillator = null
  audioGain = null
  gc = null
  init = ->
    # if audioContext && audioContext.state != 'closed'
    #   destroy()
    return if audioContext
    audioContext = new AudioContext()
    gc = setInterval ()->
      await audioContext?.close?()
      init()
    , 1000 * 60 * 10
  start = (_type = 'triangle', _frequency = 820)->
    clearTimeout gc
    await init() if !audioContext
    audioGain = audioContext.createGain()
    audioGain.connect(audioContext.destination)
    audioOscillator = audioContext.createOscillator()
    audioOscillator.type = _type
    audioOscillator.frequency.value = _frequency
    audioOscillator.connect(audioGain)
    audioOscillator.start(0)
    stop(1.5)
  stop = (_debounce)->
    audioGain?.gain?.exponentialRampToValueAtTime(
      0.00001, audioContext.currentTime + _debounce
    )
  destroy = ->
    audioOscillator?.stop?(audioContext.currentTime)
    # gc = setTimeout ->
    #   await audioContext?.close?()
    #   init()
    # , 1000 * 60
  reset = ->
    new Promise (resolve)->
      clearInterval gc if gc
      try
        await audioContext?.close?()
        audioContext = null
      catch e
      init()
      await sleep(3 * 1000)
      resolve()
  return {
    init
    start
    stop
    destroy
    reset
  }