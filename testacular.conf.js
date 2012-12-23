basePath = '.';

files = [
  REQUIRE,
  REQUIRE_ADAPTER,
  JASMINE,
  JASMINE_ADAPTER,

  {pattern: 'lib/**/*.js', included: false},
  {pattern: 'src/**/*.coffee', included: false},
  {pattern: 'specs/**/*.spec.coffee', included: false},

  'specs/test-setup.coffee',
];

browsers = [
  'PhantomJS'
];

preprocessors = {
  '**/specs/test-setup.coffee': 'coffee'
};