const path    = require('path');
const webpack = require('webpack');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const PORTS = {
  tutor:      '8000',
  shared:     '8000',
  exercises:  '8001',
};

const production   = process.env.NODE_ENV === 'production';
const project      = process.env.OX_PROJECT || 'tutor';
const port         = process.env.DEV_PORT || PORTS[project] || '8000';
const host         = process.env.OX_PROJECT_HOST || 'localhost';
const servePath    = `http://${host}:${port}`;
const publicPath   = process.env.PUBLIC_PATH || (production ? '/assets/' : `${servePath}/dist/`);
const defaultEntry = `./${project}/index.js`;

const ENTRIES = {
  tutor: {
    tutor: defaultEntry,
    lmspair: './tutor/lms-pair.js',
  },
  exercises: { exercises: defaultEntry },
  shared: { demo: './shared/demo.js' },
};

const config = {
  mode: production ? 'production' : 'development',
  entry: ENTRIES[project],
  output: {
    filename: production ? '[name].min.js' : '[name].js',
    path: path.resolve(__dirname, project, 'dist'),
    chunkFilename: '[name]-chunk-[hash].js',
    publicPath,
  },
  devtool: production ? 'source-map' : 'inline-source-map',
  module: {
    rules: [
      { test: /\.jsx?$/,   exclude: /node_modules/, loader: 'babel-loader'         },
      { test: /\.(png|jpg|svg|gif)/, loader: 'file-loader', options: {}            },
      { test: /\.scss$/, use: [ 'style-loader', 'css-loader', 'fast-sass-loader' ] },
      { test: /\.css$/, use: [ 'style-loader', 'css-loader' ] },
      { test: /\.(woff|woff2|eot|ttf)/, loader: 'url-loader',
        options: { limit: 30000, name: '[name]-[hash].[ext]' } },
    ],
  },
  resolve: {
    modules: [
      'node_modules',
      path.resolve(__dirname, project, 'src'),
    ],
    alias: {
      shared: path.resolve(__dirname, 'shared', 'src'),
    },
    extensions: ['.js', '.jsx', '.json'],
  },
  plugins: [
    // don't need locales and they're huge
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    // use custom definitions containing only zones we support
    new webpack.NormalModuleReplacementPlugin(
      /moment-timezone\/data\/packed\/latest\.json/,
      require.resolve('./configs/timezone-definitions')
    ),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(production ? 'production' : 'development'),
      },
    }),
  ],
  optimization: {
    splitChunks: {
      chunks: 'all',
      maxInitialRequests: 1,
    },
  },
  watchOptions: {
    aggregateTimeout: 500,
    poll: 1000,
  },
  devServer: {
    contentBase: project,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
      'Access-Control-Allow-Headers': 'X-Requested-With, content-type, Authorization',
    },
    port,
    publicPath,
    historyApiFallback: true,
    inline: true,
    quiet: false,
    noInfo: false,
    host: '0.0.0.0',
    filename: '[name].js',
    hot: true,
    stats: 'errors-only',
  },
};

if (!production) {
  config.plugins.push(
    new webpack.HotModuleReplacementPlugin(),
  );
}

if (process.env.ANALYZE) {
  config.plugins.push(
    new BundleAnalyzerPlugin()
  );
}

module.exports = config;
