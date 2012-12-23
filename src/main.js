require.config({
  paths: {
    jquery: '../lib/jquery-1.8.3.min',
    signals: '../lib/signals.min',
    kinetic: '../lib/kinetic-v3.9.2.min',
    cs: '../lib/cs',
    'coffee-script': '../lib/coffee-script'
  },
  shim: {
    kinetic: {
      exports: 'Kinetic'
    }
  }
});

require(['cs!app']);