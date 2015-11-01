#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'active_support/all'

a = []
2000.times do
  a.push( (0...rand(5000)).map { ('a'..'z').to_a[rand(26)] }.join )
end

a.each{|s|
  p s.length
}