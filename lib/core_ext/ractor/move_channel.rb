# frozen_string_literal: true

class Ractor
  ##
  # Mimics a golang channel. In this case the object is moved (as opposed to
  # [Ractor::Cannel]()) rather than copied, which is more expensive. Use
  # channel when possible.
  class MoveChannel < Channel
    private

    def ractor_opts
      { move: true }
    end
  end
end
