import { ref, computed } from 'vue'
storage = (slug, defaultValue)->
  _value = ref localStorage.getItem slug
  _memory = computed
    get: ()->
      return true if _value.value == 'true'
      return false if _value.value == 'false'
      _value.value
    set: (value)->
      _value.value = value
      localStorage.setItem slug, value
  if [undefined, null].indexOf(_value.value) != -1
    _memory.value = defaultValue
  return _memory
deepCopy = (_obj)->
  JSON.parse JSON.stringify(_obj)
getRandomArrayItem = (_array)->
  return null if !Array.isArray(_array) || !_array?.length
  _array[Math.floor(Math.random()*_array.length)]
export {
  storage
  deepCopy
  getRandomArrayItem
}