# frozen_string_literal: true

require "test_helper"

class Ractor::MoveChannelTest < ActiveSupport::TestCase
  def test_moves_objects
    obj = Object.new
    oid = obj.object_id

    channel = Ractor::MoveChannel.new

    channel << obj

    assert_equal oid, channel.take.object_id
  end
end
