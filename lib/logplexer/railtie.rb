module Logplexer
  class Railtie < Rails::Railtie
    initializer "logplexer.configure_rails_initialization" do
      ENV['LOG_ENV'] = Rails.env
    end
  end
end
