require File.dirname(__FILE__) + '/../environment.rb'
APP_CONFIG = YAML.load_file(File.dirname(__FILE__)+"/../config.yml")[Rails.env]