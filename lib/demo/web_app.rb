require 'demo/app'
require 'sinatra/base'
require 'sinatra/json'

module Demo
  class WebApp < Sinatra::Base
    ERROR_MAPPER = Salestation::Web::ErrorMapper.new
    APP = Salestation::App.new(env: ENVIRONMENT)

    include Salestation::Web.new
    include Salestation::Web::Extractors

    helpers Sinatra::JSON
    set :show_exceptions, true
    before { content_type(:json) }

    get '/hello/:name' do |name|
      # #process is a Salestation defined method which converts the application
      # response into a web response. e.g. Failure(Forbidden.new(message: ''))
      # is converted into a 403 Forbidden. See Salestation::Web::ErrorMapper
      # and Salestation::Web::Responses. Salestation README shows how to add
      # custom error formats.
      process(
        # Create request with explicitly passing in the params.
        # Salestation::Web::Extractors can help to extract and merge params
        # from different sources like headers and post body.
        APP.create_request(name: name) >>
          # Call the chain where application specific business logic lives.
          # This chain should not know anything about the web.
          HelloUser >>
          # Map success response into 200 Response. There are also other
          # helpers like Responses.to_created which maps to 201 Created and
          # others.
          Responses.to_ok
      )
    end
  end
end
