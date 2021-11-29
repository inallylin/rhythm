import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import sass from 'rollup-plugin-sass'
import coffeescript from 'rollup-plugin-coffee-script'
import commonjs from 'rollup-plugin-commonjs'
import nodeResolve from 'rollup-plugin-node-resolve'

/**
 * https://vitejs.dev/config/
 * @type {import('vite').UserConfig}
 */

 export default defineConfig(({ mode }) => {
   const env = loadEnv(mode, __dirname)
   return {
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
      host: 'localhost',
      hmr: {
        port: env.VITE_HMR_PORT,
      }
    }
   }
 })