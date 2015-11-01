#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'reel'
require 'celluloid/current'
require 'active_support/all'

a = []
2000.times do
  a.push( (0...rand(5000)).map { ('a'..'z').to_a[rand(26)] }.join )
end

class Worker
  include Celluloid
  include Celluloid::Notifications
  @a = []
  def initialize(a)
    @a = a
    async.run
  end
  def run
    r = []
    @a.each{|s| r.push(s.length) }
    publish 'result', r
    terminate
  end
end

class Recipient
  include Celluloid
  include Celluloid::Notifications
  @c = []
  @r = []
  def initialize(c)
    subscribe 'result', :receive
    @c = c
    @r = []
  end
  def receive(topic, r)
    p r
    @r.push(r)
    terminate if @c <= @r.length
  end
end

#Worker.supervise_as :worker
#Recipient.supervise_as :recipient

c = 5

Recipient.new(c)

a.each_slice(a.length / c).each{|slice|
  #p slice
  Worker.new(slice)
}
