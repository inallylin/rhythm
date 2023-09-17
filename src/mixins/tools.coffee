import { ref, computed } from 'vue'
storage = (slug, defaultValue)->
  _value = ref localStorage.getItem slug
  _value.value = defaultValue if _value == undefined
  _value.value = true if _value.value == 'true'
  _value.value = false if _value.value == 'false'
  _memory = computed
    get: ()-> _value.value
    set: (value)->
      _value.value = value
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