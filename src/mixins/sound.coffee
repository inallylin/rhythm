export default ->
  audioContext = null
  audioOscillator = null
  audioGain = null
  init = ->
    if audioContext && audioContext.state != 'closed'
      destroy()
    audioContext = new AudioContext()
  start = (_type = 'triangle', _frequency = 820)->
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
    audioOscillator.stop()
    audioContext?.close?()
  return {
    init
    start
    stop
    destroy
  }