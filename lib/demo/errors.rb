module Demo
  module Errors
    include Salestation::App::Errors

    # Here you can define your app specific errors when needed. See
    # https://github.com/salemove/salestation/blob/master/lib/salestation/app/errors.rb
    # how errors are defined.
    #
    # Note that these are application specific errors. You need also to
    # instruct Salestation how to convert these errors to web errors. See
    # `Using custom errors in error mapper` in the Salestation README and
    # https://github.com/salemove/salestation/blob/master/lib/salestation/web/error_mapper.rb
    # for existing errors.
  end
end
