import vue from '@vitejs/plugin-vue'
import sass from 'rollup-plugin-sass'
import coffeescript from 'rollup-plugin-coffee-script'
import commonjs from 'rollup-plugin-commonjs'
import nodeResolve from 'rollup-plugin-node-resolve'

/**
 * https://vitejs.dev/config/
 * @type {import('vite').UserConfig}
 */
export default {
  input: 'main.coffee',
  plugins: [
    vue(),
    sass(),
    coffeescript(),
    nodeResolve({ extensions: ['.js', '.coffee'] }),
    commonjs({
      extensions: ['.js', '.coffee']
    })
  ],
  server: {
    host: '0.0.0.0',
    hmr: {
      port: 443,
    }
  }
}
