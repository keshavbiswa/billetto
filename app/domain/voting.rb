module Voting
  def self.subscriptions
    [].map(&:subscriptions).reduce(&:merge)
  end
end
