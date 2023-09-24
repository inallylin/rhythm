import { defineConfig, loadEnv } from 'vite';
import vue from '@vitejs/plugin-vue';
import coffee from 'rollup-plugin-coffee-script';
import viteCompression from 'vite-plugin-compression';
import path from "path";

// https://vitejs.dev/config/
export default defineConfig({
  server:  {
    host:  true,
    port:  8080,
  },
  build:   {
    assetsDir:   's',
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
    extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.coffee']
  },
  plugins: [
    vue(),
    coffee(),
    viteCompression({
      algorithm:  'brotliCompress',
      ext:        'br'
    }),
    viteCompression({
      algorithm:  'gzip',
      ext:        'gz'
    }),
  ],
  css: {
    preprocessorOptions: {
      scss: {
        charset: false
      }
    },
    postcss: {
      plugins: [
        {
          postcssPlugin: 'internal:charset-removal',
          AtRule: {
            charset: (atRule) => {
              if (atRule.name === 'charset') {
                atRule.remove();
              }
            }
          }
        }
      ],
    },
  }
});
