require "capybara"
require "capybara/dsl"
require "capybara-webkit"
require 'capybara/rails'

Capybara.run_server = false
Capybara.current_driver = :webkit

module Capybara2
  include Capybara::DSL

  def Capybara2.get_html(domain, path)

    Capybara.app_host = domain

    describe 'path', js: true do
      visit path
      page.evaluate_script("$('.btn').length")
      return page.html
    end

  end
end