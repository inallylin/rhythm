export default
  state:
    loading: []
  mutations:
    'loading.start': (state, _slug)->
      return if state.loading.some (ls)-> ls == _slug
      state.loading.push _slug
    'loading.end': (state, _slug)->
      _idx = state.loading.findIndex (ls)-> ls == _slug
      return if _idx == -1
      state.loading.splice _idx, 1
  actions:
    'loading.start': (context, _slug)->
      context.commit 'loading.start', _slug
    'loading.end': (context, _slug)->
      context.commit 'loading.end', _slug
  getters: 
    isLoading: (state)->
      state.loading?.length > 0