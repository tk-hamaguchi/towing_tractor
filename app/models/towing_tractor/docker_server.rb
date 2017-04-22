module TowingTractor
  class DockerServer < ApplicationRecord
    validates :name,
      presence: true

    validates :url,
      uniqueness: true,
      presence:   true
  end
end
