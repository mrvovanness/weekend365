class SetTokensExpiredJob
  @queue = :clear_old_tokens

  def self.perform
    Token.valid.older_than(2.weeks.ago).each do |token|
      token.update(expired: true)
    end
  end
end
