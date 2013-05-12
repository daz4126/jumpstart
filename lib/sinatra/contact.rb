require 'sinatra/base'
require 'sinatra/flash'
require 'pony'

module Sinatra
  module Contact

    module Helpers

      def send_message
        Pony.mail(
          :from => params[:name] + "<" + params[:email] + ">",
          :to => 'daz4126@gmail.com',
          :subject => params[:name] + " has contacted you",
          :body => params[:message],
          :port => '587',
          :via => :smtp,
          :via_options => { 
            :address              => settings.email_address, 
            :port                 => '587', 
            :enable_starttls_auto => true, 
            :user_name            => settings.email_user_name, 
            :password             => settings.email_password, 
            :authentication       => :plain, 
            :domain               => settings.email_domain
          })
      end

    end

    def self.registered(app)
      app.helpers Helpers

      app.enable :sessions

      app.configure :development do
        app.set :email_address    => 'smtp.gmail.com',
                :email_user_name  => 'daz',
                :email_password   => 'secret',
                :email_domain     => 'localhost.localdomain'
      end

      app.configure :production do
        app.set :email_address    => 'smtp.sendgrid.net',
                :email_user_name  => ENV['SENDGRID_USERNAME'],
                :email_pasword    => ENV['SENDGRID_PASSWORD'],
                :email_domain     => 'heroku.com'
      end

      app.get '/contact' do
        slim :contact
      end

      app.post '/contact' do
        send_message
        flash[:notice] = "Thank you for your message. We'll be in touch soon."
        redirect to('/') 
      end
    end
  end
  register Contact
end
