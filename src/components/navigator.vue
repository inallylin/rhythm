<template>
  <nav :class="['navigator', {open: show}]" @click="show = !show">
    <button class="navigator__toggle" @click.stop="show = !show">
      <icon-xmark v-if="show" />
      <icon-bars v-else />
    </button>
    <router-link :to="route" v-for="route in routes">
      <component class="icon" :is="route.icon" />
      {{route.text}}
    </router-link>
  </nav>
</template>
<script lang="coffee">
  import { ref } from 'vue'
  import iconMusic from '@/components/icon/music.vue'
  import iconQuestion from '@/components/icon/question.vue'
  import iconListCheck from '@/components/icon/list-check.vue'
  import iconDombBell from '@/components/icon/dombbell.vue'
  import iconMetal from '@/components/icon/metal.vue'
  import iconBars from '@/components/icon/bars.vue'
  import iconXmark from '@/components/icon/xmark.vue'
  export default
    components:
      'icon-music': iconMusic
      'icon-question': iconQuestion
      'icon-list-check': iconListCheck
      'icon-dombbell': iconDombBell
      'icon-metal': iconMetal
      'icon-bars': iconBars
      'icon-xmark': iconXmark
    setup: ->
      show = ref false
      routes = [
        {
          name: 'home'
          icon: 'icon-music'
          text: 'Rhythm'
        }
        {
          name: 'trainer'
          icon: 'icon-dombbell'
          text: 'Trainer'
        }
        {
          name: 'challenge'
          icon: 'icon-metal'
          text: 'Challenge'
        }
      ]
      return {
        routes
        show
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/_mixins.sass'
  a
    +form-padding(lg)
    display: inline-block
    text-decoration: none
    color: color(gray)
    fill: color(gray)
    color: color(dark)
    fill: color(dark)
    transition: .2s
    position: relative
    &:after
      content: ''
      opacity: .5
      left: 0
      right: 0
      display: block
      border-style: solid
      border-color: transparent
      border-width: 0
      position: absolute
      bottom: -1px
      transition: .2s
    &:hover
      color: color(dark)
      fill: color(dark)
    &.router-link-active
      color: color(black)
      fill: var(--theme-color)
      &:after
        border-bottom-width: 1px
        border-color: var(--theme-color)
    > *
      vertical-align: text-top
    > .icon
      margin-right: space(xs)
      opacity: .5
      :deep(path)
        fill: inherit
  .navigator
    +drawer
    border-bottom: 1px solid color(light)
    margin-bottom: space()
    transition: .2s
    text-align: center
    +max-screen(414)
      position: fixed
      z-index: 10
      top: 0
</style>