class HomeController < ApplicationController

  def index
    @all_comedians = Rails.cache.fetch 'all_comedians', expires_at: 1.day do
      Comedian.all.to_json
    end
  end

end
