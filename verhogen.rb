require 'redis'

module Verhogen
  class Client
    attr_reader :host, :port, :name, :redis

    def initialize(opts = {})
      @host  = opts[:host] || 'verhogen.com'
      @port  = opts[:port] || 6379
      @redis = Redis.new(
        :host     => @host,
        :port     => @port,
        :password => opts[:password]
      )
    end

    def method_missing(method, *args)
      redis.send(method, *args)
    end

    def mutex(name)
      Verhogen::Mutex.new(self, name)
    end
  end

  class Mutex
    attr_reader :client, :name

    def initialize(client, name)
      @client       = client
      @name         = name
      @holding_lock = false
      create_if_necessary
    end

    def lock(timeout = 0)
      return false if client.brpop(list_key, timeout).nil?
      @holding_lock = true
      if block_given?
        begin
          yield
        ensure
          unlock
        end
      end

      true
    end

    def unlock
      if holding_lock?
        client.lpush(list_key, 1)
        @holding_lock = false
      end
    end


    ############################################################
    # Private Instance Methods
    ############################################################
    private

    def exists_key
      "mutex:#{name}:exists"
    end

    def list_key
      "mutex:#{name}:list"
    end
    
    def create_if_necessary
      if client.getset(exists_key, 1) != "1"
        client.lpush(list_key, 1)
      end
    end

    def holding_lock?
      @holding_lock
    end
  end

end
