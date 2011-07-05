#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)

# FIXME: Hack for MongoMapper
namespace(:db){ namespace(:test) { task(:prepare)}}

Minefold::Application.load_tasks
