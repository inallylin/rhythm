<template>
  <nav>
    <router-link :to="route" v-for="route in routes">
      <component class="icon" :is="route.icon" />
      {{route.text}}
    </router-link>
  </nav>
</template>
<script lang="coffee">
  import iconMusic from '@/components/icon/music.vue'
  import iconQuestion from '@/components/icon/question.vue'
  import iconListCheck from '@/components/icon/list-check.vue'
  export default
    components:
      'icon-music': iconMusic
      'icon-question': iconQuestion
      'icon-list-check': iconListCheck
    setup: ->
      routes = [
        {
          name: 'home'
          icon: 'icon-music'
          text: 'Rhythm Generator'
        }
        {
          name: 'guess'
          icon: 'icon-question'
          text: 'Guess'
        }
        {
          name: 'choice'
          icon: 'icon-list-check'
          text: 'Choice'
        }
      ]
      return {
        routes
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/_mixins.sass'
  nav
    border-bottom: 1px solid
    margin-bottom: space()
    // color: var(--theme-color)
    a
      +form-padding(lg)
      display: inline-block
      text-decoration: none
      // color: white
      // fill: white
      color: #999
      fill: #999
      transition: .2s
      &:hover, &.router-link-active
        color: #333
        fill: #333
      > *
        vertical-align: text-top
      > .icon
        margin-right: space(xs)
        :deep(path)
          fill: inherit

  
</style>