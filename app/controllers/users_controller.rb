class UsersController < ApplicationController

  def active
    track_user # Defined in app controller
    @users = ActiveSupport::JSON.decode(RedisClient.redis.get("room:default:active_users").to_s) || []
    respond_to do |format|
      format.js { render :partial => 'active' }
    end
  end

end
