module Demo
  module HelloUser
    extend Deterministic::Prelude

    Schema = Dry::Validation.Schema do
      required(:name).filled { type?(String) & max_size?(10) }
    end

    # This chain is using #in_sequence from Deterministic::Prelude to walk
    # through the chain. See
    # https://github.com/pzol/deterministic/blob/master/README.md#chaining-with-in_sequence
    # for more information how it works.
    #
    # Note that common functionality can be instracted into separate modules.
    # Here Input is a separate module which has method called verify.
    def self.call(request)
      in_sequence do
        get(:input) { Input.verify(Schema, request.input) }
        and_then    { verify_name(input.fetch(:name)) }
        observe     { log_usage(request.env) }
        and_yield   { format_response(input.fetch(:name)) }
      end
    end

    def self.verify_name(name)
      if name == 'John'
        # Returning errors is simple as just returning the Deterministic
        # Failure with application error object. See errors.rb for more
        # information.
        #
        # Note that one chain is not restricted to one error type. You could
        # easily return
        # Failure(Errors::DependencyCurrentlyUnavailable.new(message: ''))
        # as well when some other condition fails.
        Failure(Errors::Forbidden.new(message: 'Johns are not welcome here'))
      else
        # We don't care about the return value here so we can just return nil.
        Success(nil)
      end
    end

    # Requests have #env method which returns the Environment which we defined
    # in config.ru. This is useful to carry application dependencies (e.g.
    # logger, repositories, 3rd party services, adapters). In this case we only
    # have a logger defined.
    def self.log_usage(env)
      env.logger.info('Somebody used HelloUser chain')

      # This was defined with #observe which means that the response is not
      # important here and we don't have to return Success/Failure.
    end

    def self.format_response(name)
      Success(
        welcome_message: "Hello #{name}",
        timestamp: Time.now.iso8601
      )
    end
  end
end
