class ApplicationController < ActionController::Base
  protect_from_forgery

  def gravatar_url(email)
    hashed_email = Digest::MD5.hexdigest(email)
    "http://gravatar.com/avatar/#{hashed_email}?s=30"
  end
  helper_method :gravatar_url


  private

  def track_user
    active_users = ActiveSupport::JSON.decode(RedisClient.redis.get("room:default:active_users")) || []
    return if active_users.empty?

    active_users = active_users.select { |user| user["last_active"].to_f > 10.seconds.ago.to_f }

    active_users.delete_if { |user| user["name"] == cookies[:username] }
    active_users << {:name => cookies[:username], :last_active => Time.now.to_f, :email => cookies[:email]}

    RedisClient.redis.set("room:default:active_users", active_users.to_json)
  end

end
