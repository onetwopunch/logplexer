module Logplexer
  class Railtie < Rails::Railtie
    initializer "logplexer.configure_rails_initialization" do
      if Rails.env == 'development' or Rails.env == 'test'
        ENV['LOG_TO_HB'] = 'false'
      else
        ENV['LOG_TO_HB'] = 'true'
      end
    end
  end
end
