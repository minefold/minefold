#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)
require 'rake/clean'

# FIXME: Hack for MongoMapper
namespace(:db){ namespace(:test) { task(:prepare)}}

Minefold::Application.load_tasks

require 'resque'
require 'resque/tasks'
