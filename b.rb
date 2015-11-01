#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'celluloid/current'
#require 'reel'
require 'active_support/all'

#a = File.readlines('source.txt')
Celluloid.shutdown_timeout = 90

class Worker
  include Celluloid
  include Celluloid::Notifications
  def initialize(a)
    @a = a
    async.run
  end
  def run
    p "worker get new task #{@a} #{Time.now.to_f}"
    #r = []
    #@a.each{|s| r.push(s.length) }
    for i in 0..50
      ( (0...rand(50000)).map { ('a'..'z').to_a[rand(26)] }.join ).length
    end
    publish 'result', 1
    p "result published"
    terminate
  end
end

class Recipient
  include Celluloid
  include Celluloid::Notifications
  def initialize(c)
    subscribe 'result', :receive
    @c = c
    @r = 0
    p "recepient subscribed"
  end
  def receive(topic, r)
    p "recipient received result #{Time.now.to_f}"
    #p r.length
    #@r.push(r)
    @r = @r + r
    terminate if @c <= @r
  end
end

#Worker.supervise_as :worker
#Recipient.supervise_as :recipient

c = 4

Recipient.new(c)

for i in 1..c do
  Worker.new(i)
end

#a.each_slice(a.length / c).each{|slice|
  #p slice
#  Worker.new(slice)
#}

