class Current < ApplicationRecord
include ActiveSupport::CurrentAttributes

attribute :user
end
