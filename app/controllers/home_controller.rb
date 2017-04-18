class HomeController < ApplicationController

  def index
    @alerts = Alert.includes(comedian_alerts: :comedian).where(user: current_user).to_json
    @all_comedians = Rails.cache.fetch 'all_comedians', expires_at: 1.day do
      Comedian.all.to_json
    end
  end

end
