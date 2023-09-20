import { ref, computed } from 'vue'
storage = (slug, defaultValue)->
  _value = localStorage.getItem slug
  console.log slug, _value
  if [undefined, null].indexOf(_value) != -1
    localStorage.setItem slug, defaultValue
  # _value.value = defaultValue
  # _value.value = true if _value.value == 'true'
  # _value.value = false if _value.value == 'false'
  _memory = computed
    get: ()->
      _value = localStorage.getItem slug
      return true if _value == 'true'
      return false if _value == 'false'
      _value
      # _value.value
    set: (value)->
      # _value.value = value
      console.log 'set', value
      localStorage.setItem slug, value
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