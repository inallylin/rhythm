const path = require('path');
const webpack = require('webpack');
const CopyPlugin = require('copy-webpack-plugin');
const CompressionPlugin = require("compression-webpack-plugin");
const BrotliPlugin = require('brotli-webpack-plugin');
const WebpackShellPlugin = require('webpack-shell-plugin-next');
const CompressionExtensions = ['js', 'css'];

function resolve (dir) {
  return path.join(__dirname, dir)
}
module.exports = {
  productionSourceMap: false,
  parallel: true,
  publicPath: process.env.NODE_ENV === 'production'?'':'/',
  pages: {
    index: {
      entry: 'src/main.js'
    }
  },
  chainWebpack: config => {
    config.resolve.alias
      .set('@', resolve('src'))
      .set('static', resolve('static'))
    ;
    config.module.rule('coffee')
      .test(/\.coffee$/)
      .use('coffee-loader')
      .loader('coffee-loader')
    ;

    config
      .plugin('provide')
      .use(webpack.ProvidePlugin, [{
        $: "jquery-slim",
        jQuery: "jquery-slim",
        "window.jQuery": "jquery-slim",
        "window.$": "jquery-slim",
        // Promise: 'es6-promise'
      }]);

    if(process.env.NODE_ENV !== 'production') {
      return;
    }
    config
    .plugin('compression')
    .use(CompressionPlugin, [{
      filename:     '[path].gz[query]',
      algorithm:    'gzip',
      test:      new RegExp(
        '\\.(' +
        CompressionExtensions.join('|') +
        ')$'
      ),
      threshold: 10240,
      minRatio:  0.8
    }]);
    config
    .plugin('brotli')
    .use(BrotliPlugin, [{
      filename:     '[path].br[query]',
      test:      new RegExp(
        '\\.(' +
        CompressionExtensions.join('|') +
        ')$'
      ),
      threshold: 10240,
      minRatio:  0.8
    }]);
    config.plugin('copy')
      .use(new CopyPlugin([
        { from: 'public/favicon.png', to: 'favicon.png' },
        { from: 'public/apibase.js', to: 'apibase.js' },
        { from: 'public/img', to: 'img' }
      ]));

  },
  configureWebpack: () => {

    var config = {
      resolve: {
        modules: [
          resolve('src'),
          "node_modules"
        ],
      }
    };

    if(process.env.NODE_ENV === 'production') {
      config.optimization = {
        splitChunks: {
          chunks: 'async',
        }
      };
    }

    return config;
  }
};
