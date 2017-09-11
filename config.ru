#!/usr/bin/env ruby

env = (ENV['RUN_ENV'] ||= 'development')
STDOUT.sync = true if env == 'development'
$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'logasm'
logger = Logasm.build('demo', stdout: {level: 'debug'})

require 'demo/environment'
ENVIRONMENT = Demo::Environment.new(
  logger: logger
)

require 'demo/web_app'
use Salestation::Web::RequestLogger, logger
run Demo::WebApp
