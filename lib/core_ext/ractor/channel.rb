# frozen_string_literal: true

class Ractor
  ##
  # Mimics in manyways a golang channel using Ractor.
  class Channel
    ##
    # @param [Object] the initial value of the channel
    def initialize(initial_value = nil)
      @channel = Ractor.new(ractor_opts) do |ractor_opts|
        loop do
          Ractor.yield(Ractor.receive, **ractor_opts)
        end
      end
      channel << initial_value if initial_value
    end

    ##
    # Passes the value to the channel
    #
    # @param [Object] value the value to pass to the channel
    def <<(value)
      channel << value
    end

    ##
    # Takes a value from the channel, if no value is available, the channel
    # blocks.
    #
    # @return [Object] the value passed to the channel
    def take
      channel.take
    end

    private

    attr_reader :channel

    def ractor_opts
      {}
    end
  end
end
