module Demo
  module Input
    def self.verify(schema, input)
      result = schema.call(input)
      if result.success?
        Deterministic::Result::Success(result.output)
      else
        Deterministic::Result::Failure(
          Errors::InvalidInput.new(errors: result.errors, hints: result.hints)
        )
      end
    end
  end
end
