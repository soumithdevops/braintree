#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'syslog'

class Beelzebub < Sinatra::Base
  DATA_DIR=File.join(File.dirname(__FILE__), 'data')
  syslog = Syslog.open('beelzebub', Syslog::LOG_PID, Syslog::LOG_DAEMON)

  def get_tx_number
    tx_number = nil
    File.open("#{DATA_DIR}/tx_counter", File::RDWR|File::CREAT, 0644) {|f|
      f.flock(File::LOCK_EX)
      tx_number = f.read.to_i
      value = tx_number + 1
      f.rewind
      f.write("#{value}\n")
      f.flush
      f.truncate(f.pos)
    }
    tx_number
  end

  post '/transaction/' do
    json_data = params[:data]
    tx_data = JSON.parse(json_data)
    tx_number = get_tx_number
    syslog.info("tx #{tx_number} started")
    File.open("#{DATA_DIR}/#{tx_number}.yaml", File::CREAT|File::TRUNC|File::RDWR, 0644) { |f|
      f.write tx_data.to_yaml
      sleep Random.rand(0.5..10)
    }
    syslog.info("tx #{tx_number} completed")
    200
  end
end
