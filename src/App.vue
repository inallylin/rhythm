<template>
  <img alt="Vue logo" src="./assets/logo.png" />
  <syllable v-for="i in 4" />
</template>

<script setup>
import syllable from './components/syllable.vue'
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>