module Auth::Representer
  class User < Representable::Decorator
    include Representable::JSON

    property :id
    property :email
    property :name
    property :role
    property :avatar
    property :created_at, as: :createdAt, exec_context: :decorator
    property :updated_at, as: :updatedAt, exec_context: :decorator

    def created_at
      represented.created_at.iso8601
    end

    def updated_at
      represented.updated_at.iso8601
    end
  end
end