require 'dalli'
options = { namespace: "laughs_v1", compress: true }
dc = Dalli::Client.new('localhost:11211', options)