module Travis::API::V3
  class Models::SSLKey < Model
    belongs_to :repository
  end
end
