const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'static'),
    publicPath: 'static',
    filename: 'bundle.js',
  },

  module: {
    rules: [
      {
        test: /\.styl/i,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "stylus-loader"
        ],
      },
    ],
  },

  plugins: [new MiniCssExtractPlugin()],

  devServer: {
    static: {
      directory: path.join(__dirname, 'static'),
      publicPath: '/',
    },
    port: 8080,
    historyApiFallback: {
      index: 'index.html'
    },
  },
};

