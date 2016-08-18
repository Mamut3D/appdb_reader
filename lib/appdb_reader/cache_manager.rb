require 'fileutils'
require 'json'

module AppdbReader
  # Please burn in hell dear rubocop
  # Best Regards
  # Your Mama
  # (fat)
  class CacheManager
    attr_reader :logger, :filename, :key

    CACHE_DIR = '/tmp/guocci_cache'.freeze

    def initialize(options = {})
      @logger = options[:logger] || Logger.new(STDOUT)
      FileUtils.mkdir_p CACHE_DIR
    end

    def cache_fetch(key, expiration = 1.hour)
      raise 'You have to provide a block!' unless block_given?

      @key = key
      @filename = File.join(CACHE_DIR, key)

      if cache_valid?(expiration)
        cache_hit
      else
        cache_miss(yield)
      end
    end

    private

    def cache_hit
      logger.debug "Cache hit on #{key.inspect}"
      File.open(filename, 'r') do |file|
        file.flock(File::LOCK_SH)
        JSON.parse file.read
      end
    end

    def cache_miss(data)
      logger.debug "Cache miss on #{key.inspect}"
      File.open(filename, File::RDWR | File::CREAT, 0o644) do |file|
        file.flock(File::LOCK_EX)
        file.write JSON.pretty_generate(data)
        file.flush
        file.truncate(file.pos)
      end unless data.blank?
      data
    end

    def cache_valid?(expiration)
      File.exist?(filename) && !File.zero?(filename) && ((Time.now - expiration) < File.stat(filename).mtime)
    end
  end
end
