# frozen_string_literal: true

require "test_helper"

class Ractor::ChannelTest < ActiveSupport::TestCase
  def test_channel_copies_value
    obj = Object.new
    oid = obj.object_id

    channel = Ractor::Channel.new

    channel << obj

    assert_not_equal oid, channel.take.object_id
  end
end
